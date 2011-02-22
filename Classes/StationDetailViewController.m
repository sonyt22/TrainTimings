//
//  StationDetailViewController.m
//  TrainTimings
//
//  Created by sony on 08/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StationDetailViewController.h"
#import "TrainsAtStationViewController.h"

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
	NSDictionary *data=[[string JSONValue] objectForKey:@"data"];
	listOfItems=[[NSMutableArray alloc]init];
	for (NSDictionary *dict in data) {
		[listOfItems addObject:dict];
	}
	[trainTableView reloadData];
	
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

/*
-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section{
	if (section==0)		
	return @"Trains towards South";
	else 
	return @"Trains towards North";
}
*/


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
	switch (section) {
		case 0:
			titleLabel.text=@"Train towards South";
			break;
		case 1:
			titleLabel.text=@"Train towards North";
			break;
		default:
			break;
	}
	[customView addSubview:titleLabel];
	return [customView autorelease];
	

	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 32;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		UILabel *trainLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 320, 20)] autorelease];	// JT 10.07.01
		trainLabel.numberOfLines = 2;
		trainLabel.tag = 1000;
		trainLabel.backgroundColor = [UIColor clearColor];
	//	trainLabel.textColor = [UIColor colorWithRed:0.36 green:0.44 blue:0.59 alpha:1.0];
		trainLabel.font = [UIFont boldSystemFontOfSize:14];
		[cell.contentView addSubview:trainLabel];
		
		
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
		
		
		UILabel *trainNoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 60, 320, 15)] autorelease];	// JT 10.07.01
		trainNoLabel.numberOfLines = 2;
		trainNoLabel.tag = 1003;
	//	trainNoLabel.textAlignment = UITextAlignmentRight;
		trainNoLabel.backgroundColor = [UIColor clearColor];
	//	trainNoLabel.textColor = [UIColor colorWithRed:0.36 green:0.44 blue:0.59 alpha:1.0];
		trainNoLabel.font = [UIFont systemFontOfSize:13];
		[cell.contentView addSubview:trainNoLabel];
		
		
    }
	
	UILabel *trainLabel = (UILabel *)[cell.contentView viewWithTag:1000];
	UILabel *estimatedTimeLabel = (UILabel *)[cell.contentView viewWithTag:1001];
	UILabel *scheduledTimeLabel = (UILabel *)[cell.contentView viewWithTag:1002];
	UILabel *trainNoLabel = (UILabel *)[cell.contentView viewWithTag:1003];
	
	NSDictionary *dict=[listOfItems objectAtIndex:indexPath.section];
	NSArray *directions=[dict objectForKey:@"south"]?[dict objectForKey:@"south"]:[dict objectForKey:@"north"];
	
	if([directions count] <= indexPath.row)
		{
			trainLabel.text=@"No train available";
			trainLabel.frame=CGRectMake(95, 32, 320, 15);
			return cell;
		}

	NSDictionary *results=[directions objectAtIndex:indexPath.row];
	estimatedTimeLabel.text = [NSString stringWithFormat:@"Estimated Time - %@",[results objectForKey:@"estimatedTime"]];
	scheduledTimeLabel.text	= [NSString stringWithFormat:@"Scheduled Time - %@",[results objectForKey:@"scheduledTime"]];
	trainLabel.text = [results objectForKey:@"trainName"];
	trainNoLabel.text = [NSString stringWithFormat:@"Train No - %@",[results objectForKey:@"trainNo"]];

	
	NSLog(@"cell");
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TrainsAtStationViewController *detailVC =[ [TrainsAtStationViewController alloc] 
											  initWithNibName:@"TrainsAtStationViewController"
											  bundle:nil];
	NSDictionary *dict=[listOfItems objectAtIndex:indexPath.section];
	NSArray *directions=[dict objectForKey:@"south"]?[dict objectForKey:@"south"]:[dict objectForKey:@"north"];
	NSDictionary *results=[directions objectAtIndex:indexPath.row];
	detailVC.tno = [NSString stringWithFormat:@"%@",[results objectForKey:@"trainNo"]];
	detailVC.tname = [NSString stringWithFormat:@"%@",[results objectForKey:@"trainName"]];
	[self.navigationController pushViewController:detailVC animated:YES];
	
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
