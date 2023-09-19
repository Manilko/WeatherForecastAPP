//
//  Error.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation

    enum APIError: Error {
        case badRequest
        case serverError
        case unknown
    }

    enum ComputerAPIError: Error {
        case nilRequest
        case invalidResponseFormat
    }
