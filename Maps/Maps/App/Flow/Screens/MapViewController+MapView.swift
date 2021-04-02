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
        // Place one marker at one tap and move the center of map in it
//        guard let manualMarker = manualMarker else {
//            let marker = GMSMarker(position: coordinate)
//            marker.map = publicMapView
//            self.manualMarker = marker
//            publicMapView.animate(toLocation: coordinate)
//            return
//        }
//        manualMarker.position = coordinate
//        publicMapView.animate(toLocation: coordinate)

        // Place one marker at one tap and move the center of map in it
        // leaving the markers of the previous taps on the map
        let marker = GMSMarker(position: coordinate)
        marker.map = publicMapView
        publicMapView.animate(toLocation: coordinate)
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
