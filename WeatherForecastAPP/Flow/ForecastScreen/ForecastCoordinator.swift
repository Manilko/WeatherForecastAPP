//
//  ForecastCoordinator.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation
import UIKit


protocol ForecastViewControllerDelegate: AnyObject {
    func goToSearchScreen()
    func goToMapScreen()
}


class ForecastCoordinator: Coordinator {
    var navigationController: UINavigationController
    let forecastViewController: ForecastViewController
    let coordinates = Coordinates(latitude: 37.7749, longitude: -122.4194)

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.forecastViewController = ForecastViewController(coordinates: coordinates)
    }

    func start() {
        forecastViewController.delegate = self
        navigationController.pushViewController(forecastViewController, animated: false)
    }
}

extension ForecastCoordinator: ForecastViewControllerDelegate {
    func goToSearchScreen() {

        let searchViewController = SearchViewController()
        searchViewController.reloadDataDelegate = forecastViewController

        let searchCoordinator = SearchCoordinator(navigationController: navigationController, searchViewController: searchViewController)
        searchCoordinator.start()

    }

    func goToMapScreen() {
        let mapViewController = MapViewController()
            mapViewController.reloadDataDelegate = forecastViewController
        
        let mapCoordinator = MapCoordinator(navigationController: navigationController, mapViewController: mapViewController)
        mapCoordinator.start()
    }
}
