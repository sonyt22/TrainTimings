//
//  TrainTimingsAppDelegate.h
//  TrainTimings
//
//  Created by sony on 07/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrainTimingsViewController;

@interface TrainTimingsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
   IBOutlet UITabBarController *tabController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;
@end

