//
//  MapCoordinator.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import UIKit

protocol MapViewControllerDelegate: AnyObject {
    
}

class MapCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let coordinates: Coordinates
    
    init(navigationController: UINavigationController, coordinates: Coordinates) {
        self.navigationController = navigationController
        self.coordinates = coordinates
    }
    
    func start() {
        let forecastViewController = MapViewController(coordinates: coordinates)
        navigationController.pushViewController(forecastViewController, animated: true)
    }
}
