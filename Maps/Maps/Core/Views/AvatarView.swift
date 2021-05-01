//
//  AvatarView.swift
//  Maps
//
//  Created by Roman Kolosov on 24.04.2021.
//

import UIKit

class AvatarView: UIView {

    // MARK: - Public properties

    // MARK: Subviews

    lazy var userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        iv.image = PhotoStorageService.shared.retrieveImage(forKey: "avatar")
        return iv
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
        addSubview(userImageView)
    }

    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        let indent: CGFloat = 21.0

        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            userImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            userImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, constant: -2 * indent),
            userImageView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, constant: -2 * indent)
        ])
    }

}
