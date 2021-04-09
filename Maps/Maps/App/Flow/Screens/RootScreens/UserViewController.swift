//
//  UserViewController.swift
//  Maps
//
//  Created by Roman Kolosov on 08.04.2021.
//

import UIKit

class UserViewController: UIViewController, AlertShowable {

    // MARK: - Private properties

    private lazy var userView: UserView = {
        let view = UserView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // private var userData: UserData?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserVC()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // userData = UserData.getUser()
        configureUserVCLook()
    }

    // MARK: - Actions

    @objc private func signUp() {
        let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .formSheet

        navigationController?.present(
            signUpViewController,
            animated: true,
            completion: nil
        )
    }

    @objc private func signIn() {
        let signInViewController = SignInViewController()
        signInViewController.modalPresentationStyle = .formSheet

        navigationController?.present(
            signInViewController,
            animated: true,
            completion: nil
        )
    }

    @objc private func logout() {
        // MARK: TO DO

        let resultWithLogoutSuccess: Int = 1
        let result: Int = 1

        guard result == resultWithLogoutSuccess else {
            self.showAlert(
                title: NSLocalizedString("logout", comment: ""),
                message: NSLocalizedString("logoutFailure", comment: ""),
                handler: nil,
                completion: nil
            )
            return
        }
        // UserData.clearUser()
        self.viewDidAppear(true)

        self.showAlert(
            title: NSLocalizedString("logout", comment: ""),
            message: NSLocalizedString("logoutSuccess", comment: ""),
            handler: nil,
            completion: nil
        )
    }

    @objc private func changeUserData() {
        // MARK: TO DO
    }

    // MARK: - Private methods

    // MARK: Configure

    private func configureUserVCLook() {
//        guard let userData = userData else {
//            return
//        }
//        navigationItem.title = "\(NSLocalizedString("userVCName", comment: "Hi")), \(userData.user.name)"
//
//        userView.idLabel.text = String(userData.user.id)
//        userView.userNameLabel.text = userData.user.name
//        userView.passwordLabel.text = userData.user.lastname
//        userView.emailLabel.text = userData.user.login
    }

    private func configureUserVC() {
        view.backgroundColor = .rootVCViewBackgroundColor
        (UIApplication.shared.delegate as? AppDelegate)?.restrictRotation = .portrait

        configureNavigationVC()
        addSubviews()
        setupConstraints()
    }

    private func configureNavigationVC() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.navigationBarLargeTitleTextColor
        ]
        navigationController?.navigationBar.isTranslucent = true

        navigationController?.navigationBar.tintColor = .navigationBarTintColor
        navigationController?.navigationBar.backgroundColor = .navigationBarBackgroundColor

        // Create registerNewUserItem and signInItem in navigation item of navigation bar.
        let signInItem = UIBarButtonItem(
            image: UIImage(systemName: "checkmark.seal"),
            style: .done,
            target: self,
            action: #selector(signIn)
        )
        let registerNewUserItem = UIBarButtonItem(
            image: UIImage(systemName: "person.fill.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(signUp)
        )
        navigationItem.leftBarButtonItems = [signInItem, registerNewUserItem]

        // Create logoutItem and changeUserDataItem in navigation item of navigation bar.
        let logoutItem = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.zigzag.right"),
            style: .done,
            target: self,
            action: #selector(logout)
        )
        let changeUserDataItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(changeUserData)
        )
        navigationItem.rightBarButtonItems = [logoutItem, changeUserDataItem]
    }

    private func addSubviews() {
        view.addSubview(userView)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        let userViewConstraints = [
            userView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            userView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            userView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            userView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ]
        NSLayoutConstraint.activate(userViewConstraints)
    }

}
