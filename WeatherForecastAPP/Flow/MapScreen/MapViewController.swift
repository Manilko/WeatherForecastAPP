//
//  MapViewController.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation
import UIKit

final class MapViewController: UIViewController {
    
    private let coordinates: Coordinates

    init(coordinates: Coordinates) {
        self.coordinates = coordinates
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupUI()
        // Implement any other setup or data loading based on coordinates
    }

    private func setupUI() {
        // Implement UI setup for the Forecast screen
        // You can use labels, collection views, etc., to display forecast information
    }

    // Implement other methods and logic for the Forecast screen
}
