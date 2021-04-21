//
//  SceneDelegate.swift
//  Maps
//
//  Created by Roman Kolosov on 31.03.2021.
//

import UIKit
import NotificationCenter
import OSLog

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let visualEffectView = UIVisualEffectView(effect: nil)
    let notificationCenter = UNUserNotificationCenter.current()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let windowFrame = UIScreen.main.bounds
        self.window = UIWindow(frame: windowFrame)

        self.window?.makeKeyAndVisible()
        self.window?.windowScene = windowScene

        let tabBarController = TabBarController()
        self.window?.rootViewController = tabBarController

        // MARK: The case of use the app router to navigate through the app.
        // Test use see in the SignUp view controller.

        // AppRouter.create(self, controller: tabBarController)

        // MARK: Set dark InterfaceStyle

        self.window?.overrideUserInterfaceStyle = .dark

        // MARK: Notifications request autorization

        notificationCenter.getNotificationSettings { [self] (settings) in
            switch settings.authorizationStatus {
            case .denied:
                Logger.viewCycle.debug("Access not allowed")
            case .authorized:
                Logger.viewCycle.debug("Access allowed")
            default:
                notificationCenter.requestAuthorization(
                    options: [.badge, .alert, .sound]) { state, error in
                    guard error == nil else {
                        guard let error = error else { return }
                        Logger.viewCycle.debug("\(error.localizedDescription)")
                        return
                    }
                    guard state else {
                        Logger.viewCycle.debug("No permission granted")
                        return
                    }
                    Logger.viewCycle.debug("Permission granted")
                }
            }
        }

        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.

        // Uncover top view controller when app become active.

        UIView.animate(withDuration: 0.8) { [weak self] in
            self?.visualEffectView.effect = nil
        }
        visualEffectView.removeFromSuperview()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).

        // Cover top view controller when app resign active.

        guard let window = window else {
            return
        }
        guard visualEffectView.isDescendant(of: window) else {
            visualEffectView.frame = window.bounds
            window.addSubview(visualEffectView)
            UIView.animate(withDuration: 0.8) { [weak self] in
                self?.visualEffectView.effect = UIBlurEffect(style: .regular)
            }
            return
        }
        UIView.animate(withDuration: 0.8) { [weak self] in
            self?.visualEffectView.effect = UIBlurEffect(style: .regular)
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.

        // Uncover top view controller when app enters foreground.

        UIView.animate(withDuration: 0.8) { [weak self] in
            self?.visualEffectView.effect = nil
        }
        visualEffectView.removeFromSuperview()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Cover top view controller when app enters background.

        guard let window = window else {
            return
        }
        guard visualEffectView.isDescendant(of: window) else {
            visualEffectView.frame = window.bounds
            window.addSubview(visualEffectView)
            UIView.animate(withDuration: 0.8) { [weak self] in
                self?.visualEffectView.effect = UIBlurEffect(style: .regular)
            }
            return
        }
        UIView.animate(withDuration: 0.8) { [weak self] in
            self?.visualEffectView.effect = UIBlurEffect(style: .regular)
        }

        sendNotificationRequest(
            content: makeNotificationContent(),
            trigger: makeNotificationTrigger()
        )
    }

    func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()

        content.badge = 3
        content.title = "Hello!"
        content.subtitle = "Its time to wake up"
        content.body = "Here is the main notification body text"
        return content
    }

    func makeNotificationTrigger() -> UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(timeInterval: 8, repeats: false)
    }

    func sendNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            guard let error = error else { return }
            Logger.viewCycle.debug("\(error.localizedDescription)")
        }
    }

}
