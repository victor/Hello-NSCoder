//
//  NCEventLoader.h
//  HelloNSCoder
//
//  Created by aquarioverde on 5/16/11.
//  Copyright 2011 NSCoder_BCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCEventLoaderDelegate.h"


/**
 Class for loading events
 */
@interface NCEventLoader : NSObject {
    
}

@property (nonatomic, assign) id <NCEventLoaderDelegate> delegate;

/**
 Load all events that are found nearby the devices current position
 */
- (void)loadNearbyEvents;

@end
