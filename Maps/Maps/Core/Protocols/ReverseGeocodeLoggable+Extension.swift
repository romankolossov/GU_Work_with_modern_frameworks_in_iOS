//
//  ReverseGeocodeLogable+Extension.swift
//  Maps
//
//  Created by Roman Kolosov on 05.04.2021.
//

import UIKit
import GoogleMaps
import OSLog

protocol ReverseGeocodeLoggable where Self: UIViewController { }

extension ReverseGeocodeLoggable {
    // Log the place of the location.
    func reverseGeocodeLog(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (places, error) in
            guard error == nil else {
                guard let error = error?.localizedDescription else { return }
                Logger.viewCycle.debug("\(error)")
                return
            }
            guard let place = places?.first else { return }
            Logger.viewCycle.debug("\(place)")
        }
    }
}
