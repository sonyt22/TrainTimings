//
//  StationViewController.h
//  TrainTimings
//
//  Created by sony on 07/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StationViewController : UITableViewController {
	NSDictionary *stationList;
	NSMutableArray *statioName;
}

@property(nonatomic,retain) NSDictionary *stationList;
@property(nonatomic,retain) NSMutableArray *stationName;
@end
