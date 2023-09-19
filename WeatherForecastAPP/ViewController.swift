//
//  ViewController.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let networkManager = NetworkManager()
    let coordinates = Coordinates(latitude: 37.7749, longitude: -122.4194)

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Fetch place address
        Task {
            do {
                let placeAddress = try await networkManager.fetchPlaceAddress(coordinates: coordinates)
                print("        >>>>Place Address: \(placeAddress)")
            } catch {
                print("Error fetching place address: \(error)")
            }
        }

        // Fetch 1-day forecast
        Task {
            do {
                let forecast = try await networkManager.fetchOneDayForecast(coordinates: coordinates)
                print("        >>>>1-day Forecast: \(forecast)")
            } catch {
                print("Error fetching 1-day forecast: \(error)")
            }
        }
        
        // Fetch 5-day forecast
        Task {
            do {
                let forecast = try await networkManager.fetchFiveDaysForecast(coordinates: coordinates)
                print("        >>>>5-day Forecast: \(forecast)")
            } catch {
                print("Error fetching 5-day forecast: \(error)")
            }
        }
    }


}

