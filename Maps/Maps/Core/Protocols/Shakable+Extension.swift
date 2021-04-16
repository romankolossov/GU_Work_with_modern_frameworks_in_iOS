//
//  Shakable+Extension.swift
//  Maps
//
//  Created by Roman Kolosov on 09.04.2021.
//

import UIKit

protocol Shakable { }

extension Shakable where Self: UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(
                                        x: self.center.x - 10.0,
                                        y: self.center.y - 6.0)
        )
        animation.toValue = NSValue(cgPoint: CGPoint(
                                        x: self.center.x + 10.0,
                                        y: self.center.y + 6.0)
        )
        self.layer.add(animation, forKey: "position")
    }
}
