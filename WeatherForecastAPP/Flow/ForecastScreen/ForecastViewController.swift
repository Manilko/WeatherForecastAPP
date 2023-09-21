//
//  ViewController.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import UIKit

protocol Delegate: AnyObject {
    func reload(place: Place)
}

extension ForecastViewController: Delegate{
    
    func reload(place: Place) {
        self.ImNow = place
        self.coordinates = place.coordinates
        
//        view().layoutIfNeeded()
        view().viewV.backgroundColor = .yellow
        view().layoutSubviews()
    }
}


class ForecastViewController: UIViewController {
    
    weak var delegate: ForecastViewControllerDelegate?
    
    private var ImNow: Place
    
    private let networkManager = NetworkManager()
     var coordinates: Coordinates

    init(coordinates: Coordinates) {
        self.coordinates = coordinates
        self.ImNow = Place(name: "", formattedAddress: "", id: "", coordinates: coordinates)
        super.init(nibName: nil, bundle: nil)
        
        view().placeAddressButton.addTarget(self, action: #selector(goToSearch), for: .touchUpInside)
        view().forecastButton.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
        view().collectionView.delegate = self
        view().collectionView.dataSource = self
        view().tableView.delegate = self
        view().tableView.dataSource = self
        view().tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
        

//        verificationData ()
    }
    

    @objc private func goToSearch() {
        delegate?.goToSearchScreen()
        print(ImNow.coordinates)
    }

    @objc private func goToMap() {
        delegate?.goToMapScreen()
        print(coordinates)
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = " coordinates \(ImNow.coordinates)"
        return cell
    }

}

extension ForecastViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
        
        cell.backgroundColor = .blue
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}

extension ForecastViewController: ViewSeparatable {
    typealias RootView = ForecastView
}




protocol ViewSeparatable {
    associatedtype RootView: UIView
}

extension ViewSeparatable where Self: UIViewController {
    func view() -> RootView {
        guard let view = self.view as? RootView else {
            return RootView()
        }
        return view
    }
}

final class SurveyFAQCell: UITableViewCell {
}


extension ForecastViewController{
    private func verificationData () {
        
        //     Fetch place address
        Task {
            do {
                let placeAddress = try await networkManager.fetchPlaceAddress(coordinates: coordinates)
                AppLogger.log(level: .info, placeAddress)
            } catch {
                AppLogger.log(level: .error, error)
            }
        }
        
        // Fetch 1-day forecast
        Task {
            do {
                let forecast = try await networkManager.fetchOneDayForecast(coordinates: coordinates)
                AppLogger.log(level: .info, forecast)
            } catch {
                AppLogger.log(level: .error, error)
            }
        }
        
        // Fetch 5-day forecast
        Task {
            do {
                let forecast = try await networkManager.fetchFiveDaysForecast(coordinates: coordinates)
                AppLogger.log(level: .info, forecast)
            } catch {
                AppLogger.log(level: .error, error)
            }
        }
    }
}
