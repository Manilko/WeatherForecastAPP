//
//  GenericNetworkManager.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation

protocol GenericNetworkService {
    func fetchData<T: Decodable>(for router: NetworkingRouter, baseURL: String, responseType: T.Type) async throws -> T
}


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
