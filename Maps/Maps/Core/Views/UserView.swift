//
//  UserView.swift
//  Maps
//
//  Created by Roman Kolosov on 09.04.2021.
//

import UIKit

class UserView: UIView {

    // MARK: - Public properties

    // MARK: Subviews

    let idLabel = UILabel()
    let userNameLabel = UILabel()
    let passwordLabel = UILabel()
    let emailLabel = UILabel()
    let genderLabel = UILabel()
    let creditCardLabel = UILabel()
    let bioLabel = UILabel()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func configureUI() {
        backgroundColor = .suplimentaryViewBackgroundColor
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.textColor = .userLableTextColor
        idLabel.textAlignment = .left
        idLabel.font = .userLableFont

        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.textColor = .userLableTextColor
        userNameLabel.textAlignment = .left
        userNameLabel.font = .userLableFont

        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.textColor = .userLableTextColor
        passwordLabel.textAlignment = .left
        passwordLabel.font = .userLableFont

        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textColor = .userLableTextColor
        emailLabel.textAlignment = .left
        emailLabel.font = .userLableFont

        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.textColor = .userLableTextColor
        genderLabel.textAlignment = .left
        genderLabel.font = .userLableFont

        creditCardLabel.translatesAutoresizingMaskIntoConstraints = false
        creditCardLabel.textColor = .userLableTextColor
        creditCardLabel.textAlignment = .left
        creditCardLabel.font = .userLableFont

        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.textColor = .userLableTextColor
        bioLabel.textAlignment = .left
        bioLabel.font = .userLableFont
        bioLabel.numberOfLines = 3

        addSubview(idLabel)
        addSubview(userNameLabel)
        addSubview(passwordLabel)
        addSubview(emailLabel)
        addSubview(genderLabel)
        addSubview(creditCardLabel)
        addSubview(bioLabel)
    }

    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let indent: CGFloat = 21.0

        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: indent),
            idLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            idLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            userNameLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: indent),
            userNameLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            userNameLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            passwordLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: indent),
            passwordLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            passwordLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            emailLabel.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: indent),
            emailLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            emailLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            genderLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: indent),
            genderLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            genderLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            creditCardLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: indent),
            creditCardLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            creditCardLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            bioLabel.topAnchor.constraint(equalTo: creditCardLabel.bottomAnchor, constant: indent),
            bioLabel.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            bioLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent)
        ])
    }

}
