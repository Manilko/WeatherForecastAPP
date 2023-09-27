//
//  ForecastView.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 21.09.2023.
//

import Foundation
import UIKit

final class ForecastView: UIView{
   
   // MARK: - Properties
   lazy var scrollView: UIScrollView = {
          let scrollView = UIScrollView()
          scrollView.translatesAutoresizingMaskIntoConstraints = false
          return scrollView
      }()

   lazy var contentView: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
   }()

    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonImage = UIImage(named: "search")
        button.setImage(buttonImage, for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()

    lazy var mapButton: UIButton = {
        let button = UIButton(type: .system)
        let buttonImage = UIImage(named: "map")
        button.setImage(buttonImage, for: .normal)
        button.layoutIfNeeded()
        button.subviews.first?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
   lazy var buttonStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [searchButton, mapButton])
       stackView.axis = .horizontal
       stackView.spacing = 16
       stackView.distribution = .fillEqually
       stackView.translatesAutoresizingMaskIntoConstraints = false
       return stackView
   }()

   lazy var detailedForecastView: UIView = {
       let view = UIView()
       view.backgroundColor = #colorLiteral(red: 0.2870183289, green: 0.5633350015, blue: 0.8874290586, alpha: 1)
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
   }()
    
    lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cityView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var detailedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var windLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var detailedStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, humidityLabel, windLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var weekdayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal
       

       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       collectionView.backgroundColor = #colorLiteral(red: 0.3526009917, green: 0.6267325282, blue: 0.942384541, alpha: 1)
       collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
       collectionView.translatesAutoresizingMaskIntoConstraints = false
       return collectionView
    }()

   lazy var tableView: UITableView = {
      let tableView = UITableView()
      tableView.translatesAutoresizingMaskIntoConstraints = false
      return tableView
    }()

   // MARK: - Lifecycle
   required init() {
       super.init(frame: .zero)

       configureLayout()
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

   override func layoutSubviews() {
       super.layoutSubviews()
       tableView.reloadData()
       collectionView.reloadData()
   }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }

    func reloadView(_ model: DetailForecast?) {
        weekdayLabel.text = model?.date.changeDateFormat(outputFormat: AppConstants.DateFormatType.shortDateFormat)
        locationNameLabel.set(text: model?.name ?? "", leftIcon: UIImage(named: "locationWhite"))
        temperatureLabel.set(text: (model?.temp ?? "") + "°" , leftIcon: UIImage(named: "temperature"))
        humidityLabel.set(text: (model?.humidity ?? "") + "%", leftIcon: UIImage(named: "humidity"))
        windLabel.set(text: (model?.windSpeed ?? "") + "м/сек", leftIcon: UIImage(named: "wind"), rightIcon: UIImage(named: "arrow"))
        
        guard let imageData = model?.icon else { return }
        weatherIcon.image = UIImage(data: imageData)
       }


   private func configureLayout() {
       addSubview(scrollView)

       scrollView.addSubview(contentView)
       contentView.addSubview(detailedForecastView)
       contentView.addSubview(collectionView)
       contentView.addSubview(tableView)
       
       detailedForecastView.addSubview(cityView)
       detailedForecastView.addSubview(buttonStack)
       detailedForecastView.addSubview(detailedView)
       
       detailedView.addSubview(weatherIcon)
       detailedView.addSubview(detailedStack)
       
       cityView.addSubview(locationNameLabel)
       cityView.addSubview(weekdayLabel)

       NSLayoutConstraint.activate([
        
           scrollView.topAnchor.constraint(equalTo: topAnchor),
           scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
           scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
           scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        
           contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
           contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
           contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
           contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
           contentView.widthAnchor.constraint(equalTo: widthAnchor),
           contentView.heightAnchor.constraint(equalToConstant: 700),

           cityView.topAnchor.constraint(equalTo: detailedForecastView.safeAreaLayoutGuide.topAnchor, constant: 16),
           cityView.leadingAnchor.constraint(equalTo: detailedForecastView.leadingAnchor, constant: 16),
           cityView.widthAnchor.constraint(equalTo: detailedForecastView.widthAnchor, multiplier: 0.6),
           cityView.heightAnchor.constraint(equalToConstant: 80),
      
           buttonStack.topAnchor.constraint(equalTo: detailedForecastView.safeAreaLayoutGuide.topAnchor, constant: 16),
           buttonStack.leadingAnchor.constraint(equalTo: cityView.trailingAnchor, constant: 8),
           buttonStack.trailingAnchor.constraint(equalTo: detailedForecastView.trailingAnchor, constant: -16),
           buttonStack.heightAnchor.constraint(equalToConstant: 30),
      
           detailedForecastView.topAnchor.constraint(equalTo: contentView.topAnchor),
           detailedForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           detailedForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           detailedForecastView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
       
           detailedView.topAnchor.constraint(equalTo: cityView.bottomAnchor),
           detailedView.leadingAnchor.constraint(equalTo: detailedForecastView.leadingAnchor, constant: 16),
           detailedView.trailingAnchor.constraint(equalTo: detailedForecastView.trailingAnchor, constant: -16),
           detailedView.bottomAnchor.constraint(equalTo: detailedForecastView.bottomAnchor, constant: -16),

           weatherIcon.centerYAnchor.constraint(equalTo: detailedView.centerYAnchor),
           weatherIcon.leadingAnchor.constraint(equalTo: detailedView.leadingAnchor, constant: 16),
           weatherIcon.widthAnchor.constraint(equalTo: detailedView.widthAnchor, multiplier: 0.5),
           weatherIcon.heightAnchor.constraint(equalTo: detailedView.heightAnchor),

           detailedStack.centerYAnchor.constraint(equalTo: detailedView.centerYAnchor),
           detailedStack.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 16),
           detailedStack.trailingAnchor.constraint(equalTo: detailedView.trailingAnchor),
           detailedStack.heightAnchor.constraint(equalTo: detailedView.heightAnchor, multiplier: 0.7),
       
           collectionView.topAnchor.constraint(equalTo: detailedForecastView.bottomAnchor),
           collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25),
           collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      
           tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 4),
           tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
           tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4),
           tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

           locationNameLabel.topAnchor.constraint(equalTo: cityView.topAnchor, constant: 4),
           locationNameLabel.leadingAnchor.constraint(equalTo: cityView.leadingAnchor),
           locationNameLabel.trailingAnchor.constraint(equalTo: cityView.trailingAnchor),
           locationNameLabel.heightAnchor.constraint(equalTo: cityView.heightAnchor, multiplier: 0.6),
      
           weekdayLabel.topAnchor.constraint(equalTo: locationNameLabel.bottomAnchor, constant: 4),
           weekdayLabel.leadingAnchor.constraint(equalTo: cityView.leadingAnchor),
           weekdayLabel.trailingAnchor.constraint(equalTo: cityView.trailingAnchor),
           weekdayLabel.bottomAnchor.constraint(equalTo: cityView.bottomAnchor)
       ])
   }
}

// MARK: - Animation
extension ForecastView{
    func selectCell(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else {
            return
        }
        
        cell.animateSelectCell()
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    func deselectCell(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell else {
            return
        }
    
        cell.animateDeselectCell()
        cell.layer.shadowColor = UIColor.clear.cgColor
    }
}

