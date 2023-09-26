//
//  ViewSeparatable.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 26.09.2023.
//

import Foundation
import UIKit

protocol ViewSeparatable {
    associatedtype RootView: UIView
}

extension ViewSeparatable where Self: UIViewController {
    func view() -> RootView {
        guard let view = self.view as? RootView else {
            return RootView()
        }
        return view
    }
}
