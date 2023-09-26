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
    private let mapViewController: MapViewController
    
    init(navigationController: UINavigationController, mapViewController: MapViewController) {
        self.navigationController = navigationController
        self.mapViewController = mapViewController
    }
    
    func start() {
        navigationController.pushViewController(mapViewController, animated: true)
    }
}
