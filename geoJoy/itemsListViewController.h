//
//  itemsListViewController.h
//  geoJoy
//
//  Created by Jakob Hans Renpening on 22/08/11.
//  Copyright 2011 Claim Soluciones, S.C.P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "annotationsController.h"
#import "dbModel.h"
#import "CLLocationController.h"
#import "ConnectedClass.h"

@interface itemsListViewController : UIViewController <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate> {
    
    IBOutlet UIView *theTableView;
    IBOutlet UIView *detailsView;
    IBOutlet UIView *detailsMapView;
    IBOutlet UIView *detailsEditView;
    IBOutlet UILabel *itemsCountLabel;
    
    IBOutlet UIBarButtonItem *generalEditButton;
    
    IBOutlet UIPickerView *editCategoriesPicker;
    IBOutlet UITextField *editItemLabel;
    IBOutlet UIButton *editSaveItem;
    IBOutlet UIBarButtonItem *backToList;
    
    IBOutlet UITableView *itemsTable;
    
    IBOutlet MKMapView *detailMap;
    CLLocationController *CLControllerSecondView;
    
    dbModel *model;
    NSString *pickerString;
    int pickerValue;
    int geoItemsCount;
    int categoriesCount;
    NSArray *categories;
    NSMutableArray *categoriesTitles;
    NSMutableArray *itemsData;
    NSMutableArray *selectedItem;
    BOOL tableViewIsOnTop;
    BOOL withinDetailsMapIsOnTop;
    BOOL editingTable;
}

@property (nonatomic, readwrite) int pickerValue, geoItemsCount, categoriesCount;
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSMutableArray *categoriesTitles, *itemsData, *selectedItem;
@property (nonatomic, retain) UIView *detailsView, *theTableView, *detailsMapView, *detailsEditView;
@property (nonatomic, retain) UILabel *itemsCountLabel;
@property (nonatomic, retain) UIBarButtonItem *generalEditButton, *backToList;
@property (nonatomic, retain) UITextField *editItemLabel;
@property (nonatomic, retain) UIButton *editSaveItem;
@property (nonatomic, retain) UITableView *itemsTable;
@property (nonatomic, retain) MKMapView *detailMap;
@property (nonatomic, retain) UIPickerView *editCategoriesPicker;
@property (nonatomic, retain) CLLocationController *CLControllerSecondView;
@property (nonatomic, retain) dbModel *model;

-(IBAction)saveEditedItem;
-(IBAction)editButtonPressed;
-(IBAction)backToListButtonPressed;

@end
