//
//  FitCircleViewController.swift
//  CircleGoogleMaps
//
//  Created by Thanh Nguyen on 6/5/17.
//  Copyright © 2017 Vedusog. All rights reserved.
//

import UIKit
import GoogleMaps

class FitCircleViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    let circleRatio = 300.0 / 360.0

    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinate = CLLocationCoordinate2D(latitude: 21.016843, longitude: 105.784104)
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        mapView.animateToFitCircleOn(center: coordinate, radius: 500, circleRatio: circleRatio)
        drawCircle(centerOn: coordinate)
    }

    fileprivate func drawCircle(centerOn coordinate: CLLocationCoordinate2D) {
        let circle = GMSCircle(position: coordinate, radius: 500)
        circle.fillColor = .clear
        circle.strokeColor = .red
        circle.strokeWidth = 2.0
        circle.map = mapView
    }

}
