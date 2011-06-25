//
//  NCEventLoaderTestSpec.m
//  HelloNSCoder
//
//  Created by Pedro Santos on 5/25/11.
//  Copyright 2011 NSCoder_BCN. All rights 

#import "NCArrayEventLoader.h"
#import "NCEventLoaderDelegate.h"

#import "Kiwi.h"

SPEC_BEGIN(NCEventLoaderTestSpec)

describe(@"NCEventLoader", ^{    
    context(@"when loadind data, delegate", ^{
        __block NCArrayEventLoader* eventLoader;
        __block id delegateMock;
        
        beforeEach(^{
            delegateMock = [KWMock mockForProtocol:@protocol(NCEventLoaderDelegate)];
        });
        
        afterEach(^{
            delegateMock = nil;
        });
        
        it(@"will be called when finished loading from a provided nil array of events.", ^{
            
            eventLoader = [[NCArrayEventLoader alloc] initWithEventList:nil];
            
            [[[delegateMock should] receive] didFinishUpdatingData:nil];
            
            eventLoader.delegate = delegateMock;
            [eventLoader loadEvents];
        });
        
        it(@"will be called when finished loading from a provided empty array of events.", ^{
            NSMutableArray* eventList = [[NSMutableArray alloc] initWithObjects:(nil)];
            
            eventLoader = [[NCArrayEventLoader alloc] initWithEventList:eventList];
            
            [[[delegateMock should] receive] didFinishUpdatingData:[[NSArray alloc] init]];
            
            eventLoader.delegate = delegateMock;
            [eventLoader loadEvents];
        });
        
        it(@"will not be called if not set.", ^{
            
            NCArrayEventLoader* eventLoader = [[NCArrayEventLoader alloc] initWithEventList:nil];
            
            [[[delegateMock shouldNot] receive] didFinishUpdatingData:nil];
            
            //eventLoader.delegate = delegateMock;
            [eventLoader loadEvents];
        });
    });
    
});

SPEC_END