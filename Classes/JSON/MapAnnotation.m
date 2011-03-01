//
//  MapAnnotation.m
//  TrainTimings
//
//  Created by sony on 01/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation
@synthesize coordinate, title, subtitle;


+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coord {

	return [[[[self class] alloc] initWithCoordinate:coord] autorelease];
	
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
	
	if(self = [super init])
	{
		self.coordinate = coord;
		
		
	}
	
	return self;	
}

- (void)dealloc {
	
	[title release];
	[subtitle release];
	[super dealloc];
	
}

@end
