//
//  TrainsAtStationViewController.m
//  TrainTimings
//
//  Created by sony on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrainsAtStationViewController.h"
#import "JSON.h"

@implementation TrainsAtStationViewController
@synthesize tno, tname;

#pragma mark extractData
-(void)extractData:(NSString*)string{
//	NSLog(@"%@",string);
	NSDictionary *data=[[string JSONValue] objectForKey:@"data"];
	listOfItems=[[NSMutableArray alloc]init];
	for (NSDictionary *dict in data) {
		[listOfItems addObject:dict];
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	[stationTableView reloadData];
	
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    responseData=[[NSMutableData alloc] retain];
 	NSMutableString *url=[NSString stringWithFormat:
						  @"http://10.1.0.49/running.php?tno=%@&tname=%@",tno,tname];
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
	[tno release];
	[tname release];
    [super dealloc];
}


#pragma mark label
#pragma mark Table View dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}


/*
 -(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section{
 if (section==0)		
 return @"Trains towards South";
 else 
 return @"Trains towards North";
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [listOfItems count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
	
	UIButton *sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sectionButton.tag = section;
	sectionButton.frame = customView.frame;
	[sectionButton setImage:[UIImage imageNamed:@"title_header.png"] forState:UIControlStateNormal];
	[customView addSubview:sectionButton];
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 320, 15)] autorelease];	// JT 10.07.01
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:14];
	titleLabel.text = [NSString stringWithFormat:@"Tracking\n %@",tname];

	[customView addSubview:titleLabel];
	return [customView autorelease];
	
	
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
		return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
//	NSLog(@"%f - %@",textSize.height,tname);
	return 32;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		UILabel *stationNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 320, 20)] autorelease];	// JT 10.07.01
		stationNameLabel.numberOfLines = 2;
		stationNameLabel.tag = 1000;
		stationNameLabel.backgroundColor = [UIColor clearColor];
		//	stationNameLabel.textColor = [UIColor colorWithRed:0.36 green:0.44 blue:0.59 alpha:1.0];
		stationNameLabel.font = [UIFont boldSystemFontOfSize:14];
		[cell.contentView addSubview:stationNameLabel];
		
		
		UILabel *estimatedTimeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 25, 320, 15)] autorelease];	// JT 10.07.01
		estimatedTimeLabel.tag = 1001;
		//	estimatedTimeLabel.textAlignment = UITextAlignmentRight;
		estimatedTimeLabel.backgroundColor = [UIColor clearColor];
		//	estimatedTimeLabel.textColor = [UIColor colorWithRed:0.36 green:0.44 blue:0.59 alpha:1.0];
		estimatedTimeLabel.font = [UIFont boldSystemFontOfSize:13];
		[cell.contentView addSubview:estimatedTimeLabel];
		
		
		UILabel *scheduledTimeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 42, 320, 15)] autorelease];	// JT 10.07.01
		scheduledTimeLabel.tag = 1002;
		//	scheduledTimeLabel.textAlignment = UITextAlignmentRight;
		scheduledTimeLabel.backgroundColor = [UIColor clearColor];
		//	scheduledTimeLabel.textColor = [UIColor colorWithRed:0.36 green:0.44 blue:0.59 alpha:1.0];
		scheduledTimeLabel.font = [UIFont systemFontOfSize:13];
		[cell.contentView addSubview:scheduledTimeLabel];
		
		
   }
	
	UILabel *stationNameLabel = (UILabel *)[cell.contentView viewWithTag:1000];
	UILabel *estimatedTimeLabel = (UILabel *)[cell.contentView viewWithTag:1001];
	UILabel *scheduledTimeLabel = (UILabel *)[cell.contentView viewWithTag:1002];

	if([listOfItems count] == 0)
		return cell;
	
	NSDictionary *results = [listOfItems objectAtIndex:indexPath.row];
	stationNameLabel.text = [results objectForKey:@"stationName"];
	estimatedTimeLabel.text = [NSString stringWithFormat:@"Estimated Time:%@",[results objectForKey:@"estimatedTime"]];
	scheduledTimeLabel.text = [NSString stringWithFormat:@"Scheduled Time:%@",[results objectForKey:@"scheduledTime"]];
//	NSLog(@"%@",results);
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
