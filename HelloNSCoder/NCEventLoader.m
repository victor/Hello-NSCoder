//
//  NCEventLoader.m
//  HelloNSCoder
//
//  Created by aquarioverde on 5/16/11.
//  Copyright 2011 NSCoder_BCN. All rights reserved.
//

#import "NCEventLoader.h"

@implementation NCEventLoader

@synthesize delegate;


/**
 Load events from a predefined pList
 */
- (void)loadNearbyEventsFromPList
{
    NSString *pathPlist=[[NSBundle mainBundle]pathForResource:@"dataEvents" ofType:@"plist"];
    
    NSMutableArray *eventsPlist=[[NSMutableArray alloc]initWithContentsOfFile:pathPlist];
    NSMutableArray *events = [[[NSMutableArray alloc] init] autorelease];
    
    for (int i=0; i<[eventsPlist count]; i++) {
        NSDictionary *dictEvent=[eventsPlist objectAtIndex:i];
        NCEvent *event = [[NCEvent alloc] initWithName:[dictEvent objectForKey:@"name"] startDate:[dictEvent objectForKey:@"startDate"] location:[dictEvent objectForKey:@"location"]];
        
        event.shortDescription = [dictEvent objectForKey:@"shortDescription"];
        event.fullDescription = [dictEvent objectForKey:@"fullDescription"];
        event.longitude = [[dictEvent objectForKey:@"longitude"] floatValue];
        event.latitude = [[dictEvent objectForKey:@"latitude"] floatValue];
        
        [events addObject:event];               
    }
    
    [delegate didFinishUpdatingData:events];
    
    [eventsPlist release];    
}

/**
 Load events by creating a simple array looping and numbering
 */
- (void)loadNearbyEventsFromLoop
{
    // load all events nearby
    NSMutableArray *events = [[[NSMutableArray alloc] init] autorelease];
    
    for (int i = 0; i < 7; i++) {
        NCEvent *event = [[NCEvent alloc] initWithName:[NSString stringWithFormat:@"Hello NSCoder %i", i] startDate:[NSDate date] location:@"CINC Barcelona"];        
        
        event.shortDescription = @"Introducción a la programación con iOS";
        event.fullDescription = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
        
        [events addObject:event];
    }        
    
    [delegate didFinishUpdatingData:events];
}

- (void) loadNearbyEventsFromWebService
{
    NSString *soapMessage = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                             "<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:tns=\"http://localhost/nscoder/service.php\">\n"
                             "<SOAP-ENV:Body>\n"
                             "<tns:getNearbyEvents xmlns:tns=\"http://localhost/nscoder/service.php\">\n"
                             "<latitude xsi:type=\"xsd:float\">%f</latitude>\n"
                             "<longitude xsi:type=\"xsd:float\">%f</longitude>\n"
                             "</tns:getNearbyEvents></SOAP-ENV:Body></SOAP-ENV:Envelope>", 41.406927, 2.209925];
    
    
    NSURL *url = [NSURL URLWithString:@"http://localhost/nscoder/service.php"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d",[soapMessage length]];
    [theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:@"http://localhost/nscoder/service.php/getNearbyEvents" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection)
        webData = [[NSMutableData data] retain];
    else 
        NSLog(@"theConnection is null");

}

#pragma --
#pragma NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];  // Inicialization of response data content
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [webData appendData:data];  //Store data received into our variable
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    NSLog(@"Error connecting to web service: %@", [error localizedDescription]); // Show error 
    [connection release];   // Release connection object
    [webData release];      // Release webData as we won't call next function so is our last chance to release
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (xmlParser) {            // If it's been loaded previously
        [xmlParser release];    // Release it
    }
    
    eventList = [[NSMutableArray alloc] init];              // Initialize the list of events that we are going to get
    xmlParser = [[NSXMLParser alloc] initWithData:webData]; // Initialize the XML parser with the data obtained form the service
    [xmlParser setDelegate:self];                           // Set self as delegate to manage from here all the responses
    [xmlParser setShouldResolveExternalEntities:YES];       
    [xmlParser parse];                                      // We start parsing our data
    
    [xmlParser release];
    [connection release];                                   // As we won't need the connection and the webData again we release them.
    [webData release];
}

#pragma --
#pragma NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"]) {                // If we are on a new element
        currentElement = [[NCEvent alloc] init];                // Let's initialize
    } else
        cePropName = [NSString stringWithString:elementName];   // If it is a property, let's take note of which of them are we on
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([cePropName isEqualToString:@"longitude"]) 
        [currentElement setLongitude:[string floatValue]];
    else if ([cePropName isEqualToString:@"latitude"])
        [currentElement setLatitude:[string floatValue]];
    else if ([cePropName isEqualToString:@"location"])
    {
        if ([currentElement.location length] == 0) {
            [currentElement setLocation:string];
        } else
            [currentElement setLocation:[currentElement.location stringByAppendingString:string]];
    }
    else if ([cePropName isEqualToString:@"name"])
    {
        if ([currentElement.name length] == 0) {
            [currentElement setName:string];
        } else
            [currentElement setName:[currentElement.name stringByAppendingString:string]];
    }
    else if ([cePropName isEqualToString:@"shortdescription"])
    {
        if ([currentElement.shortDescription length] == 0) {
            [currentElement setShortDescription:string];
        } else
            [currentElement setShortDescription:[currentElement.shortDescription stringByAppendingString:string]];
    }
    else if ([cePropName isEqualToString:@"fulldescription"])
    {
        if ([currentElement.fullDescription length] == 0) {
            [currentElement setFullDescription:string];
        } else
            [currentElement setFullDescription:[currentElement.fullDescription stringByAppendingString:string]];
    }
    else if ([cePropName isEqualToString:@"startdate"])
    {
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
        [currentElement setStartDate:[dateFormatter dateFromString:string]];
    }
         
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        [eventList addObject:currentElement];
        [currentElement release];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [delegate didFinishUpdatingData:eventList];
    [eventList release];
}

- (void)loadNearbyEvents
{
    if (!delegate) 
        return;
    
    // load all events nearby
    [self loadNearbyEventsFromWebService];
}


@end
