//
//  NetworkManager.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation


final class NetworkManager {
    private let genericNetworkService: GenericNetworkService
    
    init(genericNetworkService: GenericNetworkService = GenericNetworkManager()) {
        self.genericNetworkService = genericNetworkService
    }
    
    func fetchPlaceAddress(coordinates: Coordinates) async throws -> ResponseJSON {
        let urlString = AppConstants.googleapisUrl
        return try await genericNetworkService.fetchData(for: NetworkingRouter.getPlaceAddress(coordinates: coordinates), baseURL: urlString, responseType: ResponseJSON.self)
    }
    
    func fetchOneDayForecast(coordinates: Coordinates) async throws -> OneDayForecast {
        let urlString = AppConstants.openWeatherOneDayUrl
        return try await genericNetworkService.fetchData(for: NetworkingRouter.getFiveDaysForecast(coordinates: coordinates), baseURL: urlString, responseType: OneDayForecast.self)
    }
    
    func fetchFiveDaysForecast(coordinates: Coordinates) async throws -> ForecastFiveDaysResponse {
        let urlString = AppConstants.openWeatherFiveDaysUrl
        return try await genericNetworkService.fetchData(for: NetworkingRouter.getFiveDaysForecast(coordinates: coordinates), baseURL: urlString, responseType: ForecastFiveDaysResponse.self)
    }
}
