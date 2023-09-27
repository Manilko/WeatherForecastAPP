//
//  AppConstants.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation

// MARK: constants
struct AppConstants {
    
    
    struct DateFormatType {
        static let shortDateFormat = "E, dd MMMM"
        static let longDateFormat = "yyyy-MM-dd, E HH"
        static let mediumDateFormat = "yyyy-MM-dd, E"
        static let hoursDateFormat = "HH"
        static let dayDateFormat = "E"
    }
    
    
    
    static let apiKey = "AIzaSyABAJzP7HAiQebd3nywFwf4BWM8cw6x6zY"
    static let googleapisUrl: String = "https://maps.googleapis.com/maps/api/geocode/json"
    static let openWeatherOneDayUrl: String = "https://api.openweathermap.org/data/2.5/weather"
    static let openweatherAPPid: String = "ad0d72a9ee8f80c6f3a372c5140f108e"
    static let openWeatherFiveDaysUrl: String = "https://api.openweathermap.org/data/2.5/forecast"
    static let gmsPlacesClientKey: String = "AIzaSyAIVCKmeKLQ_44T7ix9X-USNLyZxg1TPAU"
    static let gmsServicesapiKey: String = "AIzaSyB2adROZbx4bAu4xeR8ywMm3zCthUmTRn0"
}


