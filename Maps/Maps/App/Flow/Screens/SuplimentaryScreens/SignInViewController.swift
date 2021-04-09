//
//  SignInViewController.swift
//  Maps
//
//  Created by Roman Kolosov on 09.04.2021.
//

import UIKit

class SignInViewController: UIViewController, AlertShowable {

    // MARK: - Private properties

    private lazy var signInView: SignInView = {
        let view = SignInView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var signInButton: ShakableButton = {
        let button = ShakableButton()
        button.setTitle(NSLocalizedString("toSignIn", comment: "Sign in"), for: .normal)
        button.setTitleColor(.buttonTitleColor, for: .normal)
        button.setTitleColor(.buttonTitleColorWhenHighlighted, for: .highlighted)
        button.backgroundColor = .buttonBackgroundColor
        button.layer.borderWidth = .buttonBorderWidth
        button.layer.borderColor = UIColor.buttonBorderColor.cgColor
        button.layer.cornerRadius = .buttonCornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var navigationBar: UINavigationBar = {
        // Create navigation bar with navigation item to set its custom look and the title of the SignIn VC.
        // Because of design, the correct way to show the SignIn VC is to use .present for its navigation controller with SignIn VC modal presentation style as .formSheet.
        // Instead of just to push it in navigation controller where navigation bar exists by default.
        let frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: view.bounds.size.width,
            height: .navigationBarHeight
        )
        let navigationItem = UINavigationItem()
        navigationItem.title = NSLocalizedString("signin", comment: "")

        let navigationBar = UINavigationBar(frame: frame)
        navigationBar.items = [navigationItem]

        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.customNavigationBarTitleTextColor
        ]
        navigationBar.barTintColor = .customNavigationBarTintColor
        return navigationBar
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignInVC()

        // MARK: Targets

        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeShown(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeHiden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        signInView.addGestureRecognizer(tapGesture)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // MARK: - Actions

    // MARK: Signin

    @objc private func signIn() {
        signInButton.shake() // Animation when the signInButton is tapped.

        // MARK: TO DO

        let resultWithSignInSuccess: Int = 1
        let result: Int = 1

        let handler: ((UIAlertAction) -> Void)? = { [weak self] _ in
            // After alert OK pressed, dismiss SignInVC screen to move to User VC screen
            self?.dismiss(animated: true, completion: nil)
        }
        guard result == resultWithSignInSuccess else {
            self.showAlert(
                title: NSLocalizedString("signin", comment: ""),
                message: NSLocalizedString("signinFailure", comment: ""),
                handler: handler,
                completion: nil
            )
            return
        }
//        LoggedUserData.saveUser(
//            id: model.user.id,
//            login: model.user.login,
//            name: model.user.name,
//            lastName: model.user.lastname
//        )
        self.showAlert(
            title: NSLocalizedString("signin", comment: ""),
            message: NSLocalizedString("signinSuccess", comment: ""),
            handler: handler,
            completion: nil
        )
    }

    // MARK: Keyboard

    @objc func keyboardWillBeShown(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let info = userInfo as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size

        let contentInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardSize?.height ?? 0.0,
            right: 0.0
        )
        signInView.contentInset = contentInsets
        signInView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillBeHiden(notification: Notification) {
        signInView.contentInset = UIEdgeInsets.zero
        signInView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    @objc func hideKeyboard() {
        signInView.endEditing(true)
    }

    // MARK: - Private methods

    // MARK: Configure

    private func configureSignInVC() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(signInView)
        view.addSubview(signInButton)
        view.addSubview(navigationBar)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        let signInViewConstraints = [
            signInView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: .navigationBarHeight),
            signInView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            signInView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            signInView.bottomAnchor.constraint(equalTo: signInButton.topAnchor)
        ]
        let signInButtonConstraints = [
            signInButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: .buttonHeight),
            signInButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ]
        NSLayoutConstraint.activate(signInViewConstraints)
        NSLayoutConstraint.activate(signInButtonConstraints)
    }

}
