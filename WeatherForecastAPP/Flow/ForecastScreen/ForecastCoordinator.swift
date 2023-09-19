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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let coordinates = Coordinates(latitude: 37.7749, longitude: -122.4194)
        let homeViewController = ForecastViewController(coordinates: coordinates)
        homeViewController.delegate = self
        navigationController.pushViewController(homeViewController, animated: false)
    }
}

extension ForecastCoordinator: ForecastViewControllerDelegate {
    func goToSearchScreen() {
        let coordinates = Coordinates(latitude: 37.7749, longitude: -122.4194)  // Sample coordinates
        let placeAddressCoordinator = SearchCoordinator(navigationController: navigationController, coordinates: coordinates)
        placeAddressCoordinator.start()
    }
    
    func goToMapScreen() {
        let coordinates = Coordinates(latitude: 37.7749, longitude: -122.4194)  // Sample coordinates
        let forecastCoordinator = MapCoordinator(navigationController: navigationController, coordinates: coordinates)
        forecastCoordinator.start()
    }
}
