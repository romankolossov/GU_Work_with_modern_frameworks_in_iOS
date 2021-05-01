//
//  MapViewController.swift
//  Maps
//
//  Created by Roman Kolosov on 31.03.2021.
//

import UIKit
import GoogleMaps
import RealmSwift
import RxSwift

class MapViewController: UIViewController, ReverseGeocodeLoggable, AlertShowable {

    // MARK: - Public properties

    public var publicMapView: GMSMapView {
        mapView
    }
    var manualMarker: GMSMarker?

    // MARK: - Private properties

    private let realmManager = RealmManager.shared
    private let locationManager = LocationManager.instance
    private let bag = DisposeBag()
    private(set) var route: GMSPolyline?
    private(set) var routePath: GMSMutablePath?
    private var marker: GMSMarker?
    private var userAvatarImage: UIImage?
    private var drawingRoutePath: Bool = false
    private let coordinate = CLLocationCoordinate2D(
        latitude: 55.753215, longitude: 37.622504) // Moscow, Red square.

    private lazy var mapView: GMSMapView = {
        let view = GMSMapView()
        // GMSMapViewDelegate method used for manual marker adding and drawing lines between tmem.
        view.delegate = self
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationVC()
        configureMapVC()

        configureMap()
        configureMapStyle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userAvatarImage = PhotoStorageService.shared.retrieveImage(forKey: "avatar")
        // RxSwift, use for route path drawing.
        configureLocationManager()
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
        // Flag of draving route path in prgress to avoid load saved route path when draving new one.
        drawingRoutePath = true
        // Remove from the map old line.
        route?.map = nil
        // Replace old line by new one.
        route = GMSPolyline()
        route?.strokeWidth = 3
        route?.strokeColor = .updateLocationStrokeColor
        // Add the new line on the map.
        route?.map = mapView
        // Replace old path by empty (without points yet) new one.
        routePath = GMSMutablePath()
        // Start or continue updating location.
        locationManager.startUpdatingLocation()
    }

    @objc private func finishUpdateLocation() {
        var coordinates: [CLLocationCoordinate2D] = []
        var latitudes: [Double] = []
        var longitudes: [Double] = []

        locationManager.stopUpdatingLocation()

        // Get coordinates of the route path points to get from them longs and lats.
        for index: UInt in 0...(routePath?.count() ?? 0) {
            guard let coordinate = routePath?.coordinate(at: index) else {
                return
            }
            coordinates.append(coordinate)
        }
        // Remove by system automatically added for technical use the last point.
        coordinates.removeLast()

        // Get longs and lats to save them in the Realm.
        coordinates.forEach { latitudes.append($0.latitude) }
        coordinates.forEach { longitudes.append($0.longitude) }

        // Save longs and lats of the points of the route path in Realm.
        DispatchQueue.main.async { [weak self] in
            let routePathElement = RoutePathElementData(latitudes: latitudes, longitudes: longitudes)
            try? self?.realmManager?.deleteAll()
            try? self?.realmManager?.add(object: routePathElement)
        }
        mapView.clear()
        removeMarker()
        // Stop driving route path flag to allow load saved route path.
        drawingRoutePath = false
    }

    @objc private func restoreRoutePath() {
        guard !drawingRoutePath else {
            showAlert(
                title: "Route path update",
                message: "Route path draw in process. To load saved route, please, finish drawing current route by pressing \"Stop\" button",
                handler: nil,
                completion: nil
            )
            return
        }
        var latitudes: [CLLocationDegrees] = []
        var longitudes: [CLLocationDegrees] = []

        // Load from Realm saved points of the last route path.
        let routePathElements: Results<RoutePathElementData>? = realmManager?.getObjects()

        // Get longs and lats.
        routePathElements?.first?.latitudes.forEach { latitudes.append($0) }
        routePathElements?.first?.longitudes.forEach { longitudes.append($0) }

        // Remove from the map old line, replace it by the new one, add the new line on the map.
        route?.map = nil
        route = GMSPolyline()
        route?.strokeWidth = 3
        route?.strokeColor = .restoreRoutePathStrokeColor
        route?.map = mapView

        // Replace old root path by one with loaded from Realm points in it.
        routePath = GMSMutablePath()
        for (index) in latitudes.indices {
            routePath?.addLatitude(latitudes[index], longitude: longitudes[index])
        }
        route?.path = routePath

        // Set the camera to fit the route path loaded.
        guard let routePath = routePath else {
            return
        }
        let bounds = GMSCoordinateBounds(path: routePath)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }

