//
//  LocationManager.swift
//  Maps
//
//  Created by Roman Kolosov on 15.04.2021.
//

import Foundation
import CoreLocation
import RxSwift
import OSLog
import RxCocoa

final class LocationManager: NSObject {
    static let instance = LocationManager()

    // MARK: Public properties

    let location: Variable<CLLocation?> = Variable(nil)

    // MARK: Private properties

    let locationManager = CLLocationManager()

    // MARK: - Initializers

    private override init() {
        super.init()
        configureLocationManager()
    }

    // MARK: - Public methods

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stoptUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - Private methods

    // MARK: Cofigure

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.requestAlwaysAuthorization()
        // locationManager.requestWhenInUseAuthorization()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location.value = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.viewCycle.debug("\(error.localizedDescription)")
    }
    
}
