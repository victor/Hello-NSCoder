//
//  NCEventLoaderDelegate.h
//  HelloNSCoder
//
//  Created by aquarioverde on 5/24/11.
//  Copyright 2011 NSCoder_BCN. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Protocol defining the methods to implement to be able to retrive data
 */
@protocol NCEventLoaderDelegate <NSObject>

@required

- (void)didFinishUpdatingData:(NSMutableArray *)newData;

@end
