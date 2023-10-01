//
//  ForecastFiveDays.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation


struct ForecastFiveDaysResponse: Codable {
    let list: [List]?
//    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let dt: TimeInterval
    let main: MainClass
    let weather: [Weather]?
    let wind: Wind
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}
