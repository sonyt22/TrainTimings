//
//  MapOperation.h
//  TrainTimings
//
//  Created by sony on 28/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapOperation : NSOperation  {
	id targetObject;
	SEL targetMethod;
	NSString *locationName;

}

- (id) initWithLocation:(NSString *)location target:(id)targetClass targetMethod:(SEL)targetClassMethod;
- (void) main;
@property (nonatomic,retain) NSString *locationName;
@end
