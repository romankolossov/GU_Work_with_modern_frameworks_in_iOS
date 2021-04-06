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
        // Place one marker at one tap and move the center of map in it.
/*
        guard let manualMarker = manualMarker else {
            let marker = GMSMarker(position: coordinate)
            marker.map = publicMapView
            self.manualMarker = marker
            publicMapView.animate(toLocation: coordinate)
            return
        }
        manualMarker.position = coordinate
        publicMapView.animate(toLocation: coordinate)
*/

        // Place one marker at one tap and move the center of map to it
        // leaving the rest markers of the previous taps on the map
        // and drawing lines between them if update location pressed.
        let marker = GMSMarker(position: coordinate)
        marker.map = publicMapView

        // Add a point to the route path and update the path of the route line.
        routePath?.add(coordinate)
        route?.path = routePath
        // Set the camera to the point added to observe the movement.
        let position = GMSCameraPosition(target: coordinate, zoom: 17)
        publicMapView.animate(to: position)

        // Log the adress of place of the location.
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        reverseGeocodeLog(location: location)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Take and log the first point from the locations array recieved.
        guard let location = locations.first else { return }
        Logger.viewCycle.debug("\(location)")

        // Log the address of place of the location.
        reverseGeocodeLog(location: location)

        // Track the movement in foreground and background app states
        // at walk or ride in the Apple campus when update location pressed.
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
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.viewCycle.debug("\(error.localizedDescription)")
    }

}
