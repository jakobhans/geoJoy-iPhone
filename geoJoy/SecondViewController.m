//
//  SecondViewController.m
//  geoJoy
//
//  Created by Jakob Hans Renpening on 22/08/11.
//  Copyright 2011 Claim Soluciones, S.C.P. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

@synthesize detailsView, theTableView, detailsEditView, detailsMapView;
@synthesize itemsCountLabel;
@synthesize generalEditButton, backToList;
@synthesize editItemLabel;
@synthesize editSaveItem;
@synthesize itemsTable;
@synthesize detailMap;
@synthesize editCategoriesPicker;
@synthesize CLControllerSecondView;

-(void)textFieldFinished:(id)sender {
    [sender resignFirstResponder];
}

-(void)setEditItemValues {
    editItemLabel.text = [selectedItem objectAtIndex:1];
    NSInteger categoryIndex = [categories indexOfObject:[selectedItem objectAtIndex:2]];
    [editCategoriesPicker selectRow:categoryIndex inComponent:0 animated:NO];
    pickerString = [selectedItem objectAtIndex:2];
    pickerValue = categoryIndex;
}

-(void)toggleWithinDetailsMapWithEdit {
    if (withinDetailsMapIsOnTop == NO) {
        withinDetailsMapIsOnTop = YES;
        
        [UIView beginAnimations:nil context:detailsView];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:detailsView cache:YES];
        [detailsView bringSubviewToFront:detailsMapView];
        [UIView commitAnimations];
        
        [CLControllerSecondView.locMgr startUpdatingLocation];
        
        generalEditButton.title = @"Edit";
    } else {
        withinDetailsMapIsOnTop = NO;
        
        [UIView beginAnimations:nil context:detailsView];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:detailsView cache:YES];
        [detailsView bringSubviewToFront:detailsEditView];
        [UIView commitAnimations];
        
        [CLControllerSecondView.locMgr stopUpdatingLocation];
        
        generalEditButton.title = @"Cancel";
    }
}

-(void)toggleTableWithDetails {
    if (tableViewIsOnTop == NO) {
        
        backToList.enabled = NO;
        tableViewIsOnTop = YES;
        
        [UIView beginAnimations:nil context:self.view];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [self.view bringSubviewToFront:theTableView];
        [UIView commitAnimations];
        
        if (withinDetailsMapIsOnTop == NO) {
            [self toggleWithinDetailsMapWithEdit];
        }
        
        [CLControllerSecondView.locMgr stopUpdatingLocation];
        
    } else {
        backToList.enabled = YES;
        tableViewIsOnTop = NO;
        
        [UIView beginAnimations:nil context:self.view];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [self.view bringSubviewToFront:detailsView];
        [UIView commitAnimations];
        
        [CLControllerSecondView.locMgr startUpdatingLocation];
    }
}

-(void)editTableItems {    
    [self setEditing:YES animated:YES];
}

-(void)loadTableData {
    // Getting Categories Count
    categoriesCount = [[dbModel alloc]getCategoriesNumber:categories];
    
    // Getting Categories Titles that have at least one item each
    categoriesTitles = [[NSMutableArray arrayWithCapacity:categoriesCount] retain];
    for (NSString *category in categories) {
        int categoryCount = [[dbModel alloc] getItemsCountByCategory:category];
        if (categoryCount > 0) {
            [categoriesTitles addObject:category];
        }
    }
    
    // Getting item's data by Category
    itemsData = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *sectionData = [[NSMutableArray alloc] init];
    for (NSString *category in categoriesTitles) {
        sectionData = [NSMutableArray arrayWithArray:[[dbModel alloc] getAllItemsByCategory:category]];
        [itemsData addObject:sectionData];
    }
    [itemsData retain];
}

-(void)reloadItemsCounter {
    geoItemsCount = [[dbModel alloc] getNumberOfItemsInTable];
    NSString *labelMessage;
    if (geoItemsCount == 0) {
        itemsTable.hidden = YES;
        labelMessage = [[NSString alloc]initWithString:@"No items saved"];
        generalEditButton.enabled = NO;
    } else {
        [self loadTableData];
        itemsTable.hidden = NO;
        if (geoItemsCount == 1) {
            labelMessage = [[NSString alloc]initWithString:@"1 item"];
        } else {
            labelMessage = [[NSString alloc]initWithFormat:@"%i items", geoItemsCount];
        }
        generalEditButton.enabled = YES;
    }
    itemsCountLabel.text = labelMessage;
    [labelMessage release];
}

-(IBAction)saveEditedItem {
    BOOL itemUpdateDB = [[dbModel alloc] updateItemWithID:[selectedItem objectAtIndex:0] toName:editItemLabel.text andCategory:pickerString];
    if (itemUpdateDB == YES) {
        [self loadTableData];
        [itemsTable reloadData];
        [self toggleWithinDetailsMapWithEdit];
        [self toggleTableWithDetails];
    }
}

-(IBAction)editButtonPressed {
    if (tableViewIsOnTop == YES) {
        if (editingTable == NO) {
            [self editTableItems];
        } else {
            [self setEditing:NO animated:YES];
        }
    } else {
        [self setEditItemValues];
        [self toggleWithinDetailsMapWithEdit];
    }
}

