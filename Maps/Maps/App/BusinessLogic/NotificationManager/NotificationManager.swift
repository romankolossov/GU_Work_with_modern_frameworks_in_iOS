//
//  NotificationManager.swift
//  Maps
//
//  Created by Roman Kolosov on 23.04.2021.
//

import Foundation
import NotificationCenter
import OSLog

class NotificationManager {

    // MARK: - Public properties

    static let shared = NotificationManager()

    // MARK: - Private properties

    private let notificationCenter = UNUserNotificationCenter.current()

    // MARK: - Initializers

    private init() { }

    // MARK: - Public methods

    func registerForNotifications() {
        notificationCenter.getNotificationSettings { [weak self] notificationSettings in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self?.requestAutorisation()
            case .denied:
                Logger.viewCycle.debug("Application not allowed to show notifications")
            default:
                break
            }
        }
    }

    func sendNotification() {
        createNotificationRequest(
            with: "Alarm",
            content: createNotificationContent(),
            trigger: createNotificationTrigger()
        )
    }

    // MARK: - Private methods

    fileprivate func requestAutorisation() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        notificationCenter.requestAuthorization(
            options: options) { success, error in
            guard error == nil else {
                guard let error = error else { return }
                Logger.viewCycle.debug("\(error.localizedDescription)")
                return
            }
            guard success else {
                Logger.viewCycle.debug("No permission to show notifications granted")
                return
            }
            Logger.viewCycle.debug("Permission to show notifications granted")
        }
    }

    fileprivate func createNotificationRequest(
        with identifier: String,
        content: UNNotificationContent,
        trigger: UNNotificationTrigger
    ) {
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        notificationCenter.add(request) { error in
            guard let error = error else { return }
            Logger.viewCycle.debug("\(error.localizedDescription)")
        }
    }

    fileprivate func createNotificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()

        content.badge = 3
        content.title = "Hello!"
        content.subtitle = "Its time to wake up"
        content.body = "Here is the main notification body with the text asking to enter the app"
        content.sound = .default
        content.userInfo = ["identifierUserInfo": "Test user info"]
        return content
    }

    fileprivate func createNotificationTrigger() -> UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(timeInterval: 8, repeats: false)
    }

}
