//
//  MapViewController.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation
import UIKit
import GoogleMaps


final class MapViewController: UIViewController {
    
    private let coordinates: Coordinates

    private lazy var mapView: GMSMapView = {
       let camera = GMSCameraPosition.camera(withLatitude: 50.4501, longitude: 30.5234, zoom: 8)
       let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
       mapView.translatesAutoresizingMaskIntoConstraints = false
       return mapView
   }()

    private let locationManager = CLLocationManager()
    private let networkManager = NetworkManager()
    
    private var currentLocationMarker = GMSMarker()
    private var selectedLocationMarker  = GMSMarker()
    
    private var selectedPlace: Place?
    private var isSelectedPlaceChangedLocation: Bool = false {
        didSet{
            if isSelectedPlaceChangedLocation{
                self.selectedLocationMarker.position = CLLocationCoordinate2D(latitude: selectedPlace?.coordinates.latitude ?? 0.0, longitude: selectedPlace?.coordinates.longitude ?? 0.0)
                self.selectedLocationMarker.map = self.mapView
            }
        }
    }
    
    init(coordinates: Coordinates) {
        self.coordinates = coordinates
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        mapView.settings.zoomGestures = true
        
        
        setLocationManager()
        setMap()
    }
    
    private func setLocationManager() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.requestLocation()
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            } else{
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    private func setMap() {
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        mapView.mapType = .normal
    }
    
    func createModel(json: ResponseJSON, coordinate: Coordinates) -> Place {
        
        var placeName  = ""
        json.results.first?.addressComponents.forEach({ addressComponent in
            if addressComponent.types.first == "postal_town"{
                placeName = addressComponent.longName
            }
        })
        
        let formattedAddress = json.results.first?.formattedAddress ?? ""
        let place = Place(name: placeName, formattedAddress: formattedAddress, id: json.results.first!.placeID, coordinates: coordinate)
        
        return place
    }
    
}

// MARK: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        mapView.camera = GMSCameraPosition(
                        latitude: locationManager.location?.coordinate.latitude ?? 0.0,
                        longitude: locationManager.location?.coordinate.longitude ?? 0.0,
                        zoom: 8,
                        bearing: 0,
                        viewingAngle: 0)
        
        currentLocationMarker.position = CLLocationCoordinate2D(latitude: locations.last?.coordinate.latitude ?? 0.0, longitude: locations.last?.coordinate.longitude ?? 0.0)
        
        currentLocationMarker.map = mapView
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .denied:
            return
        case .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("!!!!!!!!!\(error)")
    }
    
}

// MARK: GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let markerInfoView = MarkerInfoView()
        
        let currentMarker = Coordinates(latitude: locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0)
        let selectedMarker = Coordinates(latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        if currentMarker == selectedMarker {
            markerInfoView.setUI(with: "My location")
        } else {
            markerInfoView.setUI(with: selectedPlace?.formattedAddress ?? "")
        }
        
        return markerInfoView as UIView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        print("didTapInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        
        print("didLongPressInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        let coordinates = Coordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        Task {
            do {
                let placeAddress = try await networkManager.fetchPlaceAddress(coordinates: coordinates)
            
                AppLogger.log(level: .info, placeAddress)
                
                self.selectedPlace = createModel(json: placeAddress, coordinate: coordinates)
                self.isSelectedPlaceChangedLocation = true
            } catch {
                AppLogger.log(level: .error, error)
            }
        }
    }
}
