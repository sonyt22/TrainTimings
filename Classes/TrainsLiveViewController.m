//
//  TrainsLiveViewController.m
//  TrainTimings
//
//  Created by sony on 07/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrainsLiveViewController.h"
#import "JSON.h"
#import <MapKit/MapKit.h>
#import "MapOperation.h"
#import "MapAnnotation.h"

@implementation TrainsLiveViewController
@synthesize opQueue;

-(void)extractData:(NSString*)string{
	//	NSLog(@"%@",string);
	NSMutableArray *listOfItems =[[ NSMutableArray alloc] init];
	south = [[NSDictionary alloc] init];
	NSDictionary *data=[[string JSONValue] objectForKey:@"data"];
	
	for (NSDictionary *dict in data) {
//		prevStation
		[listOfItems addObject:dict];
	}
	
	south = [[listOfItems objectAtIndex:0] objectForKey:@"south"];
	for (NSDictionary *dict in south) {
		//NSLog(@"%@",[dict objectForKey:@"prevStation"]);
		[self getCoordinatesFromLocation:[dict objectForKey:@"prevStation"]];
		
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	
}

#pragma mark label
#pragma mark operation delegates
- (void) getCoordinatesFromLocation:(NSString *)location {

	NSLog(@"added  queue");
	MapOperation *mapOperation = [[MapOperation alloc]  
								  initWithLocation:location target:self targetMethod:@selector(storeCoordinates:)];
	
	[self.opQueue addOperation:mapOperation];
	[mapOperation release];
}


- (void)storeCoordinates:(NSMutableArray *)coordinates {
	CLLocationCoordinate2D location;
	location.latitude = [[coordinates objectAtIndex:0] doubleValue];
	location.longitude = [[coordinates objectAtIndex:1] doubleValue];
	
	MapAnnotation *annotation = [[MapAnnotation alloc] initWithCoordinate:location];
	NSString *locationName = [NSString stringWithFormat:@"%@",[coordinates objectAtIndex:2]];
	
	for (NSDictionary *dict in south) {
		if (CFEqual(locationName,[dict objectForKey:@"prevStation"])) {
			annotation.title = [dict objectForKey:@"trainName"];
			annotation.subtitle = [NSString stringWithFormat:@"left %@ at %@",
							[dict objectForKey:@"prevStation"],[dict objectForKey:@"estimatedTimePrev"]];
		}
	}
	
	
	MKCoordinateRegion region = {location , {1,1}};
	[mapView setRegion:region];
	[mapView addAnnotation:annotation];
	[annotation release];
}

#pragma mark label
#pragma mark  Connection delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response{
	[responseData setLength:0];
	//	NSLog(@"Received Response --%d bytes",[NSNumber numberWithLongLong:[response expectedContentLength]]);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	//	NSLog(@"Received data --%d bytes",[NSNumber numberWithUnsignedInt:[data length]]);
	[responseData appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error{
	//	NSLog(@"Failed with error -%@",[error description]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
	NSLog(@"Loading finished");
	NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[self extractData:responseString];
}

#pragma mark view 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	responseData=[[NSMutableData alloc] retain];
 	NSMutableString *url=[NSString stringWithFormat:
						  @"http://10.1.0.49/live.php"];
	url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSLog(@"Connection requested");
	self.opQueue = [[NSOperationQueue alloc] init];
	[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//	self.navigationItem.rightBarButtonItem = [UINavigationItem alloc] initWith
	[super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
//	[mapView release];
    [super dealloc];
}


@end
