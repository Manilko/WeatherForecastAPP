//
//  OneDay.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation
import UIKit

struct OneDayForecast: Codable {
    let weather: [WeatherOneDay]
    let main: Main
    let wind: WindOneDay
    let dt: Double
    let name: String
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct WeatherOneDay: Codable {
    let id: Int
    let main, description, icon: String
}

struct WindOneDay: Codable {
    let speed: Double
}
