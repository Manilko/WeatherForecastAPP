//
//  Networking.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

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
    
//    var path: String {
//        switch self {
//        case .getPlaceAddress:
//            return ""
//        }
//    }
        
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
//        var url = URL(string: Constants.googleapisUrl)!
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

    
    
    class NetworkManager{
        
        func fetchPlaceAddress(coordinates: Coordinates) async throws -> ResponseJSON{
            
            let request = try? NetworkingRouter.getPlaceAddress(coordinates: coordinates).asURLRequest(urlString: Constants.googleapisUrl)
            print(request!)
            
            let session = URLSession.shared
            let (data, response) = try await session.data(for: request!)
            print(data)
            
            let httpurlResponse = response as? HTTPURLResponse
            print("respons1.statusCode = \(httpurlResponse?.statusCode ?? 0)" )
            
            let decoder = JSONDecoder()
            return try decoder.decode(ResponseJSON.self, from: data)
            
        }
        
//        func fetchForecast(coordinates: Coordinates) async throws -> ForecastResponse{
//
//            let request = try? NetworkingRouter.getOneDayForecast(coordinates: coordinates).asURLRequest(urlString: Constants.openweatherUrl)
//            print(request!)
//
//            let session = URLSession.shared
//            let (data, response) = try await session.data(for: request!)
//            print(data)
//
//            let httpurlResponse = response as? HTTPURLResponse
//            print("respons1.statusCode = \(httpurlResponse?.statusCode ?? 0)" )
//
//            let decoder = JSONDecoder()
//            return try decoder.decode(ForecastResponse.self, from: data)
//
//        }
        
        func fetch5Forecast(coordinates: Coordinates) async throws -> Forecast5Response{
            
            let request = try? NetworkingRouter.getOneDayForecast(coordinates: coordinates).asURLRequest(urlString: Constants.openweather5Url)
            print(request!)
            
            let session = URLSession.shared
            let (data, response) = try await session.data(for: request!)
            print(data)
            
            let httpurlResponse = response as? HTTPURLResponse
            print("respons1.statusCode = \(httpurlResponse?.statusCode ?? 0)" )
            
            let decoder = JSONDecoder()
            return try decoder.decode(Forecast5Response.self, from: data)
            
        }
        
    }
    
    
    
    enum APIError: Error {
        case badRequest
        case serverError
        case unknown
    }
    
    protocol APIRequestProtocol {
        func get(request: URLRequest) async throws -> Result<Data, Error>
    }
    
    final class APIRequest: APIRequestProtocol {
        
        func get(request: URLRequest) async throws -> Result<Data, Error> {
            let (data, response) = try await URLSession.shared.data(for: request)
            return verifyResponse(data: data, response: response)
        }
        
        private func verifyResponse(data: Data, response: URLResponse) -> Result<Data, Error> {
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(APIError.unknown)
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return .success(data)
            case 400...499:
                return .failure(APIError.badRequest)
            case 500...599:
                return .failure(APIError.serverError)
            default:
                return .failure(APIError.unknown)
                
            }
        }
    }
    
    
protocol APIProtocol {
    func fetchPlace(with coordinates: Coordinates) async throws -> ResponseJSON?
//    func fetchForecast(with coordinates: Coordinates) async throws -> ForecastResponse?
    func fetch5Forecast(with coordinates: Coordinates) async throws -> Forecast5Response?
}
    
    
    enum ComputerAPIError: Error {
        case nilRequest
        case invalidResponseFormat
    }
    
final class APIService: APIProtocol {
   
    
   
    
    
        private let apiRequest: APIRequestProtocol
        
        init(apiRequest: APIRequestProtocol = APIRequest()) {
            self.apiRequest = apiRequest
        }
        
        func fetchPlace(with coordinates: Coordinates) async throws -> ResponseJSON? {
            
            let request = try? NetworkingRouter.getPlaceAddress(coordinates: coordinates).asURLRequest(urlString: Constants.googleapisUrl)
            guard let urlRequest = request else {
                throw ComputerAPIError.nilRequest
            }
            
            let apiData = try await apiRequest.get(request: urlRequest)
            switch apiData {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    return try decoder.decode(ResponseJSON.self, from: data)
                } catch {
                    throw ComputerAPIError.invalidResponseFormat
                }
            case .failure(let error):
                throw error
            }
        }
    
    
//    func fetchForecast(with coordinates: Coordinates) async throws -> ForecastResponse? {
//        let request = try? NetworkingRouter.getOneDayForecast(coordinates: coordinates).asURLRequest(urlString: Constants.openweatherUrl)
//        guard let urlRequest = request else {
//            throw ComputerAPIError.nilRequest
//        }
//
//        let apiData = try await apiRequest.get(request: urlRequest)
//        switch apiData {
//        case .success(let data):
//            let decoder = JSONDecoder()
//            do {
//                return try decoder.decode(ForecastResponse.self, from: data)
//            } catch {
//                throw ComputerAPIError.invalidResponseFormat
//            }
//        case .failure(let error):
//            throw error
//        }
//    }
    
    func fetch5Forecast(with coordinates: Coordinates) async throws -> Forecast5Response? {
        
        let request = try? NetworkingRouter.getFiveDaysForecast(coordinates: coordinates).asURLRequest(urlString: Constants.openweather5Url)
        guard let urlRequest = request else {
            throw ComputerAPIError.nilRequest
        }
        
        let apiData = try await apiRequest.get(request: urlRequest)
        switch apiData {
        case .success(let data):
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(Forecast5Response.self, from: data)
            } catch {
                throw ComputerAPIError.invalidResponseFormat
            }
        case .failure(let error):
            throw error
        }
    }
    
    
    }



