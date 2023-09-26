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
    private let searchViewController: SearchViewController
    
    init(navigationController: UINavigationController, searchViewController: SearchViewController) {
        self.navigationController = navigationController
        self.searchViewController = searchViewController
    }
    
    func start() {
        navigationController.pushViewController(searchViewController, animated: true)
    }
    
}
