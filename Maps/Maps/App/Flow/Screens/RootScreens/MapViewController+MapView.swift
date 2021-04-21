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
