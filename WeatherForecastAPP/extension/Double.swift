//
//  Double.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 27.09.2023.
//

import Foundation
import UIKit

extension Double{
    func kelvinToCelsius() -> String {
        String(format: "%.f", self - 273.15)
    }
}
