//
//  OneDay.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation

struct OneDayForecast: Codable {
    let coord: CoordOneDay
    let weather: [WeatherOneDay]
    let base: String
//    let main: Main
    let visibility: Int
//    let wind: WindOneDay
    let clouds: CloudsOneDay
    let dt: Int
    let sys: SysOneDay
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct CloudsOneDay: Codable {
    let all: Int
}

// MARK: - Coord
struct CoordOneDay: Codable {
    let lon, lat: Double
}

// MARK: - Main
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

// MARK: - Sys
struct SysOneDay: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct WeatherOneDay: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct WindOneDay: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
