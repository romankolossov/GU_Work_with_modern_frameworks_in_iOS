//
//  MapViewController.swift
//  Maps
//
//  Created by Roman Kolosov on 31.03.2021.
//

import UIKit
import GoogleMaps
import RealmSwift

class MapViewController: UIViewController, ReverseGeocodeLoggable {

    // MARK: - Public properties

    public var publicMapView: GMSMapView {
        mapView
    }
    public var publicLocationManager: CLLocationManager {
        locationManager
    }
    var manualMarker: GMSMarker?

    // MARK: - Private properties

    private lazy var mapView: GMSMapView = {
        let view = GMSMapView()
        view.delegate = self
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.allowsBackgroundLocationUpdates = true
        lm.pausesLocationUpdatesAutomatically = false
        lm.startMonitoringSignificantLocationChanges()
        lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        lm.requestAlwaysAuthorization()
        // lm.requestWhenInUseAuthorization()
        return lm
    }()
    private(set) var route: GMSPolyline?
    private(set) var routePath: GMSMutablePath?
    private var marker: GMSMarker?
    private let realmManager = RealmManager.shared
    private let coordinate = CLLocationCoordinate2D(
        latitude: 55.753215, longitude: 37.622504) // Moscow, Red square.

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationVC()
        configureMapVC()

        configureMap()
        configureMapStyle()
    }

    // MARK: - Actions

    @objc private func toggleMarker() {
        guard marker == nil else {
            removeMarker()
            return
        }
        addMarker()
    }

    @objc private func goToRedSquare() {
        mapView.animate(toLocation: coordinate)
    }

    @objc private func currentLocation() {
        locationManager.requestLocation()
    }

    @objc private func updateLocation() {
        // Remove from the map old line.
        route?.map = nil
        // Replace old line by new one.
        route = GMSPolyline()
        // Replace old path by empty (without points yet) new one.
        routePath = GMSMutablePath()
        // Add new line on the map.
        route?.map = mapView
        // Start or continue updating location.
        locationManager.startUpdatingLocation()
    }

    @objc private func finishUpdateLocation() {
        locationManager.stopUpdatingLocation()
        var index: UInt = 0
        var coordinates: [CLLocationCoordinate2D] = []
        var latitudes: [Double] = []
        var longitudes: [Double] = []

        routePath.map {
            coordinates.append($0.coordinate(at: index))
            index += 1
        }
        coordinates.map { latitudes.append($0.latitude) }
        coordinates.map { longitudes.append($0.latitude) }

        DispatchQueue.main.async { [weak self] in
            let routePathElement = RoutePathElementData(latitudes: latitudes, longitudes: longitudes)
            try? self?.realmManager?.deleteAll()
            try? self?.realmManager?.add(object: routePathElement)
        }
        mapView.clear()
        removeMarker()
        // Remove from the map old line.
        route?.map = nil
    }

    @objc private func restoreRoutePath() {
        let routePathElements: Results<RoutePathElementData>? = realmManager?.getObjects()
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        //routePath = routePathElements?.first?.routePath
        route?.map = mapView
        route?.path = routePath
    }

    // MARK: - Private methods

    // MARK: Configure

    private func configureNavigationVC() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemPurple
        ]
        let toggleMarkerItem = UIBarButtonItem(
            image: UIImage(systemName: "checkmark.seal"),
            style: .plain,
            target: self,
            action: #selector(toggleMarker)
        )
        let goToRedSquareItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.down.right.and.arrow.up.left"),
            style: .plain,
            target: self,
            action: #selector(goToRedSquare)
        )
        navigationItem.rightBarButtonItems = [
            goToRedSquareItem, toggleMarkerItem
        ]

        let currentLocationItem = UIBarButtonItem(
            image: UIImage(systemName: "location"),
            style: .plain,
            target: self,
            action: #selector(currentLocation)
        )
        let updateLocationItem = UIBarButtonItem(
            image: UIImage(systemName: "point.fill.topleft.down.curvedto.point.fill.bottomright.up"),
            style: .plain,
            target: self,
            action: #selector(updateLocation)
        )
        let finisUpdateLocationItem = UIBarButtonItem(
            image: UIImage(systemName: "stop.circle"),
            style: .plain,
            target: self,
            action: #selector(finishUpdateLocation)
        )
        let restoreRoutePathItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.down.doc"),
            style: .plain,
            target: self,
            action: #selector(restoreRoutePath)
        )
        navigationItem.leftBarButtonItems = [
            currentLocationItem, updateLocationItem, finisUpdateLocationItem, restoreRoutePathItem
        ]
    }

    private func configureMapVC() {
        navigationItem.title = NSLocalizedString("routeTracker", comment: "")
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
        // Create a camera with the use of coordinates and the zoom level.
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        // Set the camera for the mapView.
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

    private func addMarker() {
        // Make a custom shape of the marker, for example as a red rectangle.
/*
        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
        let view = UIView(frame: rect)
        view.backgroundColor = .red
*/
        let marker = GMSMarker(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .green)
        // marker.icon = UIImage(systemName: "figure.walk") // Marker as an image.
        // marker.iconView = view // Marker as a red rect.

        marker.title = "Hello"
        marker.snippet = "Red Square"

        // Set where the marked coordinate relatively to the marker is, for example in the middle of the marker.
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)

        marker.map = mapView
        self.marker = marker
    }

    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }

}
