//
//  TrainsLiveViewController.h
//  TrainTimings
//
//  Created by sony on 07/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TrainsLiveViewController : UIViewController <MKMapViewDelegate>{
	
	NSMutableData *responseData;
	NSMutableDictionary *south;
	NSMutableDictionary *north;
	NSOperationQueue *opQueue;
	IBOutlet MKMapView *mapView;
}

- (void)getCoordinatesFromLocation:(NSString *)location;
- (void)storeCoordinates:(NSMutableArray *)coordinates;

@property (nonatomic, retain) NSOperationQueue *opQueue;
@end
