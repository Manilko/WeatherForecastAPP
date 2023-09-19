//
//  ViewController.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import UIKit


class ForecastViewController: UIViewController {
    
    weak var delegate: ForecastViewControllerDelegate?
    private let networkManager = NetworkManager()
    private let coordinates: Coordinates


    lazy var placeAddressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Place Address", for: .normal)
        button.addTarget(self, action: #selector(goToSearch), for: .touchUpInside)
        return button
    }()
    
    lazy var forecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Forecast", for: .normal)
        button.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [placeAddressButton, forecastButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(coordinates: Coordinates) {
        self.coordinates = coordinates
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        verificationData ()
    }
    
    private func verificationData () {

//     Fetch place address
            Task {
                do {
                    let placeAddress = try await networkManager.fetchPlaceAddress(coordinates: coordinates)
                    AppLogger.log(level: .info, placeAddress)
                } catch {
                    AppLogger.log(level: .error, error)
                }
            }

            // Fetch 1-day forecast
            Task {
                do {
                    let forecast = try await networkManager.fetchOneDayForecast(coordinates: coordinates)
                    AppLogger.log(level: .info, forecast)
                } catch {
                    AppLogger.log(level: .error, error)
                }
            }

            // Fetch 5-day forecast
            Task {
                do {
                    let forecast = try await networkManager.fetchFiveDaysForecast(coordinates: coordinates)
                    AppLogger.log(level: .info, forecast)
                } catch {
                    AppLogger.log(level: .error, error)
                }
            }
        }

    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func goToSearch() {
        delegate?.goToSearchScreen()
    }
    
    @objc private func goToMap() {
        delegate?.goToMapScreen()
    }
}

