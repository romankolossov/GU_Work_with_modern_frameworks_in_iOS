//
//  SignUpViewController.swift
//  Maps
//
//  Created by Roman Kolosov on 09.04.2021.
//

import UIKit
import RealmSwift

protocol SignUpViewControllerDelegate: class {
    func userWhosePasswordMustBeChanged(_ user: User?)
}

class SignUpViewController: UIViewController, AlertShowable {

    // MARK: - Public properties

    weak var delegate: SignUpViewControllerDelegate?

    // MARK: - Private properties
    private let realmManager = RealmManager.shared

    private lazy var signUpView: SignUpView = {
        let view = SignUpView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var signUpButton: ShakableButton = {
        let button = ShakableButton()
        button.setTitle(NSLocalizedString("toSignUp", comment: "Sign up"), for: .normal)
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
        // Create navigation bar with navigation item to set its custom look and the title of the SignUp VC. For more explanations see notes for it in SignIn VC.
        let frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: view.bounds.size.width,
            height: .navigationBarHeight
        )
        let navigationItem = UINavigationItem()
        navigationItem.title = NSLocalizedString("signup", comment: "")

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
        configureSignUpVC()

        // MARK: Targets

        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
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
        signUpView.addGestureRecognizer(tapGesture)
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

    // MARK: Signup

    @objc private func signUp() {
        // Animation when the signUpButton is tapped.
        signUpButton.shake()

        // After alert Close pressed, dismiss SignUpVC screen to move to User VC screen
        let handler: ((UIAlertAction) -> Void)? = { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }

        // After alert Close pressed, present password view controller to enter new password.
        let saveNewPasswordWhenSameLoginHandler: ((UIAlertAction) -> Void)? = { [weak self] _ in
            let passwordViewController = PasswordViewController()
            passwordViewController.modalPresentationStyle = .formSheet

            self?.present(
                passwordViewController,
                animated: true,
                completion: nil
            )

            // The case of use the app router to navigate through the app. Here a test use done.
            /*
            self?.dismiss(animated: true, completion: nil)
            AppRouter.router.go(controller: passwordViewController, mode: .modal, animated: true, modalTransitionStyle: .coverVertical)
             */
        }

        // Check that text fields are not empty.
        guard let login = signUpView.userNameTextField.text,
              let password = signUpView.passwordTextField.text,
              !login.isEmpty, !password.isEmpty else {
            showAlert(
                title: NSLocalizedString("signup", comment: ""),
                message: NSLocalizedString("signupFailureWithEmptyTextFields", comment: ""),
                handler: nil,
                completion: nil
            )
            return
        }

        // Get all users.
        guard let users: Results<User> = realmManager?.getObjects() else { return }
        // Get all logins.
        let logins = Array(users).map { $0.login }

        var userToChangePassword: User?

        // Check that entered login is not used before.
        // If used, make request for password change for this login.
        guard !logins.contains(login) else {
            Array(users).forEach { user in
                guard user.login == login else { return }
                userToChangePassword = user
            }
            #if DEBUG
            print(userToChangePassword as Any, "from ", #function)
            #endif
            delegate?.userWhosePasswordMustBeChanged(userToChangePassword)
            userToChangePassword = nil

            showAlert(
                title: NSLocalizedString("signup", comment: ""),
                message: NSLocalizedString("signupFailureWithSameLogin", comment: ""),
                handler: saveNewPasswordWhenSameLoginHandler,
                completion: nil
            )
            return
        }

        // Save user in Realm.
        DispatchQueue.main.async { [weak self] in
            let user = User(
                login: login,
                password: password
            )
            try? self?.realmManager?.add(object: user)
        }
        showAlert(
            title: NSLocalizedString("signup", comment: ""),
            message: NSLocalizedString("signupSuccess", comment: ""),
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
        signUpView.contentInset = contentInsets
        signUpView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillBeHiden(notification: Notification) {
        signUpView.contentInset = UIEdgeInsets.zero
        signUpView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    @objc func hideKeyboard() {
        signUpView.endEditing(true)
    }

    // MARK: - Private methods

    // MARK: Configure

    private func configureSignUpVC() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(signUpView)
        view.addSubview(signUpButton)
        view.addSubview(navigationBar)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        let signUpViewConstraints = [
            signUpView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: .navigationBarHeight),
            signUpView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            signUpView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            signUpView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor)
        ]
        let signUpButtonConstraints = [
            signUpButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: .buttonHeight),
            signUpButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ]
        NSLayoutConstraint.activate(signUpViewConstraints)
        NSLayoutConstraint.activate(signUpButtonConstraints)
    }

}
