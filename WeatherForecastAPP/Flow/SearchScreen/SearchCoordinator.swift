//
//  SearchCoordinator.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation
import UIKit

protocol SearchViewControllerDelegate: AnyObject {
}

class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let coordinates: Coordinates
    
    init(navigationController: UINavigationController, coordinates: Coordinates) {
        self.navigationController = navigationController
        self.coordinates = coordinates
    }
    
    func start() {
        let placeAddressViewController = SearchViewController(coordinates: coordinates)
        navigationController.pushViewController(placeAddressViewController, animated: true)
    }
    
}
