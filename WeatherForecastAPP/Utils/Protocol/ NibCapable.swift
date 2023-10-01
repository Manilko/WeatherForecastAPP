//
//   NibCapable.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 29.09.2023.
//

import Foundation
import UIKit


protocol NibCapable: AnyObject {
    static var identifier: String { get }
    static func nib() -> UINib
}

extension NibCapable {
    static var identifier: String {
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
