//
//  DataManager.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 27.09.2023.
//

import Foundation
import UIKit
 
final class DataManager {
    private let networkManager: NetworkManager

     init(networkManager: NetworkManager) {
         self.networkManager = networkManager
     }

    func createViewDetailedForecast(from coordinates: Coordinates) async -> DetailForecast? {
            do {
                let forecast = try await networkManager.fetchOneDayForecast(coordinates: coordinates)
                let windSpeed = "\(forecast.wind.speed)"
                let temp = forecast.main.temp.kelvinToCelsius()
                let humidity = "\(forecast.main.humidity)"
                let iconCode = forecast.weather.first?.icon ?? ""
                let name = forecast.name
                let date = dateFormatting(from: forecast.dt)
                
                let iconImageData = try await fetchIconImageData(iconCode: iconCode)
                
                return DetailForecast(name: name, date: date, temp: temp, windSpeed: windSpeed, humidity: humidity, icon: iconImageData)
            } catch {
                AppLogger.log(level: .error, error)
                return nil
            }
        }
    
    func createViewHourlyDailyForecast(from coordinates: Coordinates) async -> (hourlyForecasts: [HourlyForecast], dailyForecasts: [DailyForecast])? {
        
        var hourlyForecasts: [HourlyForecast] = []
        var dailyForecasts: [DailyForecast] = []

            do {
                let forecast = try await networkManager.fetchFiveDaysForecast(coordinates: coordinates)
                
                for element in forecast.list {
                    let iconCode = element.weather?.first?.icon ?? ""

                      do {
                          let iconImageData = try await fetchIconImageData(iconCode: iconCode)
                          let date = dateFormatting(from: Double(element.dt))
                          let temp = Double(element.main.temp).kelvinToCelsius()
                          let hourlyForecast = HourlyForecast(date: date, temp: temp, icon: iconImageData)
                          hourlyForecasts.append(hourlyForecast)
                      } catch {
                          AppLogger.log(level: .error, "Error fetching icon image data: \(error)")
                      }
                    }
                
                var dailyAverages: [String: (dayTempSum: Double, nightTempSum: Double, dayCount: Int, nightCount: Int, dayIcons: [String], nightIcons: [String])] = [:]
                
                for data in forecast.list {
                    let date = Date(timeIntervalSince1970: TimeInterval(data.dt))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    
                    let dayKey = dateFormatter.string(from: date)
                    
                    let hour = Calendar.current.component(.hour, from: date)
                    let temperature = data.main.temp
                    let iconCode = data.weather?.first?.icon ?? "unknown"
                    
                    if hour >= 6 && hour < 21 {
                        // Daytime temperature and icon code
                        if let existing = dailyAverages[dayKey] {
                            dailyAverages[dayKey] = (existing.dayTempSum + temperature,
                                                      existing.nightTempSum,
                                                      existing.dayCount + 1,
                                                      existing.nightCount,
                                                      existing.dayIcons + [iconCode],
                                                      existing.nightIcons)
                        } else {
                            dailyAverages[dayKey] = (temperature, 0, 1, 0, [iconCode], [])
                        }
                    } else {
                        // Nighttime temperature and icon code
                        if let existing = dailyAverages[dayKey] {
                            dailyAverages[dayKey] = (existing.dayTempSum,
                                                      existing.nightTempSum + temperature,
                                                      existing.dayCount,
                                                      existing.nightCount + 1,
                                                      existing.dayIcons,
                                                      existing.nightIcons + [iconCode])
                        } else {
                            dailyAverages[dayKey] = (0, temperature, 0, 1, [], [iconCode])
                        }
                    }
                }
                
                // Calculate the average temperature and icon code for each day
                for (day, temps) in dailyAverages {
                    let dayAverage = temps.dayCount > 0 ? temps.dayTempSum / Double(temps.dayCount) : 0
                    let nightAverage = temps.nightCount > 0 ? temps.nightTempSum / Double(temps.nightCount) : 0
                    
                    let dayAverageStr = dayAverage.kelvinToCelsius()
                    let nightAverageStr = nightAverage.kelvinToCelsius()
                    
                    // Calculate the most frequent icon code for day and night
                    let mostFrequentDayIcon = temps.dayIcons.reduce(into: [:]) { counts, iconCode in counts[iconCode, default: 0] += 1 }
                        .max { $0.value < $1.value }?.key ?? "unknown"
                    let mostFrequentNightIcon = temps.nightIcons.reduce(into: [:]) { counts, iconCode in counts[iconCode, default: 0] += 1 }
                        .max { $0.value < $1.value }?.key ?? "unknown"
                    

                    do {
                        let iconImageData = try await fetchIconImageData(iconCode: mostFrequentDayIcon)
                        let dailyForecast = DailyForecast(day: day, dayTemp: dayAverageStr, nightTemp: nightAverageStr, icon: iconImageData)
                        dailyForecasts.append(dailyForecast)
                    } catch {
                        AppLogger.log(level: .error, "Error fetching icon image data: \(error)")
                    }
                }
            } catch {
                AppLogger.log(level: .error, error)
            }
        
        dailyForecasts.sort {$0.day < $1.day}
        
        return (hourlyForecasts, dailyForecasts)
        }
    
    private func dateFormatting(from date: Double) -> String {
        
        let timestamp: TimeInterval = date
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    

}

extension DataManager{
    private func fetchIconImageData(iconCode: String) async throws -> Data? {
        let url = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
        guard let imageURL = url else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            return data
        } catch {
            throw error
        }
    }
}


