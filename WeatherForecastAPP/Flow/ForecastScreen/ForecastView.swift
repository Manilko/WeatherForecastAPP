//
//  ForecastView.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 21.09.2023.
//

import Foundation
import UIKit
class ForecastView: UIView{
   
   // MARK: - Properties
   lazy var scrollView: UIScrollView = {
          let scrollView = UIScrollView()
          scrollView.translatesAutoresizingMaskIntoConstraints = false
          return scrollView
      }()


   lazy var contentView: UIView = {
       let viewV = UIView()
       viewV.backgroundColor = .red
       viewV.translatesAutoresizingMaskIntoConstraints = false
       return viewV
   }()


   lazy var placeAddressButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Go to Place Address", for: .normal)
       button.backgroundColor = .red
       return button
   }()

   lazy var forecastButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Go to Forecast", for: .normal)
       button.backgroundColor = .red
       return button
   }()

   lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [placeAddressButton, forecastButton])
       stackView.axis = .horizontal
       stackView.spacing = 16
       stackView.distribution = .fillEqually
       stackView.backgroundColor = .green
       stackView.translatesAutoresizingMaskIntoConstraints = false
       return stackView
   }()

   lazy var viewV: UIView = {
       let viewV = UIView()

       viewV.backgroundColor = .blue
       viewV.translatesAutoresizingMaskIntoConstraints = false
       return viewV
   }()

   lazy var collectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal

           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
   }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
//         tableView.reloadData()
    }
//
//    func reloadTableViewData() {
//           tableView.reloadData()
//       }
//

   private func configureLayout() {
       addSubview(scrollView)

       scrollView.addSubview(contentView)

       contentView.addSubview(stackView)
       contentView.addSubview(viewV)
       contentView.addSubview(collectionView)
       contentView.addSubview(tableView)

       NSLayoutConstraint.activate([
           contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
           contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
           contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
           contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
           contentView.widthAnchor.constraint(equalTo: widthAnchor),
           contentView.heightAnchor.constraint(equalToConstant: 700)
       ])

       NSLayoutConstraint.activate([
               scrollView.topAnchor.constraint(equalTo: topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

       NSLayoutConstraint.activate([
           stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
           stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
           stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
       ])

       NSLayoutConstraint.activate([
           viewV.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
           viewV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
           viewV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
           viewV.heightAnchor.constraint(equalToConstant: 260)
       ])

       NSLayoutConstraint.activate([
           collectionView.topAnchor.constraint(equalTo: viewV.bottomAnchor, constant: 16),
           collectionView.heightAnchor.constraint(equalToConstant: 50),
           collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
           collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
       ])

       NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
           tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
       ])

   }
}
