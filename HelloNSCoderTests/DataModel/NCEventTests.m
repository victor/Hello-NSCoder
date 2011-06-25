//
//  NCEventTests.m
//  HelloNSCoder
//
//  Created by Pedro Santos on 5/25/11.
//  Copyright 2011 NSCoder_BCN. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NCEvent.h"

@interface NCEventTests : SenTestCase {
    
    NCEvent *instance;
}

@end
@implementation NCEventTests

- (void)setUp {
    [super setUp];
    
    instance = [[NCEvent alloc] init];
}

- (void)tearDown {
    
    [instance release];
    instance = nil;
    
    [super tearDown];
}

- (void)testCanCreateInstance {
    
    STAssertNotNil(instance, @"Cannot create instance");
}

- (void)testCanSetName {
    instance.name = @"Test";
    
    STAssertEquals(instance.name, @"Test", @"Cannot set name");
}

- (void)testCanSetShortDescription {
    instance.shortDescription = @"Test";
    
    STAssertEquals(instance.shortDescription, @"Test", @"Cannot set short description");
}

- (void)testCanSetShortStartDate {
    NSDate* testDate = [NSDate date];
    instance.startDate = testDate;
    
    STAssertEquals(instance.startDate, testDate, @"Cannot set start date");
}

- (void)testCanSetShortLocation {
    instance.location = @"Test";
    
    STAssertEquals(instance.location, @"Test", @"Cannot set short location");
}

- (void)testCanSetShortFullDescription {
    instance.fullDescription = @"Test";
    
    STAssertEquals(instance.fullDescription, @"Test", @"Cannot set full description");
}

- (void)testCanSetShortLongitude {
    instance.longitude = 99.9f;
    
    STAssertEquals(instance.longitude, 99.9f, @"Cannot set longitude");
}

- (void)testCanSetShortLatitude {
    instance.latitude = 99.9f;
    
    STAssertEquals(instance.latitude, 99.9f, @"Cannot set latitude");
}

@end
