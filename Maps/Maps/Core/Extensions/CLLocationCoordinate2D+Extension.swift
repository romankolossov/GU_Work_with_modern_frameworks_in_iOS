//
//  CLLocationCoordinate2D+Extension.swift
//  Maps
//
//  Created by Roman Kolosov on 01.04.2021.
//

import Foundation
import GoogleMaps

extension CLLocationCoordinate2D: CustomStringConvertible {
    public var description: String {
        "(\nlatitude: \(latitude) \nlongitude: \(longitude)"
    }
}
