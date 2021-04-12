//
//  AppRouter.swift
//  Maps
//
//  Created by Roman Kolosov on 12.04.2021.
//

import UIKit

final class AppRouter: NSObject, AppRouterProtocol {

    // MARK: - Static

    private static var _router: AppRouter?
    static var router: AppRouter {
        if let router = _router {
            return router
        }
        fatalError("AppRouter: call create router before use it.")
    }

    static func create(_ sceneDelegate: SceneDelegate, controller: UIViewController) {
        AppRouter._router = AppRouter(sceneDelegate: sceneDelegate, controller: controller)

//        sceneDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        sceneDelegate.window?.backgroundColor = Appearance.backgroundColor
//        sceneDelegate.window?.makeKeyAndVisible()
        sceneDelegate.window?.rootViewController = controller
    }

    // MARK: - Instance

    private weak var sceneDelegate: SceneDelegate?

    private init(sceneDelegate: SceneDelegate, controller: UIViewController) {
        self.sceneDelegate = sceneDelegate
        self.currentController = controller.firstEmbedded()
        super.init()
    }

    // MARK: - RouterProtocol

    var currentController: UIViewController

    var rootNavigationController: UIViewController? {
        currentController.navigationController?.viewControllers.first
    }

    func go(controller: UIViewController, mode: RouterPresentationMode, animated: Bool, modalTransitionStyle: UIModalTransitionStyle) {
        present(controller: controller, mode: mode, animated: animated, modalTransitionStyle: modalTransitionStyle)
        currentController = controller
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        currentController.dismiss(animated: animated, completion: completion)

        if let controller = currentController.presentingViewController {
            if let tabBarController = controller as? UITabBarController {
                currentController = tabBarController.currentEmbedded()
            } else if let navController = controller as? UINavigationController {
                currentController = navController.currentEmbedded()
            } else {
                currentController = controller
            }
        }
    }

    func pop(animated: Bool) {
        currentController.navigationController?.popViewController(animated: animated)
        if let controller = currentController.navigationController?.viewControllers.last {
            currentController = controller
        }
    }

    func popToRoot(animated: Bool) {
        let firstController = currentController.navigationController?.viewControllers.first
        currentController.navigationController?.popToRootViewController(animated: animated)
        if let controller = firstController {
            currentController = controller
        }
    }

    func replaceWindowRoot(with controller: UIViewController) {
        sceneDelegate?.window?.rootViewController = controller
        currentController = controller.firstEmbedded()
    }

    func tabBarDidChangedTo(controller: UIViewController) {
        currentController = controller.firstEmbedded()
    }

    // MARK: - Private

    private func present(controller: UIViewController, mode: RouterPresentationMode, animated: Bool, modalTransitionStyle: UIModalTransitionStyle) {
        switch mode {
        case .push:
            guard let navController = currentController.navigationController else {
                present(controller: controller, animated: animated)
                return
            }
            navController.pushViewController(controller, animated: animated)
        case .modal:
            controller.modalTransitionStyle = modalTransitionStyle
            controller.modalPresentationStyle = .fullScreen
            present(controller: controller, animated: animated)
        case .modalWithNavigation:
            let navController = UINavigationController(rootViewController: controller)
            navController.modalTransitionStyle = modalTransitionStyle
            navController.modalPresentationStyle = .fullScreen
            present(controller: navController, animated: animated)
        case .replace:
            guard let navController = currentController.navigationController else {
                present(controller: controller, animated: animated)
                return
            }
            navController.setViewControllers([controller], animated: animated)
        case .replaceWithPush:
            guard let navController = currentController.navigationController else {
                present(controller: controller, animated: animated)
                return
            }
            navController.pushViewController(controller, animated: animated)
            let controllers = navController.viewControllers.filter { $0 != currentController }
            navController.setViewControllers(controllers, animated: animated)
        }
    }

    private func present(controller: UIViewController, animated: Bool) {
        currentController.present(controller, animated: animated, completion: nil)
    }

}

// MARK: - Appearance

extension AppRouter {

    private enum Appearance {
        static let backgroundColor: UIColor = .black
    }

}
