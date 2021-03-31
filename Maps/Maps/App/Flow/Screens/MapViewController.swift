//
//  MapViewController.swift
//  Maps
//
//  Created by Roman Kolosov on 31.03.2021.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    // MARK: - Private properties

    private lazy var mapView: GMSMapView = {
        let view = GMSMapView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapVC()
    }

    // MARK: - Private methods

    // MARK: Configure

    private func configureMapVC() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(mapView)
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        let mapViewConstraints = [
            mapView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            mapView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: safeArea.heightAnchor)
        ]
        NSLayoutConstraint.activate(mapViewConstraints)
    }

}
