//
//  AvatarViewController.swift
//  Maps
//
//  Created by Roman Kolosov on 24.04.2021.
//

import UIKit

class AvatarViewController: UIViewController, AlertShowable {

    // MARK: - Private properties

    private lazy var avatarView: AvatarView = {
        let view = AvatarView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var selfieButton: ShakableButton = {
        let button = ShakableButton()
        button.setTitle(NSLocalizedString("makeSelfie", comment: ""), for: .normal)
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
        navigationItem.title = NSLocalizedString("avatar", comment: "")

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
        configureAvatarVC()

        // MARK: Targets

        selfieButton.addTarget(self, action: #selector(makeSelfie), for: .touchUpInside)
    }

    // MARK: - Actions

    // MARK: Make selfie

    @objc private func makeSelfie() {
        // Animation when the signUpButton is tapped.
        selfieButton.shake()

        // After alert Close pressed, dismiss SignUpVC screen to move to User VC screen
        let handler: ((UIAlertAction) -> Void)? = { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }

        showAlert(
            title: NSLocalizedString("signup", comment: ""),
            message: NSLocalizedString("signupSuccess", comment: ""),
            handler: handler,
            completion: nil
        )
    }

    // MARK: - Private methods

    // MARK: Configure

    private func configureAvatarVC() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(avatarView)
        view.addSubview(selfieButton)
        view.addSubview(navigationBar)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        let avatarViewConstraints = [
            avatarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: .navigationBarHeight),
            avatarView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            avatarView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            avatarView.bottomAnchor.constraint(equalTo: selfieButton.topAnchor)
        ]
        let selfieButtonConstraints = [
            selfieButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            selfieButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            selfieButton.heightAnchor.constraint(equalToConstant: .buttonHeight),
            selfieButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ]
        NSLayoutConstraint.activate(avatarViewConstraints)
        NSLayoutConstraint.activate(selfieButtonConstraints)
    }

}
