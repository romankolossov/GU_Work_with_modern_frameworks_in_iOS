//
//  AlertShowable+Extension.swift
//  Maps
//
//  Created by Roman Kolosov on 06.04.2021.
//

import UIKit

protocol AlertShowable where Self: UIViewController { }

extension AlertShowable {
    func showAlert(
        title: String? = nil,
        message: String? = nil,
        handler: ((UIAlertAction) -> Void)? = nil,
        completion: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .actionSheet
        )
        alertController.view.tintColor = .systemPurple

        let alertTitle = NSMutableAttributedString(
            string: title ?? "",
            attributes: [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)
            ]
        )
        alertTitle.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.systemPurple,
            range: NSRange(location: 0, length: title?.count ?? 0)
        )
        alertController.setValue(alertTitle, forKey: "attributedTitle")

        let okAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: handler
        )
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: completion)
    }

}
