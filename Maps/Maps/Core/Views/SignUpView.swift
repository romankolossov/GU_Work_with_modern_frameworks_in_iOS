//
//  SignUpView.swift
//  Maps
//
//  Created by Roman Kolosov on 09.04.2021.
//

import UIKit

class SignUpView: UIScrollView {

    // MARK: - Public properties

    // MARK: Subviews

    lazy var idTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        return tf
    }()
    lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        return tf
    }()
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.autocorrectionType = .no
        return tf
    }()
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        return tf
    }()
    lazy var genderTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        return tf
    }()
    lazy var creditCardTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        return tf
    }()
    lazy var bioTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        return tf
    }()

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
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        idTextField.placeholder = " id"
        idTextField.textColor = .userTextFieldTextColor
        idTextField.textAlignment = .left
        idTextField.font = .userTextFieldFont
        idTextField.backgroundColor = .userTextFieldTextBackgroundColor
        idTextField.layer.cornerRadius = .textFieldCornerRadius

        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.placeholder = NSLocalizedString("loginTextFieldPlaceholder", comment: "")
        userNameTextField.textColor = .userTextFieldTextColor
        userNameTextField.textAlignment = .left
        userNameTextField.font = .userTextFieldFont
        userNameTextField.backgroundColor = .userTextFieldTextBackgroundColor
        userNameTextField.layer.cornerRadius = .textFieldCornerRadius

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = NSLocalizedString("passwordTextFieldPlaceholder", comment: "")
        passwordTextField.textColor = .userTextFieldTextColor
        passwordTextField.textAlignment = .left
        passwordTextField.font = .userTextFieldFont
        passwordTextField.backgroundColor = .userTextFieldTextBackgroundColor
        passwordTextField.layer.cornerRadius = .textFieldCornerRadius

        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = " E-mail"
        emailTextField.textColor = .userTextFieldTextColor
        emailTextField.textAlignment = .left
        emailTextField.font = .userTextFieldFont
        emailTextField.backgroundColor = .userTextFieldTextBackgroundColor
        emailTextField.layer.cornerRadius = .textFieldCornerRadius

        genderTextField.translatesAutoresizingMaskIntoConstraints = false
        genderTextField.placeholder = " Gender"
        genderTextField.textColor = .userTextFieldTextColor
        genderTextField.textAlignment = .left
        genderTextField.font = .userTextFieldFont
        genderTextField.backgroundColor = .userTextFieldTextBackgroundColor
        genderTextField.layer.cornerRadius = .textFieldCornerRadius

        creditCardTextField.translatesAutoresizingMaskIntoConstraints = false
        creditCardTextField.placeholder = " Credit card number"
        creditCardTextField.textColor = .userTextFieldTextColor
        creditCardTextField.textAlignment = .left
        creditCardTextField.font = .userTextFieldFont
        creditCardTextField.backgroundColor = .userTextFieldTextBackgroundColor
        creditCardTextField.layer.cornerRadius = .textFieldCornerRadius

        bioTextField.translatesAutoresizingMaskIntoConstraints = false
        bioTextField.placeholder = " Note: You may leave the fields blank"
        bioTextField.textColor = .userTextFieldTextColor
        bioTextField.textAlignment = .left
        bioTextField.font = .userTextFieldFont
        bioTextField.backgroundColor = .userTextFieldTextBackgroundColor
        bioTextField.layer.cornerRadius = .textFieldCornerRadius

        addSubview(idTextField)
        addSubview(userNameTextField)
        addSubview(passwordTextField)
        addSubview(emailTextField)
        addSubview(genderTextField)
        addSubview(creditCardTextField)
        addSubview(bioTextField)
    }

    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let indent: CGFloat = 21.0

        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: indent),
            idTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            idTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            userNameTextField.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: indent),
            userNameTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            userNameTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: indent),
            passwordTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            passwordTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            emailTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: indent),
            emailTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            emailTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            genderTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: indent),
            genderTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            genderTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            creditCardTextField.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant: indent),
            creditCardTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            creditCardTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent),

            bioTextField.topAnchor.constraint(equalTo: creditCardTextField.bottomAnchor, constant: indent),
            bioTextField.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: indent),
            bioTextField.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -indent)
        ])
    }

}
