//
//  Models.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation


// MARK: constants
struct Constants {
    static let apiKey = "AIzaSyABAJzP7HAiQebd3nywFwf4BWM8cw6x6zY"
    static let googleapisUrl: String = "https://maps.googleapis.com/maps/api/geocode/json"
    static let openWeatherOneDayUrl: String = "https://api.openweathermap.org/data/2.5/weather"
    static let openweatherAPPid: String = "ad0d72a9ee8f80c6f3a372c5140f108e"
    static let openWeatherFiveDaysUrl: String = "https://api.openweathermap.org/data/2.5/forecast"
}

// MARK: Models

struct Place{
    let name: String
    let formattedAddress: String
    let id: String
    let coordinates: Coordinates
}

struct Coordinates: Equatable{
    let latitude: Double
    let longitude: Double
}

enum PlaceError: Error{
    case errorPlace
    case errorСoordinate
}

struct ResponseJSON: Codable {
    let results: [AddressResult]
}

// MARK: - Result
struct AddressResult: Codable {
    let addressComponents: [AddressComponent]
    let formattedAddress, placeID: String

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case placeID = "place_id"
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let longName, shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}



// MARK: - Forecast5Response
struct ForecastFiveDaysResponse: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
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
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: MainEnum
    let description: Description
    let icon: String
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}



// MARK: - OneDayForecast
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