    // MARK: - Private methods

    // MARK: Configure

    private func configureNavigationVC() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.navigationBarLargeTitleTextColor
        ]
        navigationController?.navigationBar.isTranslucent = true

        navigationController?.navigationBar.tintColor = .navigationBarTintColor
        navigationController?.navigationBar.backgroundColor = .navigationBarBackgroundColor

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
            updateLocationItem, finisUpdateLocationItem, restoreRoutePathItem
        ]

        let currentLocationItem = UIBarButtonItem(
            image: UIImage(systemName: "location"),
            style: .plain,
            target: self,
            action: #selector(currentLocation)
        )
        let toggleMarkerItem = UIBarButtonItem(
            image: UIImage(systemName: "checkmark"),
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
            goToRedSquareItem, toggleMarkerItem, currentLocationItem
        ]
    }

    private func configureMapVC() {
        navigationItem.title = NSLocalizedString("routeTracker", comment: "")
        view.backgroundColor = .rootVCViewBackgroundColor
        (UIApplication.shared.delegate as? AppDelegate)?.restrictRotation = .portrait
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

    // RxSwift, configure location manager.

    private func configureLocationManager() {
        locationManager
            .location
            .subscribe(onNext: { [weak self] location in
                // Add a point when location changed and move the center of map to it drawing lines in between.
                guard let location = location else {
                    return
                }
                let position = location.coordinate
                // Add a marker on the map removing the previous one to make the marker move.
                // Marker is moving with user avatar in it.
                self?.removeMarker()
                self?.addMarker(with: self?.userAvatarImage, position: position)
                /*
                 // Case of adding an icon to marker as resized image.
                 self?.marker = GMSMarker(position: position)
                 let image = UIImage(named: "FerrariTestPicture")
                 let size = CGSize(width: 60.0, height: 60.0)
                 let resizedImage = image?.resized(to: size)
                 self?.marker?.icon = resizedImage
                 self?.marker?.map = self?.mapView
                 */
                // Add a point to the route path and update the path of the route line.
                // To make a line trail after moving marker.
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                // Set the camera to the point added to observe the movement.
                let camersPosition = GMSCameraPosition.camera(withTarget: position, zoom: 17)
                self?.mapView.animate(to: camersPosition)
            })
            .disposed(by: bag)
    }

    private func configureMap() {
        // Create a camera with the use of coordinates and the zoom level.
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        // Set the camera for the mapView.
        mapView.camera = camera
    }

    // To show ways of customizing a marker.

    private func addMarker() {
        /*
         // Make a custom shape of the marker, for example as a red rectangle.
         let rect = CGRect(x: 0, y: 0, width: 60, height: 60)
         let view = UIView(frame: rect)
         view.backgroundColor = .red
         */
        let marker = GMSMarker(position: coordinate)
        // marker.icon = GMSMarker.markerImage(with: .green)
        // marker.icon = UIImage(systemName: "figure.walk") // Marker as an image.
        // marker.iconView = view // Marker as a red rect.

        marker.title = "Hello"
        marker.snippet = "Red Square"

        // Set where the marked coordinate relatively to the marker is, for example in the middle of the marker.
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)

        // Set the map on the marker but not vise versa because in the case of many markers
        // and setting them on the map the collection of markers needs to be defined.
        marker.map = mapView
        self.marker = marker
    }

    // Add a marker on the map with round image view in it to show user avatar in the view.

    private func addMarker(with image: UIImage?, position: CLLocationCoordinate2D) {
        let rect = CGRect(x: 0.0, y: 0.0, width: .avatarViewSize, height: .avatarViewSize)
        let avatarView = UIView(frame: rect)
        let userImageView = UIImageView()

        userImageView.clipsToBounds = true
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.image = image

        avatarView.addSubview(userImageView)
        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            userImageView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalTo: avatarView.widthAnchor),
            userImageView.heightAnchor.constraint(equalTo: avatarView.heightAnchor)
        ])
        // Make rounded corners of the user image view.
        userImageView.layer.cornerRadius = 30.0

        // Create a marker and set its icon view to avatar view with user image view in it.
        let marker = GMSMarker(position: position)
        marker.iconView = avatarView

        marker.map = mapView
        self.marker = marker
    }

    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }

    private func configureMapStyle() {
        let style: String = MapStyleJSON.shared.customBlack

        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: style)
        } catch {
            print(error)
        }
    }

}
