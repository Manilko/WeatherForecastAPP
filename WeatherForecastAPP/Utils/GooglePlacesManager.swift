//
//  GooglePlacesManager.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation
import UIKit
import GooglePlaces

class GooglePlacesManager {

    static let shared = GooglePlacesManager()
    private let client = GMSPlacesClient.shared()
    
    private init(){}
    
    public func findPlaces(query: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.types = ["locality"]

        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { result, error in
            guard let result = result, error == nil else {
                completion(.failure(PlaceError.errorPlace))
                return
            }
            
//            AppLogger.log(level: .debug, result)

            var places: [Place] = []
            let dispatchGroup = DispatchGroup()

            for prediction in result {
                let placeID = prediction.placeID

                dispatchGroup.enter()

                self.client.lookUpPlaceID(placeID) { place, error in
                    defer {
                        dispatchGroup.leave()
                    }

                    guard let place = place, error == nil else {
                        completion(.failure(PlaceError.errorСoordinate))
                        return
                    }

                    let searchedLatitude = place.coordinate.latitude
                    let searchedLongitude = place.coordinate.longitude

                    let newPlace = Place(name: prediction.attributedFullText.string,
                                         formattedAddress: "",
                                         id: prediction.placeID,
                                         coordinates: Coordinates(latitude: searchedLatitude, longitude: searchedLongitude))

                    places.append(newPlace)
                }
            }

            dispatchGroup.notify(queue: .main) {
                if places.isEmpty {
                    completion(.failure(PlaceError.errorPlace))
                } else {
                    completion(.success(places))
                }
            }
        }
    }
}

