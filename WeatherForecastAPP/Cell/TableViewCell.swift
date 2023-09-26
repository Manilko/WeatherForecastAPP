//
//  CustomTableViewCell.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 27.09.2023.
//

import Foundation
import UIKit

final class TableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0)
        return label
    }()
    
    private lazy var pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func configure(with model: DailyForecast){
        leftLabel.text = model.day.changeDateFormat(outputFormat: "E")
        rightLabel.text = "\(model.dayTemp)°/\(model.nightTemp)°"
        if let imageData = model.icon{
            pictureView.image = UIImage(data: imageData)
        }
    }
    
    func animateSelectCell(){
        leftLabel.textColor = #colorLiteral(red: 0.2870183289, green: 0.5633350015, blue: 0.8874290586, alpha: 1)
        leftLabel.layer.shadowColor = UIColor.black.cgColor
        leftLabel.layer.shadowOpacity = 0.2
        leftLabel.layer.shadowRadius = 2
        leftLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        rightLabel.textColor = #colorLiteral(red: 0.2870183289, green: 0.5633350015, blue: 0.8874290586, alpha: 1)
        rightLabel.layer.shadowColor = UIColor.black.cgColor
        rightLabel.layer.shadowOpacity = 0.2
        rightLabel.layer.shadowRadius = 2
        rightLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func animateDeselectCell(){
        leftLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        leftLabel.layer.shadowColor = UIColor.clear.cgColor
        
        rightLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        rightLabel.layer.shadowColor = UIColor.clear.cgColor
    }
    
    
    private func setupUI() {
        
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(pictureView)

        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            leftLabel.topAnchor.constraint(equalTo: topAnchor),
            leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            leftLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            pictureView.topAnchor.constraint(equalTo: topAnchor),
            pictureView.leadingAnchor.constraint(equalTo: rightLabel.trailingAnchor),
            pictureView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pictureView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            rightLabel.topAnchor.constraint(equalTo: topAnchor),
            rightLabel.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor),
            rightLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            rightLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
