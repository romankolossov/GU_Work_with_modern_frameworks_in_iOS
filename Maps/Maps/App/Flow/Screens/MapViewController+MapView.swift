//
//  MapViewController+MapView.swift
//  Maps
//
//  Created by Roman Kolosov on 01.04.2021.
//

import UIKit
import GoogleMaps
import OSLog

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        Logger.viewCycle.debug("\(coordinate)")

        guard let manualMarker = manualMarker else {
            let mark = GMSMarker(position: coordinate)
            mark.map = publicMapView
            self.manualMarker = mark
            return
        }
        manualMarker.position = coordinate
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else { return }
        Logger.viewCycle.debug("\(first)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.viewCycle.debug("\(error.localizedDescription)")
    }

}
