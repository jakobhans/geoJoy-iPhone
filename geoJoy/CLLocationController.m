//
//  CLLocationController.m
//  geoJoy
//
//  Created by Jakob Hans Renpening on 24/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLLocationController.h"

@implementation CLLocationController

@synthesize locMgr, delegate;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.locMgr = [[[CLLocationManager alloc] init] autorelease];
        self.locMgr.delegate = self;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
        self.locMgr.distanceFilter = 50;
    }
    [self.locMgr startUpdatingLocation];
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if ([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
        [self.delegate locationUpdate:newLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
        [self.delegate locationError:error];
    }
}

-(void)dealloc {
    [locMgr release];
    [super dealloc];
}

@end
