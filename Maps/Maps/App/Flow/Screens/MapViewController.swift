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
    private var marker: GMSMarker?
    private let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504) // Центр Москвы

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationVC()
        configureMapVC()

        configureMap()
        configureMapStyle()
    }

    // MARK: - Actions

    @objc private func goToRedSquare() {
        mapView.animate(toLocation: coordinate)
    }

    @objc private func toggleMark() {
        guard marker == nil else {
            removeMark()
            return
        }
        addMark()
    }

    // MARK: - Private methods

    private func addMark() {
//        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
//        let view = UIView(frame: rect)
//        view.backgroundColor = .red

        let marker = GMSMarker(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .green)
        // marker.icon = UIImage(systemName: "figure.walk") // marker as an image
        // marker.iconView = view // marker as a red rect

        marker.title = "Hello"
        marker.snippet = "Red Square"

        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)

        marker.map = mapView
        self.marker = marker
    }

    private func removeMark() {
        marker?.map = nil
        marker = nil
    }

    // MARK: Configure

    private func configureNavigationVC() {
        let goToRedSquareItem = UIBarButtonItem(
            image: UIImage(systemName: "figure.walk"),
            style: .plain,
            target: self,
            action: #selector(goToRedSquare)
        )
        let addMarkItem = UIBarButtonItem(
            image: UIImage(systemName: "checkmark.seal"),
            style: .plain,
            target: self,
            action: #selector(toggleMark)
        )
        navigationItem.rightBarButtonItem = goToRedSquareItem
        navigationItem.leftBarButtonItem = addMarkItem
    }

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

    private func configureMap() {
        // Создаём камеру с использованием координат и уровнем увеличения
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        // Устанавливаем камеру для карты
        mapView.camera = camera
    }

    private func configureMapStyle() {
           let style = "[" +
               "  {" +
               "    \"featureType\": \"all\"," +
               "    \"elementType\": \"geometry\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#242f3e\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"all\"," +
               "    \"elementType\": \"labels.text.stroke\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"lightness\": -80" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"administrative\"," +
               "    \"elementType\": \"labels.text.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#746855\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"administrative.locality\"," +
               "    \"elementType\": \"labels.text.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#d59563\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"poi\"," +
               "    \"elementType\": \"labels.text.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#d59563\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"poi.park\"," +
               "    \"elementType\": \"geometry\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#263c3f\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"poi.park\"," +
               "    \"elementType\": \"labels.text.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#6b9a76\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"road\"," +
               "    \"elementType\": \"geometry.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#2b3544\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"road\"," +
               "    \"elementType\": \"labels.text.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#9ca5b3\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"road.arterial\"," +
               "    \"elementType\": \"geometry.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#38414e\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"road.arterial\"," +
               "    \"elementType\": \"geometry.stroke\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#212a37\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"road.highway\"," +
               "    \"elementType\": \"geometry.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#746855\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"road.highway\"," +
               "    \"elementType\": \"geometry.stroke\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#1f2835\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"road.highway\"," +
               "    \"elementType\": \"labels.text.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#f3d19c\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"road.local\"," +
               "    \"elementType\": \"geometry.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#38414e\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"road.local\"," +
               "    \"elementType\": \"geometry.stroke\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#212a37\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"transit\"," +
               "    \"elementType\": \"geometry\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#2f3948\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"transit.station\"," +
               "    \"elementType\": \"labels.text.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#d59563\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"water\"," +
               "    \"elementType\": \"geometry\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#17263c\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"water\"," +
               "    \"elementType\": \"labels.text.fill\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"color\": \"#515c6d\"" +
               "      }" +
               "    ]" +
               "  }," +
               "  {" +
               "    \"featureType\": \"water\"," +
               "    \"elementType\": \"labels.text.stroke\"," +
               "    \"stylers\": [" +
               "      {" +
               "        \"lightness\": -20" +
               "      }" +
               "    ]" +
               "  }" +
           "]"
           do {
               mapView.mapStyle = try GMSMapStyle(jsonString: style)
           } catch {
               print(error)
           }
       }

}
