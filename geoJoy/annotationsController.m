//
//  annotationsController.m
//  geoJoy
//
//  Created by Jakob Hans Renpening on 24/09/11.
//  Copyright 2011 Claim Soluciones, S.C.P. All rights reserved.
//

#import "annotationsController.h"

@implementation annotationsController

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

-(id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _title = [title copy];
        _subtitle = [subtitle copy];
        _coordinate = coordinate;
    }
    return self;
}

-(void)dealloc {
    [_title release];
    [_subtitle release];
    [super dealloc];
}

@end
