//
//  SignInViewController.swift
//  Maps
//
//  Created by Roman Kolosov on 09.04.2021.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class SignInViewController: UIViewController, AlertShowable {

    // MARK: - Private properties

    private let realmManager = RealmManager.shared
    private var loggedUserData: LoggedUserData?
    private var textFieldsIsFilledIn: Bool = false

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

        // For RxSwith use to check that login and password text fields are not empty.
        configureLoginBindings()

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loggedUserData = LoggedUserData.getUser()
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
        // Animation when the signInButton is tapped.
        signInButton.shake()

        // After alert Close pressed, dismiss SignInVC screen to move to User VC screen
        let handler: ((UIAlertAction) -> Void)? = { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }

        // Cancel login if user already logged in.
        guard let log = loggedUserData?.user.login, log.isEmpty else {
            showAlert(
                title: NSLocalizedString("signin", comment: ""),
                message: NSLocalizedString("signinFailureWithAleadyLoggedUser", comment: ""),
                handler: handler,
                completion: nil
            )
            return
        }
/*
        // Check that login and password text fields are not empty in a regular way.
        guard let login = signInView.userNameTextField.text,
              let password = signInView.passwordTextField.text,
              !login.isEmpty, !password.isEmpty else {
            showAlert(
                title: NSLocalizedString("signin", comment: ""),
                message: NSLocalizedString("signinFailureWithEmptyTextFields", comment: ""),
                handler: nil,
                completion: nil
            )
            return
        }
*/
        // Check that login and password text fields are not empty by using RxSwift.
        guard let login = signInView.userNameTextField.text,
              let password = signInView.passwordTextField.text,
              textFieldsIsFilledIn else {
            showAlert(
                title: NSLocalizedString("signin", comment: ""),
                message: NSLocalizedString("signinFailureWithEmptyTextFields", comment: ""),
                handler: nil,
                completion: nil
            )
            return
        }

        // Get all users.
        guard let users: Results<User> = realmManager?.getObjects() else { return }

        var permittedToLoginUser: User?

        // Check that entered user's login and password is in database.
        Array(users).forEach { user in
            guard user.login == login else { return }
            guard user.password == password else { return }
            permittedToLoginUser = user
        }
        guard let permittedToLoginUserRevealed = permittedToLoginUser else {
            showAlert(
                title: NSLocalizedString("signin", comment: ""),
                message: NSLocalizedString("signinFailureWithWrongLoginOrPassword", comment: ""),
                handler: handler,
                completion: nil
            )
            return
        }

        // Save logged user data in user defaults for the later use in the logged user sesion.
        LoggedUserData.saveUser(
            login: permittedToLoginUserRevealed.login,
            password: permittedToLoginUserRevealed.password
        )
        permittedToLoginUser = nil

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

    // RxSwift, configure login and password bindings.

    private func configureLoginBindings() {
        Observable
            // Combine two oservers in one.
            .combineLatest(
            // Text field change observers.
            signInView.userNameTextField.rx.text,
            signInView.passwordTextField.rx.text
            )
            // Modify values from two observers in one.
            .map { login, password in
                // If login and password fields are not empty return true.
                !(login ?? "").isEmpty && !(password ?? "").isEmpty
            }
            // Subscribe for recieving events.
            .bind { [weak self] (inputField) in
                // If event is successfull mark a flag else dismiss it.
                self?.textFieldsIsFilledIn = inputField
            }
            .disposed(by: .init())
    }

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
