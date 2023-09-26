//
//  ForecastScreen.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 27.09.2023.
//

import Foundation
import UIKit

struct DetailForecast: Codable {
    let name: String
    let date: String
    let temp: String
    let windSpeed: String
    let humidity: String
    let icon: Data?
}

struct HourlyForecast: Codable {
    let date: String
    let temp: String
    let icon: Data?
}

struct DailyForecast: Codable {
    let day: String
    let dayTemp: String
    let nightTemp: String
    let icon: Data?
}

