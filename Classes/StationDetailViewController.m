//
//  StationDetailViewController.m
//  TrainTimings
//
//  Created by sony on 08/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StationDetailViewController.h"
#import <regex.h>

@implementation StationDetailViewController
@synthesize stationCode,stationName,trainHeaderLabel;
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
#pragma mark extractData
-(void)extractData:(NSString*)string{
	NSLog(@"%@",string);
	NSDictionary *data=[[string JSONValue] objectForKey:@"data"];
	listOfItems=[[NSMutableArray alloc]init];
	for (NSDictionary *dict in data) {
		[listOfItems addObject:dict];
	}
	[tableView reloadData];
	
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
	[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
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

#pragma mark label
#pragma mark Table View dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [listOfItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *dict=[listOfItems objectAtIndex:section];
	NSDictionary *directions=[dict objectForKey:@"south"]?[dict objectForKey:@"south"]:
							[dict objectForKey:@"north"];
	
	return ([directions count]?[directions count]:1);
	
}

-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section{
	if (section==0)		
	return @"Trains towards South";
	else 
	return @"Trains towards North";

	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.textLabel.font=[UIFont fontWithName:@"Verdana" size:13];
	NSDictionary *dict=[listOfItems objectAtIndex:indexPath.section];
	NSArray *directions=[dict objectForKey:@"south"]?[dict objectForKey:@"south"]:[dict objectForKey:@"north"];
	
	if([directions count] <= indexPath.row)
		{
			cell.textLabel.text=@"No train available";	
			return cell;
		}
	NSDictionary *results=[directions objectAtIndex:indexPath.row];
	NSString *tr=[NSString stringWithFormat:@"%@(%@)%@-%@",
						 [results objectForKey:@"estimatedTime"],
						 [results objectForKey:@"scheduledTime"],
						[results objectForKey:@"trainName"],
						 [results objectForKey:@"trainNo"]];
	cell.textLabel.text=tr;
	
	[cell.textLabel setClipsToBounds:YES];
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	responseData=[[NSMutableData alloc] retain];
 	trainHeaderLabel.text=[NSString stringWithFormat:@"Arrival at %@",stationName];
	NSMutableString *url=[NSString stringWithFormat:
				   @"http://10.1.0.49/arrivals.php?stc=%@&stn=%@",stationCode,stationName];
	url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	//NSLog(@"%@",url);
	NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSLog(@"Connection requested");
	[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
	[super viewDidLoad];
}


/*
 http://trains.technoparkliving.com/arrivals.php?stc=DINR&stn=Divine%20Nagar%20Halt
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
	[responseData release];
	[trainHeaderLabel release];
	[stationCode release];
	[stationName release];
    [super dealloc];
}


@end
