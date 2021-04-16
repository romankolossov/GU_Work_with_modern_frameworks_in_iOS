//
//  NibNameLoadable+Extension.swift
//  Maps
//
//  Created by Roman Kolosov on 08.04.2021.
//

import UIKit

protocol NibNameLoadable where Self: UIViewController { }

extension NibNameLoadable {
    static var nibName: String? {
        NSStringFromClass(self).components(separatedBy: ".").last
    }
}
