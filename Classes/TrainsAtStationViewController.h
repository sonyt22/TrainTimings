//
//  TrainsAtStationViewController.h
//  TrainTimings
//
//  Created by sony on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TrainsAtStationViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource> {
	

	NSString *tno;
	NSString *tname;
	NSMutableArray *listOfItems;
	NSMutableData *responseData;
	IBOutlet UITableView *stationTableView;
}

@property (nonatomic, retain) NSString *tno;
@property (nonatomic, retain) NSString *tname;
@end
