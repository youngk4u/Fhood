//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <MapKit/MapKit.h>

@interface MKMapView (UIGestureRecognizer)

// This tells the compiler that MKMapView actually implements this method. This is required to be able to
// forward touches on our callout view without the need to add a standard accessory.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end
