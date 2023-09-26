//
//  String.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 27.09.2023.
//

import Foundation
import UIKit

extension String{
    func changeDateFormat(inputFormat: String = "MM/dd/yyyy", outputFormat: String) -> String? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = inputFormat
        
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = outputFormat
        
        guard let date = dateFormatterInput.date(from: self) else {
            print("Invalid date string")
            return nil
        }
        
        return dateFormatterOutput.string(from: date)
    }
}
