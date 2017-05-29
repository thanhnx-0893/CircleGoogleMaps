//
//  InvertedCircleViewController.swift
//  CircleGoogleMaps
//
//  Created by Thanh Nguyen on 5/29/17.
//  Copyright © 2017 Vedusog. All rights reserved.
//

import UIKit
import GoogleMaps

class InvertedCircleViewController: UIViewController {

    @IBOutlet fileprivate weak var mapView: GMSMapView!
    let westernHemisphere = GMSPolygon()
    let easternHemisphere = GMSPolygon()

    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 21.016843, longitude: 105.784104, zoom: 15.0)
        mapView.animate(to: camera)
        let marker = GMSMarker(position: camera.target)
        marker.map = mapView
        drawCircle(centerOn: camera.target)
        drawInvertedCircle(centerOn: camera.target)
    }

    fileprivate func drawCircle(centerOn coordinate: CLLocationCoordinate2D) {
        let circle = GMSCircle(position: coordinate, radius: 500)
        circle.fillColor = .clear
        circle.strokeColor = .red
        circle.strokeWidth = 2.0
        circle.map = mapView
    }

    fileprivate func createHoles(in coordinate: CLLocationCoordinate2D, radius: CLLocationDistance)
            -> GMSMutablePath {
        let circlePath = GMSMutablePath()
        // 1.
        let centerPoint = mapView.projection.point(for: coordinate)
        // 2.
        let radius = mapView.projection.points(forMeters: radius, at: coordinate)
        var circlePoint = CGPoint()
        for angle in 0..<360 {
            circlePoint.x = centerPoint.x + radius * CGFloat(cos(Double(angle) * .pi / 180.0))
            circlePoint.y = centerPoint.y + radius * CGFloat(sin(Double(angle) * .pi / 180.0))
            circlePath.add(mapView.projection.coordinate(for: circlePoint))
        }
        return circlePath
    }

    fileprivate func drawPolygons() {
        // Draw Western Hemisphere
        let westernPath = GMSMutablePath()
        westernPath.addLatitude(-85.05115, longitude: -180.0)
        westernPath.addLatitude(85.05115, longitude: -180.0)
        westernPath.addLatitude(85.05115, longitude: 0.0)
        westernPath.addLatitude(-85.05115, longitude: 0.0)
        westernHemisphere.fillColor = UIColor.blue.withAlphaComponent(0.2)
        westernHemisphere.path = westernPath
        westernHemisphere.map = mapView
        // Draw Eastern Hemisphere
        let easternPath = GMSMutablePath()
        easternPath.addLatitude(-85.05115, longitude: 0.0)
        easternPath.addLatitude(85.05115, longitude: 0.0)
        easternPath.addLatitude(85.05115, longitude: 180.0)
        easternPath.addLatitude(-85.05115, longitude: 180.0)
        easternHemisphere.fillColor = UIColor.blue.withAlphaComponent(0.2)
        easternHemisphere.path = easternPath
        easternHemisphere.map = mapView
    }

    fileprivate func drawInvertedCircle(centerOn coordinate: CLLocationCoordinate2D) {
        drawPolygons()
        let hole = createHoles(in: coordinate, radius: 500)
        // Nếu tâm hình tròn nằm ở bán cầu tây thì set holes cho bán cầu tây và ngược lại.
        if coordinate.longitude < 0.0 {
            westernHemisphere.holes = [hole]
        } else {
            easternHemisphere.holes = [hole]
        }
    }

}
