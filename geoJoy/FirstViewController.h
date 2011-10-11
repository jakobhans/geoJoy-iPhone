//
//  FirstViewController.h
//  geoJoy
//
//  Created by Jakob Hans Renpening on 22/08/11.
//  Copyright 2011 Claim Soluciones, S.C.P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLLocationController.h"
#import "annotationsController.h"
#import "dbModel.h"
#import "ConnectedClass.h"

@interface FirstViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, CoreLocationControllerDelegate, MKMapViewDelegate, UIAlertViewDelegate> {
    
    IBOutlet UIBarButtonItem *addDisplayLocationButton;
    IBOutlet UIBarButtonItem *updateLocationButton;
    IBOutlet UIButton *setCategoryButton;
    IBOutlet UITextField *itemLabel;
    IBOutlet UILabel *loadingViewText;
    IBOutlet UIPickerView *categoriesPicker;
    
    IBOutlet MKMapView *map;
    
    IBOutlet UIView *mapView;
    IBOutlet UIView *loadingView;
    IBOutlet UIView *categoriesView;
    IBOutlet UIView *containerView;
    
    NSString *pickerString;
    int pickerValue;
    NSArray *categories;
    BOOL mapScreenOnTop;

    CLLocationController *CLController;
    CLLocation *positionToBeSaved;
    
    dbModel *model;
}

@property (nonatomic, retain) dbModel *model;
@property (nonatomic, retain) MKMapView *map;
@property (nonatomic, retain) UIBarButtonItem *addDisplayLocationButton;
@property (nonatomic, retain) UIButton *setCategoryButton;
@property (nonatomic, retain) UITextField *itemLabel;
@property (nonatomic, retain) UILabel *loadingViewText;
@property (nonatomic, retain) UIView *loadingView, *categoriesView, *mapView, *containerView;
@property (nonatomic, assign) CLLocation *positionToBeSaved;
@property (nonatomic, retain) CLLocationController *CLController;

-(IBAction)addCurrentLocation;
-(IBAction)toggleToCategories;
-(IBAction)updatelocation;

@end
