//
//  NCEventLoader.h
//  HelloNSCoder
//
//  Created by aquarioverde on 5/16/11.
//  Copyright 2011 NSCoder_BCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCEventLoaderDelegate.h"
#import "NCEvent.h"


/**
 Class for loading events
 */
@interface NCEventLoader : NSObject <NSXMLParserDelegate>{
    
    NSMutableData   *webData;       // Datat to hold web service response
    NSXMLParser     *xmlParser;     // XMLParser to parse web service response
    NCEvent         *currentElement;// Element being parsed on each iteration
    NSString        *cePropName;    // Name of the property being parsed on currentElement
    NSMutableArray  *eventList;     // List of parsed events from web service;
    
}

@property (nonatomic, assign) id <NCEventLoaderDelegate> delegate;

/**
 Load all events that are found nearby the devices current position
 */
- (void)loadNearbyEvents;

@end
