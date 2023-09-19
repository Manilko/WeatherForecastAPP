//
//  MarkerInfoView.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation
import UIKit


final class MarkerInfoView: UIView{
    
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Address"

        return label
    }()
    
    private var addressDetailsLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)

        return label
    }()

    public func setUI(with name: String) {
        
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        layer.cornerRadius = 12

        titleLabel.frame = CGRect.init(x: 8, y: 8, width: frame.size.width - 16, height: 15)
        addressDetailsLabel.frame = CGRect.init(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y + titleLabel.frame.size.height + 3, width: frame.size.width - 16, height: 15)
        addressDetailsLabel.text = name

        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        self.addSubview(addressDetailsLabel)
    }
    
    deinit {
        print("instance MarkerInfoView deinited")
    }
}
