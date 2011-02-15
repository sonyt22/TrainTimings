//
//  StationDetailViewController.h
//  TrainTimings
//
//  Created by sony on 08/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StationDetailViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource> {
	NSString *stationCode;
	NSString *stationName;
	NSMutableData *responseData;
	NSMutableArray *listOfItems;
	IBOutlet UILabel *trainHeaderLabel;
	IBOutlet UITableView *tableView;
}
@property(nonatomic,retain)NSString *stationCode;
@property(nonatomic,retain) NSString *stationName;
@property(nonatomic,retain) UILabel *trainHeaderLabel;
- (void) extractData:(NSString *)string;
@end
