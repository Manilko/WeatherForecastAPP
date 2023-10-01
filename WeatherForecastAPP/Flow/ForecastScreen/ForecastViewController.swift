//
//  ViewController.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import UIKit
import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class ForecastViewController: UIViewController {
    
    // MARK: - Properties
    private let networkManager = NetworkManager()
    private let mainViewManager: DataManager
    private let locationManager = CLLocationManager()
    weak var delegate: ForecastViewControllerDelegate?
    
    var previousSelectedIndexPath: IndexPath?
    
    private var mainScreen: MainScreen? = nil{
        didSet{
            view().reloadView(mainScreen?.detailForecast)
            view().layoutSubviews()
        }
    }
    

    private var locationForecast: Place{
        didSet{
            getData(from: locationForecast.coordinates) { result in
                switch result {
                case .success(let mainScreen):
                    self.mainScreen = mainScreen
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
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
        view().tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        view().collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
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
    
    private func getData(from coordinates: Coordinates, completion: @escaping (Result<MainScreen, Error>) -> Void) {
        Task {
            do {
                guard let detailForecast = await mainViewManager.createViewDetailedForecast(from: coordinates) else {
                    throw NSError(domain: "YourAppErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get data to detailForecastView"])
                }

                let hourlyDailyForecast = await mainViewManager.createViewHourlyDailyForecast(from: coordinates)

                let mainScreen = MainScreen(detailForecast: detailForecast, hourlyForecast: hourlyDailyForecast?.hourlyForecasts, dailyForecast: hourlyDailyForecast?.dailyForecasts)

                completion(.success(mainScreen))
            } catch {
                completion(.failure(error))
            }
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
        mainScreen?.dailyForecast?.count ?? 0
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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }

        let dayForecast = mainScreen?.dailyForecast?[indexPath.row]
        guard let dayForecast = dayForecast else { return cell }

        cell.configure(with: dayForecast)

        return cell
    }

}

// MARK: - CollectionViewDelegate
extension ForecastViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainScreen?.hourlyForecast?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }

        let hourForecast = mainScreen?.hourlyForecast?[indexPath.row]
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

