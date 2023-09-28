//
//  ForecastDataReloadDelegate.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 26.09.2023.
//

import Foundation

protocol ForecastDataReloadDelegate: AnyObject {
    func reloadData(with place: Place)
}
