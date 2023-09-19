//
//  Networking.swift
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

// MARK: Error
    enum APIError: Error {
        case badRequest
        case serverError
        case unknown
    }

    enum ComputerAPIError: Error {
        case nilRequest
        case invalidResponseFormat
    }
    
// MARK: APIRequestProtocol
    protocol APIRequestProtocol {
        func get(request: URLRequest) async throws -> Result<Data, Error>
    }
    

// MARK: APIRequest
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
    

// MARK: GenericNetworkService
protocol GenericNetworkService {
    func fetchData<T: Decodable>(for router: NetworkingRouter, baseURL: String, responseType: T.Type) async throws -> T
}

// MARK: GenericNetworkManager
final class GenericNetworkManager: GenericNetworkService {
    private let apiRequest: APIRequestProtocol
    
    init(apiRequest: APIRequestProtocol = APIRequest()) {
        self.apiRequest = apiRequest
    }
    
    func fetchData<T: Decodable>(for router: NetworkingRouter, baseURL: String, responseType: T.Type) async throws -> T {
        let request = try router.asURLRequest(urlString: baseURL)
        let apiData = try await apiRequest.get(request: request)
        
        switch apiData {
        case .success(let data):
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        case .failure(let error):
            throw error
        }
    }
}


// MARK: class NetworkManager
final class NetworkManager {
    private let genericNetworkService: GenericNetworkService
    
    init(genericNetworkService: GenericNetworkService = GenericNetworkManager()) {
        self.genericNetworkService = genericNetworkService
    }
    
    func fetchPlaceAddress(coordinates: Coordinates) async throws -> ResponseJSON {
        let urlString = Constants.googleapisUrl
        return try await genericNetworkService.fetchData(for: NetworkingRouter.getPlaceAddress(coordinates: coordinates), baseURL: urlString, responseType: ResponseJSON.self)
    }
    
    func fetchOneDayForecast(coordinates: Coordinates) async throws -> OneDayForecast {
        let urlString = Constants.openWeatherOneDayUrl
        return try await genericNetworkService.fetchData(for: NetworkingRouter.getFiveDaysForecast(coordinates: coordinates), baseURL: urlString, responseType: OneDayForecast.self)
    }
    
    func fetchFiveDaysForecast(coordinates: Coordinates) async throws -> ForecastFiveDaysResponse {
        let urlString = Constants.openWeatherFiveDaysUrl
        return try await genericNetworkService.fetchData(for: NetworkingRouter.getFiveDaysForecast(coordinates: coordinates), baseURL: urlString, responseType: ForecastFiveDaysResponse.self)
    }
}

