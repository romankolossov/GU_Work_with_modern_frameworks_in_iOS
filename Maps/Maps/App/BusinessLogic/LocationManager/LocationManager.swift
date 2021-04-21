//
//  LocationManager.swift
//  Maps
//
//  Created by Roman Kolosov on 15.04.2021.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa
import OSLog

final class LocationManager: NSObject, ReverseGeocodeLoggable {
    static let instance = LocationManager()

    // MARK: Public properties

    let location = BehaviorRelay<CLLocation?>(value: nil)

    // MARK: Private properties

    private let locationManager = CLLocationManager()

    // MARK: - Initializers

    override private init() {
        super.init()
        configureLocationManager()
    }

    // MARK: - Public methods

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    // MARK: - Private methods

    // MARK: Cofigure

    private func configureLocationManager() {
        // CLLocationManagerDelegate used with didUpdateLocations method for poins adding and lines drawing when location is updated.
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
        // Take and log the first point from the locations array recieved.
        guard let locationToLog = locations.first else { return }
        Logger.viewCycle.debug("\(locationToLog)")

        // Log the address of place of the location.
        reverseGeocodeLog(location: locationToLog)

        // Track the movement in foreground and background app states
        // at walk or ride in the Apple campus when update location pressed.

        // Track the movement in a usual way, without RxSwift.
/*
        // Take the last point from the locations array recieved.
        guard let lastLocation = locations.last else { return }
        // Add it to the route path.
        routePath?.add(lastLocation.coordinate)
        // Update the path of the route line.
        route?.path = routePath
        // Set the camera to the point added to observe the movement.
        let position = GMSCameraPosition(target: lastLocation.coordinate, zoom: 17)
        publicMapView.animate(to: position)
*/
        // RxSwift, track the movement with RxSwift used.
        location.accept(locations.last)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.viewCycle.debug("\(error.localizedDescription)")
    }

}
