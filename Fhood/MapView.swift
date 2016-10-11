//
//  MapView.swift
//  Fhood
//
//  Created by Matias Pequeno on 9/26/15.
//  Copyright © 2016 Fhood LLC. All rights reserved.
//

import UIKit
import MapKit
import SMCalloutView

final class MapView: MKMapView {

    weak var calloutView: SMCalloutView?

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let calloutPoint = self.calloutView?.convertPoint(point, fromView: self)
        let calloutView = calloutPoint.map { self.calloutView?.hitTest($0, withEvent: event) }
        return calloutView! ?? super.hitTest(point, withEvent: event)
    }

    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view is UIControl ? false : super.gestureRecognizer(gestureRecognizer, shouldReceiveTouch: touch)
    }
}
