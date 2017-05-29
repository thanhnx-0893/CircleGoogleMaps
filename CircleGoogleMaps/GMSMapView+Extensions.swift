//
//  GMSMapView+Extensions.swift
//  CircleGoogleMaps
//
//  Created by Thanh Nguyen on 6/5/17.
//  Copyright © 2017 Vedusog. All rights reserved.
//

import GoogleMaps

extension GMSMapView {

    // circleRatio for example: 300.0/360.0
    func animateToFitCircleOn(center: CLLocationCoordinate2D, radius: CLLocationDistance, circleRatio: Double) {
        let centerPoint = projection.point(for: center)
        // Tính w
        let halfWidth = radius / circleRatio
        // Tính h
        let halfHeight = halfWidth / Double(self.bounds.width / self.bounds.height)
        // Tính c
        let halfCross = sqrt(halfWidth * halfWidth + halfHeight * halfHeight)
        let radiusInView = projection.points(forMeters: halfCross, at: center)
        // Tính góc alpha, beta
        let beta = atan(halfHeight / halfWidth)
        let alpha = beta - .pi
        var topLeftPoint = CGPoint()
        var bottomRightPoint = CGPoint()
        // Tính toạ độ top left, bottom right: CGPoint
        topLeftPoint.x = centerPoint.x + radiusInView * CGFloat(cos(alpha))
        topLeftPoint.y = centerPoint.y + radiusInView * CGFloat(sin(alpha))
        bottomRightPoint.x = centerPoint.x + radiusInView * CGFloat(cos(beta))
        bottomRightPoint.y = centerPoint.y + radiusInView * CGFloat(sin(beta))
        // Convert sang toạ độ latitude, longitude
        let topLeft = projection.coordinate(for: topLeftPoint)
        let bottomRight = projection.coordinate(for: bottomRightPoint)
        let bounds = GMSCoordinateBounds(coordinate: topLeft, coordinate: bottomRight)
        let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 0.0)
        animate(with: cameraUpdate)
    }

}