-(IBAction)backToListButtonPressed {
    [self toggleTableWithDetails];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [categories count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [categories objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    pickerString = [categories objectAtIndex:row];
    pickerValue = row;
}

// Start Map Stuff

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pinDrop = (MKPinAnnotationView *)[detailMap dequeueReusableAnnotationViewWithIdentifier:@"currentItem"];
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKPinAnnotationView *userLocation = (MKPinAnnotationView *)[detailMap dequeueReusableAnnotationViewWithIdentifier:@"userLocationForItem"];
        return userLocation;
    }
    
    pinDrop = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentItem"] autorelease];
    pinDrop.pinColor = MKPinAnnotationColorPurple;
    pinDrop.canShowCallout = YES;
    pinDrop.animatesDrop = YES;
    
    return pinDrop;
}

// End Map Stuff

-(void)loadItemsDataInDetails {
    
    NSMutableArray *presentAnnotations = [NSMutableArray arrayWithArray:[detailMap annotations]];
    for (MKPinAnnotationView *annotation in presentAnnotations) {
        if ([annotation isKindOfClass:[MKUserLocation class]]) {
            [presentAnnotations removeObject:annotation];
        }
    }
    
    [detailMap removeAnnotations:presentAnnotations];
    
    [self toggleTableWithDetails];
    
    MKCoordinateRegion mapRegion;
    annotationsController *itemLocationPin = [[annotationsController alloc] retain];
    CLLocationCoordinate2D itemCoordinates;
    
    itemCoordinates.latitude = (CLLocationDegrees)[[selectedItem objectAtIndex:3] doubleValue];
    itemCoordinates.longitude = (CLLocationDegrees)[[selectedItem objectAtIndex:4] doubleValue];
    
    mapRegion.center = itemCoordinates;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    
    [detailMap setRegion:mapRegion];
    
    [itemLocationPin initWithTitle:[selectedItem objectAtIndex:1] subtitle:[selectedItem objectAtIndex:2] coordinate:itemCoordinates];
    
    [detailMap addAnnotation:itemLocationPin];
}

// Table Stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [itemsData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[itemsData objectAtIndex:section] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [categoriesTitles objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
     }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[cell textLabel] setText:[[[itemsData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedItem = [[NSMutableArray alloc] initWithArray:[[itemsData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    [self loadItemsDataInDetails];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        
        NSNumber *itemID = [[[itemsData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:0];
        BOOL querySuccess = [[dbModel alloc] deleteItemWithID:itemID];
        if (querySuccess == YES) {
            [[itemsData objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            if ([[itemsData objectAtIndex:indexPath.section] count] == 0) {
                [categoriesTitles removeObjectAtIndex:indexPath.section];
                [itemsData removeObjectAtIndex:indexPath.section];
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
            [self reloadItemsCounter];
        } else {
            NSLog(@"There has been a problem while deleting an item.");
        }
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [itemsTable setEditing:editing animated:animated];
    
    if (editing == NO) {
        editingTable = NO;
        generalEditButton.title = @"Edit";
    } else if (editing == YES) {
        editingTable = YES;
        [generalEditButton setTitle:@"Cancel"];
    }
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (geoItemsCount == 0) {
        [self setEditing:NO animated:NO];
    }
}

// End Table Stuff

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated {
    [self reloadItemsCounter];
    
    UIView *tableBottomSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    itemsTable.tableFooterView = tableBottomSpace;
    
    [itemsTable reloadData];
    
    [CLControllerSecondView.locMgr startUpdatingLocation];
    
    if (withinDetailsMapIsOnTop == NO) {
        [self toggleWithinDetailsMapWithEdit];
    }
    
    if (tableViewIsOnTop == NO) {
        [self toggleTableWithDetails];
    }
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [CLControllerSecondView.locMgr stopUpdatingLocation];
    [super viewWillDisappear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    tableViewIsOnTop = YES;
    withinDetailsMapIsOnTop = YES;
    editingTable = NO;
    
    CLControllerSecondView = [[CLLocationController alloc] init];
    CLControllerSecondView.delegate = self;
    
    backToList.enabled = NO;
    
    categories = [[NSArray alloc] initWithObjects:@"Arts & Crafts", @"Education", @"Entertainment", @"Family", @"Food", @"Friends", @"Landscape & View", @"Museum", @"Party", @"Professional", @"Shopping", @"Technology", @"Other", nil];
    
    [self.editItemLabel setReturnKeyType:UIReturnKeyDone];
    [self.editItemLabel addTarget:self
                           action:@selector(textFieldFinished:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [CLControllerSecondView.locMgr stopUpdatingLocation];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)dealloc {
    [detailsView release];
    [detailsMapView release];
    [detailsEditView release];
    [theTableView release];
    [generalEditButton release];
    [backToList release];
    [editItemLabel release];
    [editSaveItem release];
    [categories release];
    [itemsCountLabel release];
    [itemsTable release];
    [detailMap release];
    [editCategoriesPicker release];
    [CLControllerSecondView release];
    [super dealloc];
}

@end
