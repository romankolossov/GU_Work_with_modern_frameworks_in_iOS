//
//  PasswordViewController.swift
//  Maps
//
//  Created by Roman Kolosov on 10.04.2021.
//

import UIKit

class PasswordViewController: UIViewController, AlertShowable {

    // MARK: - Private properties

    private let signUpViewController = SignUpViewController()
    private var userToChangePassword: User?

    private lazy var passwordView: SignInView = {
        let view = SignInView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var savePasswordButton: ShakableButton = {
        let button = ShakableButton()
        button.setTitle(NSLocalizedString("savePassword", comment: ""), for: .normal)
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
        navigationItem.title = NSLocalizedString("passwordRedefining", comment: "")

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
        signUpViewController.delegate = self
        configurePasswordVC()

        // MARK: Targets

        savePasswordButton.addTarget(self, action: #selector(savePassword), for: .touchUpInside)
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
        passwordView.addGestureRecognizer(tapGesture)
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

    // MARK: Save password

    @objc private func savePassword() {
        savePasswordButton.shake() // Animation when the signInButton is tapped.

        // After alert OK pressed, dismiss PasswordVC screen to move to User VC screen
        let handler: ((UIAlertAction) -> Void)? = { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }

        guard let password = passwordView.passwordTextField.text, !password.isEmpty else {
            showAlert(
                title: NSLocalizedString("passwordSaving", comment: ""),
                message: NSLocalizedString("passwordSaveFailureWithEmtyTextField", comment: ""),
                handler: nil,
                completion: nil
            )
            return
        }
        showAlert(
            title: NSLocalizedString("passwordSaving", comment: ""),
            message: NSLocalizedString("passwordSaveSuccess", comment: ""),
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
        passwordView.contentInset = contentInsets
        passwordView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillBeHiden(notification: Notification) {
        passwordView.contentInset = UIEdgeInsets.zero
        passwordView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    @objc func hideKeyboard() {
        passwordView.endEditing(true)
    }

    // MARK: - Private methods

    // MARK: Configure

    private func configurePasswordVC() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(passwordView)
        view.addSubview(savePasswordButton)
        view.addSubview(navigationBar)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        let passwordViewConstraints = [
            passwordView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: .navigationBarHeight),
            passwordView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            passwordView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            passwordView.bottomAnchor.constraint(equalTo: savePasswordButton.topAnchor)
        ]
        let savePasswordButtonConstraints = [
            savePasswordButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            savePasswordButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            savePasswordButton.heightAnchor.constraint(equalToConstant: .buttonHeight),
            savePasswordButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ]
        NSLayoutConstraint.activate(passwordViewConstraints)
        NSLayoutConstraint.activate(savePasswordButtonConstraints)
    }

}

// MARK: - SignUpViewControllerDelegate

extension PasswordViewController: SignUpViewControllerDelegate {
    func userWhosePasswordMustBeChanged(_ user: User?) {
        userToChangePassword = user
        #if DEBUG
        print(user as Any, "from ", #function)
        #endif
    }
}
