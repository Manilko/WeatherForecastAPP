//
//  SearchViewController.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation
import UIKit
import GooglePlaces

final class SearchViewController: UIViewController {
    
    weak var reloadDataDelegate: ForecastDataReloadDelegate?
    let resultVC = UISearchController(searchResultsController: ResultViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        resultVC.searchBar.backgroundColor = .secondarySystemBackground
        resultVC.searchResultsUpdater = self
        
        navigationItem.searchController = resultVC
    }

}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let query = searchController.searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultVC = searchController.searchResultsController as? ResultViewController
        else {return}
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result{
            case .success(let places):
                DispatchQueue.main.async {
                    resultVC.update(with: places)
                    resultVC.callBack = { selectedLocation in
                        self.reloadDataDelegate?.reloadData(with: selectedLocation)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case.failure(let error):
                AppLogger.log(level: .error, error)
            }
        }
    }
    
}


