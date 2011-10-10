//
//  annotationsController.h
//  geoJoy
//
//  Created by Jakob Hans Renpening on 24/09/11.
//  Copyright 2011 Claim Soluciones, S.C.P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface annotationsController : NSObject <MKAnnotation> {
    NSString *_title;
    NSString *_subtitle;
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate;

@end
