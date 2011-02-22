//
//  TrainsLiveViewController.h
//  TrainTimings
//
//  Created by sony on 07/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	
	NSString *mTitle;
	NSString *mSubTitle;
}

@end


@interface TrainsLiveViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;
	AddressAnnotation *addAnnotation;
	NSMutableData *responseData;
}

- (void) showAddress:(NSMutableArray *)location;
//- (CLLocationCoordinate2D) addressLocation;
- (CLLocationCoordinate2D) addressLocation:(NSMutableArray *)locationName;
@end
