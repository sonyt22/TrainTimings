//
//  MapOperation.m
//  TrainTimings
//
//  Created by sony on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapOperation.h"
#import <MapKit/MapKit.h>

@implementation MapOperation
@synthesize locationName;

-(id) initWithLocation:(NSString *)location target:(id)targetClass targetMethod:(SEL)targetClassMethod {
	//	NSLog(@"map op");
	if(self = [super init]) {
	self.locationName = [location retain];
	targetObject = targetClass;
	targetMethod = targetClassMethod;
	}
	return self;
}

- (void)main {
	NSAutoreleasePool *localPool;
	@try {
		localPool = [[NSAutoreleasePool alloc] init];
		if(self.isCancelled)
			return;
		NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
							   [self.locationName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
		NSMutableArray *listItems = [locationString componentsSeparatedByString:@","];

	
		
		if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
			[listItems removeObjectAtIndex:0];
			[listItems removeObjectAtIndex:0];
			[listItems addObject:self.locationName];
		[targetObject performSelectorOnMainThread:targetMethod withObject:listItems waitUntilDone:NO];		
		}
		else {
			NSLog(@"Error getting coordinates");
		}
	
	
		
	}
	@catch (NSException *e) {
		NSLog(@"%@",[e reason]);	
	}
	@finally {

	}
	
	
	
	
}



@end
