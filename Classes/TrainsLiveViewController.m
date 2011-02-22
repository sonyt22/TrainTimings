//
//  TrainsLiveViewController.m
//  TrainTimings
//
//  Created by sony on 07/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrainsLiveViewController.h"
#import <MapKit/MapKit.h>

@implementation AddressAnnotation
@synthesize coordinate;

- (NSString *)subtitle{
	return @"Sub Title";
}
- (NSString *)title{
	return @"Title";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}

@end




@implementation TrainsLiveViewController

- (void)extractData:(NSString *)string {
	
	NSDictionary *data = [[string JSONValue] objectForKey:@"data"];
	NSMutableArray *listOfItems = [[NSMutableArray alloc] init];
	for (NSDictionary *dict in data) {
		//NSLog(@"%@",[dict objectForKey:@"leftStation"]);	
		[listOfItems addObject:[dict objectForKey:@"leftStation"]];	
		
	}
	[self showAddress:listOfItems];
//	NSLog(@"%@",listOfItems);
	
}
#pragma mark  Connection delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response{
	[responseData setLength:0];
	//	NSLog(@"Received Response --%d bytes",[NSNumber numberWithLongLong:[response expectedContentLength]]);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	//NSLog(@"Received data --%d bytes",[NSNumber numberWithUnsignedInt:[data length]]);
	[responseData appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error{
		NSLog(@"Failed with error -%@",[error description]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
	NSLog(@"Loading finished");
	NSString *responseString=[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[self extractData:responseString];
}

#pragma mark MAP 

- (void) showAddress: (NSMutableArray *)locationNameArray {
	MKCoordinateRegion region;
	MKCoordinateSpan span;

	span.latitudeDelta=0.2;
	span.longitudeDelta=0.2;
	
	for (NSString * locationNamestring in locationNameArray) {
//		NSLog(@"%@",locationNamestring);
	CLLocationCoordinate2D location = [self addressLocation:locationNamestring];
	region.span=span;
	region.center=location;
	
	if(addAnnotation != nil)
	{
	//	[mapView removeAnnotation:addAnnotation];
		[addAnnotation release];
		addAnnotation = nil;
	}
	
	addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	[mapView addAnnotation:addAnnotation];
	
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	//[mapView selectAnnotation:mLodgeAnnotation animated:YES];
	}	
}


-(CLLocationCoordinate2D) addressLocation:(NSString *)locationNameString{
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",locationNameString]; 
						  // [addressField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
	NSArray *listItems = [locationString componentsSeparatedByString:@","];
	
	double latitude = 0.0;
	double longitude = 0.0;
	
	if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
		latitude = [[listItems objectAtIndex:2] doubleValue];
		longitude = [[listItems objectAtIndex:3] doubleValue];
	}
	else {
		NSLog(@"error getting latitude");
	}
	CLLocationCoordinate2D location;
	location.latitude = latitude;
	location.longitude = longitude;
	
	return location;
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annView.pinColor = MKPinAnnotationColorGreen;
	annView.animatesDrop=TRUE;
	annView.canShowCallout = YES;
	annView.calloutOffset = CGPointMake(-5, 5);
	return annView;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

#pragma mark view 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	responseData=[[NSMutableData alloc] retain];
 	NSMutableString *url=[NSString stringWithFormat:
						  @"http://10.1.0.49/live.php"];
	url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	//NSLog(@"%@",url);
	NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSLog(@"Connection requested");
	[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
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
