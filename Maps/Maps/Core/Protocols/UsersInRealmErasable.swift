//
//  UsersInRealmErasable.swift
//  Maps
//
//  Created by Roman Kolosov on 10.04.2021.
//

import UIKit
import RealmSwift

protocol UsersInRealmErasable: AlertShowable { }

extension UsersInRealmErasable where Self: UIViewController {

    func eraseUsersInRealm(
        handler: ((UIAlertAction) -> Void)? = nil,
        completion: (() -> Void)? = nil
    ) {
        // Define aguments for alert controller
        let title: String = NSLocalizedString("usersAction", comment: "")
        let message: String = NSLocalizedString("usersActionMessage", comment: "Do You want to erase all users data from database?")
        let realmManager = RealmManager.shared

        // Instantiate alert controller
        let alertController = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .actionSheet
        )
        // Instantiate alert title
        let alertTitle = NSMutableAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: UIFont.alertTitleFont
            ]
        )
        // Configure alert title
        alertTitle.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.alertTitleTextColor,
            range: NSRange(location: 0, length: title.count)
        )
        // Configure alert controller
        alertController.setValue(alertTitle, forKey: "attributedTitle")
        alertController.view.tintColor = .alertViewTintColor

        // Instatiate erase users action.

        let eraseUsersAction = UIAlertAction(
            title: NSLocalizedString("eraseUsers", comment: ""),
            style: .destructive) { _ in
            DispatchQueue.main.async {
                try? realmManager?.deleteAll()
            }
            self.showAlert(
                title: NSLocalizedString("changeUserData", comment: ""),
                message: NSLocalizedString("usersDataErased", comment: ""),
                handler: handler,
                completion: nil
            )
        }

        // Instatiate cancel action

        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancel", comment: ""),
            style: .cancel,
            handler: nil
        )
        alertController.addAction(cancelAction)
        alertController.addAction(eraseUsersAction)

        present(alertController, animated: true, completion: completion)
    }
}
