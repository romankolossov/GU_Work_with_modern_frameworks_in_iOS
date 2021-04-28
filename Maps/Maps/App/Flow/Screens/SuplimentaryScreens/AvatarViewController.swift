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

    private lazy var avatarMakeButton: ShakableButton = {
        let button = ShakableButton()
        button.setTitle(NSLocalizedString("makeAvatar", comment: ""), for: .normal)
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

        avatarMakeButton.addTarget(self, action: #selector(makeAvatar), for: .touchUpInside)
    }

    // MARK: - Actions

    // MARK: Make selfie

    @objc private func makeAvatar() {
        // Animation when the signUpButton is tapped.
        avatarMakeButton.shake()
        
        // Create and show an alert to choose the way of creation an avatar via the picker controller.

        let alertController = UIAlertController(
            title: NSLocalizedString("avatarAction", comment: ""),
            message: NSLocalizedString("avatarActionMessage ", comment: "Choose action to create avatat"),
            preferredStyle: .actionSheet
        )
        alertController.view.tintColor = .alertViewTintColor

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
        view.addSubview(avatarMakeButton)
        view.addSubview(navigationBar)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        let avatarViewConstraints = [
            avatarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: .navigationBarHeight),
            avatarView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            avatarView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            avatarView.bottomAnchor.constraint(equalTo: avatarMakeButton.topAnchor)
        ]
        let selfieButtonConstraints = [
            avatarMakeButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            avatarMakeButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            avatarMakeButton.heightAnchor.constraint(equalToConstant: .buttonHeight),
            avatarMakeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ]
        NSLayoutConstraint.activate(avatarViewConstraints)
        NSLayoutConstraint.activate(selfieButtonConstraints)
    }

}
