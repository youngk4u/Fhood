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

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let calloutPoint = self.calloutView?.convert(point, from: self)
        let calloutView = calloutPoint.map { self.calloutView?.hitTest($0, with: event) }
        return calloutView! ?? super.hitTest(point, with: event)
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view is UIControl ? false : super.gestureRecognizer(gestureRecognizer, shouldReceive: touch)
    }
}
