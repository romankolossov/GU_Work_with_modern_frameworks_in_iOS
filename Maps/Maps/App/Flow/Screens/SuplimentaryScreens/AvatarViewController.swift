//
//  AvatarViewController.swift
//  Maps
//
//  Created by Roman Kolosov on 24.04.2021.
//

import UIKit

class AvatarViewController: UIViewController, AlertShowable {

    // MARK: - Public properties

    public lazy var publicAvatarView: AvatarView = {
        avatarView
    }()

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
        // Create navigation bar with navigation item to set its custom look and the title of the Avatar VC. For more explanations see notes for it in SignIn VC.
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

        let alertController = UIAlertController(
            title: NSLocalizedString("avatarAction", comment: ""),
            message: NSLocalizedString("avatarActionMessage ", comment: "Choose action to create avatat"),
            preferredStyle: .actionSheet
        )
        let photoAction = UIAlertAction(
            title: NSLocalizedString("choosePhoto", comment: "Choose a photo from the gallery"),
            style: .default) { [weak self] _ in
            self?.createAndShowPickerController(with: .photoLibrary)
        }
        let selfieAction = UIAlertAction(
            title: NSLocalizedString("makeSelfie", comment: "Make selfie"),
            style: .default) { [weak self] _ in
            self?.createAndShowPickerController(with: .camera)
        }
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancel", comment: ""),
            style: .cancel,
            handler: nil
        )
        alertController.addAction(photoAction)
        alertController.addAction(selfieAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)

        // After alert Close pressed, dismiss Avatar VC screen to move to User VC screen
//        let handler: ((UIAlertAction) -> Void)? = { [weak self] _ in
//            self?.dismiss(animated: true, completion: nil)
//        }
//
//        showAlert(
//            title: NSLocalizedString("avatar", comment: ""),
//            message: NSLocalizedString("makeAvatarSuccess", comment: ""),
//            handler: handler,
//            completion: nil
//        )

    }

    // MARK: - Private methods

    // MARK: Create picker controller

    private func createAndShowPickerController(with type: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return
        }
        let imagePicker = UIImagePickerController()

        imagePicker.sourceType = type
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }

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
