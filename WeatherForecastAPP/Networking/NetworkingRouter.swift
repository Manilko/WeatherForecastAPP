//
//  NetworkingRouter.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation


// MARK: HTTPMethod
enum HTTPMethod: String {
    case get = "GET"
}

// MARK: NetworkingRouter
enum NetworkingRouter {
    case getPlaceAddress(coordinates: Coordinates)
    case getOneDayForecast(coordinates: Coordinates)
    case getFiveDaysForecast(coordinates: Coordinates)
    
}

extension NetworkingRouter {
    
    var method: HTTPMethod {
        switch self {
        case .getPlaceAddress:
            return .get
        case .getOneDayForecast:
            return .get
        case .getFiveDaysForecast:
            return .get
        }
    }
        
    var queryItem: [URLQueryItem] {
        switch self {
        case .getPlaceAddress(let coordinates):
            return [
                URLQueryItem(name: "latlng", value: "\(coordinates.latitude),\(coordinates.longitude)"),
                URLQueryItem(name: "key", value: Constants.apiKey)
            ]
        case .getOneDayForecast(coordinates: let coordinates):
            return [
                URLQueryItem(name: "lat", value: "\(coordinates.latitude)"),
                URLQueryItem(name: "lon", value: "\(coordinates.longitude)"),
                URLQueryItem(name: "cnt", value: "\(4)"),
                URLQueryItem(name: "appid", value: Constants.openweatherAPPid)
            ]
        case .getFiveDaysForecast(coordinates: let coordinates):
            return [
                URLQueryItem(name: "lat", value: "\(coordinates.latitude)"),
                URLQueryItem(name: "lon", value: "\(coordinates.longitude)"),
                URLQueryItem(name: "appid", value: Constants.openweatherAPPid)
            ]
        }
    }
        
        
    func asURLRequest(urlString: String) throws -> URLRequest {
        var url = URL(string: urlString)!
        url.append(queryItems: queryItem)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = Double.infinity
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        print(urlRequest)
        return urlRequest
    }
}
