//
//  CollectionViewCell.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 27.09.2023.
//

import Foundation
import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 0.9999999404, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 0.9999999404, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    
    private lazy var pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func configure(with model: HourlyForecast){
        topLabel.text = (model.date.changeDateFormat(outputFormat: AppConstants.DateFormatType.hoursDateFormat) ?? "") + "°°"
        bottomLabel.text = model.temp + "°"
        if let imageData = model.icon{
            pictureView.image = UIImage(data: imageData)
        }
    }
    
    private func setupUI() {
        addSubview(topLabel)
        addSubview(bottomLabel)
        addSubview(pictureView)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: topAnchor),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            pictureView.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
            pictureView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pictureView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pictureView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            bottomLabel.topAnchor.constraint(equalTo: pictureView.bottomAnchor),
            bottomLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

