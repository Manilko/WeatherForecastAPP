//
//  Place.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation


struct Place{
    let name: String
    let formattedAddress: String
    let id: String
    let coordinates: Coordinates
}

extension Place{
    init(){
        self.name = ""
        self.formattedAddress = ""
        self.id = ""
        self.coordinates = Coordinates(latitude: 0.0, longitude: 0.0)
    }
    
    init(coordinates: Coordinates){
        self.name = ""
        self.formattedAddress = ""
        self.id = ""
        self.coordinates = coordinates
    }
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
