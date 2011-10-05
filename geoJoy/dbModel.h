//
//  dbModel.h
//  geoJoy
//
//  Created by Jakob Hans Renpening on 24/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "CLLocationController.h"

@interface dbModel : NSObject

-(id)initAndCreateDatabaseIfNeeded;
-(int)getNumberOfItemsInTable;
-(BOOL)addNewItemWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude category:(NSString *)category;
-(int)getCategoriesNumber:(NSArray *)categories;
-(int)getItemsCountByCategory:(NSString *)category;
-(BOOL)deleteItemWithID:(NSNumber *)ID;
-(BOOL)updateItemWithID:(NSNumber *)ID toName:(NSString *)name andCategory:(NSString *)category;
-(NSMutableArray *)getAllItemsByCategory:(NSString*)category;

@end
