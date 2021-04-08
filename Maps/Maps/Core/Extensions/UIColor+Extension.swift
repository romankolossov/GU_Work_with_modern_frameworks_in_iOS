//
//  UIColor+Extension.swift
//  Maps
//
//  Created by Roman Kolosov on 08.04.2021.
//

import UIKit

extension UIColor {

    // MARK: - Tab bar controller

    static let tabBarBackgroundColor: UIColor = .init(white: 0.1, alpha: 0.8)
    static let tabBarTintColor: UIColor = .systemPurple

    // MARK: - Navigation controllers and its root VCs

    static let navigationBarLargeTitleTextColor: UIColor = tabBarTintColor
    static let navigationBarBackgroundColor: UIColor = tabBarBackgroundColor
    static let navigationBarTintColor: UIColor = .systemBlue

    static let rootVCViewBackgroundColor: UIColor = tabBarBackgroundColor

    // MARK: - Map view controller

    static let updateLocationStrokeColor: UIColor = .systemGreen
    static let restoreRoutePathStrokeColor: UIColor = .systemPurple

    // MARK: - Alerts

    static let alertTitleTextColor: UIColor = tabBarTintColor
    static let alertViewTintColor: UIColor = tabBarTintColor

}
