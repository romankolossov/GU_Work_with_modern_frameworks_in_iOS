//
//  UIViewController+Extension.swift
//  Maps
//
//  Created by Roman Kolosov on 12.04.2021.
//

import UIKit

extension UIViewController {

    func firstEmbedded() -> UIViewController {
        if let tabBarController = self as? UITabBarController {
            if let navController = tabBarController.selectedViewController as? UINavigationController {
                return navController.viewControllers.first ?? self
            } else {
                return tabBarController.selectedViewController ?? self
            }
        }
        if let navController = self as? UINavigationController {
            return navController.viewControllers.first ?? self
        }
        return self
    }

    func currentEmbedded() -> UIViewController {
        if let tabBarController = self as? UITabBarController {
            if let navController = tabBarController.selectedViewController as? UINavigationController {
                return navController.viewControllers.last ?? self
            } else {
                return tabBarController.selectedViewController ?? self
            }
        }
        if let navController = self as? UINavigationController {
            return navController.viewControllers.last ?? self
        }
        return self
    }

    func topMostViewController() -> UIViewController? {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController?.topMostViewController()
    }

}
