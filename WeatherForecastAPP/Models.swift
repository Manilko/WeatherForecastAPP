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
    static let openweatherUrl: String = "https://api.openweathermap.org/data/2.5/weather"
    static let openweatherAPPid: String = "ad0d72a9ee8f80c6f3a372c5140f108e"
    static let openweather5Url: String = "https://api.openweathermap.org/data/2.5/forecast"
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
