//
//  LocationManager.swift
//  Event Hub
//
//  Created by Rook on 22.09.2025.
//

import Foundation
import CoreLocation

// Файл: LocationManager.swift
final class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var currentLocation: String = "Loading..."
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // Разрешение запросим явно через публичный метод,
        // чтобы вызывать его из View в нужный момент.
    }
    
    // Публичный метод для запроса разрешения
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
        // При успешной выдаче разрешения делегат вызовет didChangeAuthorization
    }
    
    // Опционально: метод для ручного старта обновлений (если нужно)
    func startUpdating() {
        manager.startUpdatingLocation()
    }
    
    // Опционально: остановка
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
}

// Расширение для работы с делегатом
extension LocationManager: CLLocationManagerDelegate {
    @objc func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            DispatchQueue.main.async { [weak self] in
                self?.currentLocation = "Location access denied"
            }
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Ошибка определения локации: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let streetNumber = placemark.subThoroughfare ?? ""
                let street = placemark.thoroughfare ?? ""
                let city = placemark.locality ?? placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                
                let streetPart = [streetNumber, street].filter { !$0.isEmpty }.joined(separator: " ")
                let components = [streetPart, city, country].filter { !$0.isEmpty }
                let formatted = components.joined(separator: ", ")
                
                DispatchQueue.main.async {
                    self?.currentLocation = formatted.isEmpty ? "Unknown location" : formatted
                }
            }
        }
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
        DispatchQueue.main.async { [weak self] in
            self?.currentLocation = "Location error"
        }
    }
}
