//
//  ViewController.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import UIKit
import Foundation
import CoreLocation

final class ForecastViewController: UIViewController {
    
    // MARK: - Properties
    private let networkManager = NetworkManager()
    private let mainViewManager: DataManager
    private let locationManager = CLLocationManager()
    weak var delegate: ForecastViewControllerDelegate?
    
    var previousSelectedIndexPath: IndexPath?
    
    private var detailForecast: DetailForecast? = nil{
        didSet{
            
            view().reloadView(detailForecast)
            view().layoutSubviews()
        }
    }
    private var hourlyForecast: [HourlyForecast]? = nil{
        didSet{
            view().layoutSubviews()
        }
    }
    private var dailyForecast: [DailyForecast]? = nil{
        didSet{
            view().layoutSubviews()
        }
    }

    private var locationForecast: Place{
        didSet{
            
            getData(from: locationForecast.coordinates)
        }
    }
    

    init(coordinates: Coordinates) {
        self.locationForecast = Place(coordinates: coordinates)
        self.mainViewManager = DataManager(networkManager: networkManager)
        
        super.init(nibName: nil, bundle: nil)
        
        view().searchButton.addTarget(self, action: #selector(goToSearch), for: .touchUpInside)
        view().mapButton.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
        view().collectionView.delegate = self
        view().collectionView.dataSource = self
        view().tableView.delegate = self
        view().tableView.dataSource = self
        view().tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        view().collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = ForecastView()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  #colorLiteral(red: 0.2870183289, green: 0.5633350015, blue: 0.8874290586, alpha: 1)
        
        locationManager.delegate = self
        setLocationManager()

    }
    
    private func setLocationManager() {
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.requestLocation()
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            } else{
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    private func getData(from coordinates: Coordinates) {
        
        Task {
            let detailForecast = await mainViewManager.createViewDetailedForecast(from: coordinates)
            if let detailForecast = detailForecast {
                self.detailForecast = detailForecast
//                    AppLogger.log(level: .debug, detailForecast)
            } else {
                AppLogger.log(level: .error, "Failed to get data to detailForecastView")
            }
        }
        
        Task {
            let hourlyDailyForecast = await mainViewManager.createViewHourlyDailyForecast(from: coordinates)
            self.hourlyForecast = hourlyDailyForecast?.hourlyForecasts
            self.dailyForecast = hourlyDailyForecast?.dailyForecasts
        }
    }
    

    @objc private func goToSearch() {
        delegate?.goToSearchScreen()
    }

    @objc private func goToMap() {
        delegate?.goToMapScreen()
    }
}

// MARK: - TableViewDelegate
extension ForecastViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyForecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let previousIndexPath = previousSelectedIndexPath {
            view().deselectCell(at: previousIndexPath)
        }
        
        view().selectCell(at: indexPath)
        previousSelectedIndexPath = indexPath
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }

        let dayForecast = dailyForecast?[indexPath.row]
        guard let dayForecast = dayForecast else { return cell }
        
        cell.configure(with: dayForecast)

        return cell
    }

}

// MARK: - CollectionViewDelegate
extension ForecastViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyForecast?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        let hourForecast = hourlyForecast?[indexPath.row]
        guard let hourForecast = hourForecast else { return cell }
        
        cell.configure(with: hourForecast)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 180)
    }
}

// MARK: - ViewSeparatable
extension ForecastViewController: ViewSeparatable {
    typealias RootView = ForecastView
}

// MARK: - DataReloadDelegate
extension ForecastViewController: ForecastDataReloadDelegate{
    
    func reloadData(with place: Place) {
        self.locationForecast = place
    }
}


// MARK: CLLocationManagerDelegate
extension ForecastViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationForecast = Place(coordinates:  Coordinates(latitude: locations.first?.coordinate.latitude ?? 0.0, longitude: locations.first?.coordinate.longitude ?? 0.0))
        
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .denied:
            return
        case .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.log(level: .error, error)
    }
    
}
