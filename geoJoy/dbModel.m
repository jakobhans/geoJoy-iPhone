//
//  dbModel.m
//  geoJoy
//
//  Created by Jakob Hans Renpening on 24/09/11.
//  Copyright 2011 Claim Soluciones, S.C.P. All rights reserved.
//

#import "dbModel.h"

@implementation dbModel

-(id)initAndCreateDatabaseIfNeeded {
    self = [super init];
    if (self) {
        self = [super init];
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"geojoy.sqlite"];
        
        success = [fileManager fileExistsAtPath:writableDBPath];
        
        if (!success) {
            NSLog(@"Creating editable copy of database");
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"geojoy.sqlite"];
            success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
            if (!success) {
                NSAssert1(0, @"Failed to create writable database file with message '@%'.", [error localizedDescription]);
            } else {
                NSLog(@"Database copied correctly to user's Documents path.");
            }
        } else {
            return self;
        }
    }
    return self;
}

-(sqlite3 *)getNewDBConnection {
    sqlite3 *dbPointer;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"geojoy.sqlite"];
    
    if (sqlite3_open([path UTF8String], &dbPointer) != SQLITE_OK) {
        NSLog(@"Error in opening database");
    }
    return dbPointer;
}

-(int)getNumberOfItemsInTable {
    sqlite3 *dbPointer = [self getNewDBConnection];
    sqlite3_stmt *statement = nil;
    int result = 0;
    const char *query_stmt = "SELECT COUNT (*) FROM locationItems";
    
    if (sqlite3_prepare_v2(dbPointer, query_stmt, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error preparing statement /getNumberOfItemsInTable/ %s", sqlite3_errmsg(dbPointer));
    } else {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            result = sqlite3_column_int(statement,0);
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dbPointer);
    
    return result;
}

-(int)getLastIDNumber {
    sqlite3 *dbPointer = [self getNewDBConnection];
    sqlite3_stmt *statement = nil;
    int result = 0;
    const char *query_stmt = "SELECT id FROM locationItems";
    
    if (sqlite3_prepare_v2(dbPointer, query_stmt, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error preparing statement /getLastIDNumber/ %s", sqlite3_errmsg(dbPointer));
    } else {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            result = sqlite3_column_int(statement, 0);
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dbPointer);
    
    return result;
}

-(BOOL)addNewItemWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude category:(NSString *)category {
    sqlite3 *dbPointer = [self getNewDBConnection];
    sqlite3_stmt *statement = nil;
    int new_item_id = [self getLastIDNumber] + 1;
    BOOL success;
    NSString *sql_query = [NSString stringWithFormat:@"INSERT INTO locationItems (id, label, category, latitude, longitude, creationDate) VALUES('%i', '%s', '%s', '%f', '%f', DATETIME('now'))", new_item_id, [name UTF8String], [category UTF8String], latitude, longitude];
    const char *query_stmt = [sql_query UTF8String];
    
    if (sqlite3_prepare_v2(dbPointer, query_stmt, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error preparing statement /addNewItem/ %s", sqlite3_errmsg(dbPointer));
        success = NO;
    } else {
        if (sqlite3_step(statement)) {
            success = YES;
        } else {
            success = NO;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dbPointer);
    
    return success;
}

-(BOOL)updateItemWithID:(NSNumber *)ID toName:(NSString *)name andCategory:(NSString *)category {
    sqlite3 *dbPointer = [self getNewDBConnection];
    sqlite3_stmt *statement = nil;
    BOOL success;
    NSString *sql_query = [NSString stringWithFormat:@"UPDATE locationItems SET label='%s', category='%s' WHERE id='%i'", [name UTF8String], [category UTF8String], [ID intValue]];
    const char *query_stmt = [sql_query UTF8String];
    
    if (sqlite3_prepare_v2(dbPointer, query_stmt, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error preparing statement /addNewItem/ %s", sqlite3_errmsg(dbPointer));
        success = NO;
    } else {
        if (sqlite3_step(statement)) {
            success = YES;
        } else {
            success = NO;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dbPointer);
    
    return success;
}

-(int)getCategoriesNumber:(NSArray *)categories {
    sqlite3 *dbPointer = [self getNewDBConnection];
    int indCounter = 0;
    int catsCounter = 0;
    for (NSString *category in categories) {
        sqlite3_stmt *statement = nil;
        NSString *sql_query = [NSString stringWithFormat:@"SELECT id FROM locationItems WHERE category='%@'", category];
        const char *query_stmt = [sql_query UTF8String];
        
        if (sqlite3_prepare_v2(dbPointer, query_stmt, -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"Error preparing statement /getLastIDNumber/ %s", sqlite3_errmsg(dbPointer));
        } else {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                indCounter++;
            }
        }
        sqlite3_finalize(statement);
        
        if (indCounter > 0) {
            catsCounter++;
            indCounter = 0;
        }
    }
    
    sqlite3_close(dbPointer);
    
    return catsCounter;
}

-(int)getItemsCountByCategory:(NSString *)category {
    sqlite3 *dbPointer = [self getNewDBConnection];
    int indCounter = 0;
    sqlite3_stmt *statement = nil;
    NSString *sql_query = [NSString stringWithFormat:@"SELECT id FROM locationItems WHERE category='%@'", category];
    const char *query_stmt = [sql_query UTF8String];
    
    if (sqlite3_prepare_v2(dbPointer, query_stmt, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error preparing statement /getLastIDNumber/ %s", sqlite3_errmsg(dbPointer));
    } else {
        while(sqlite3_step(statement) == SQLITE_ROW) {
            if (sqlite3_column_int(statement, 0) > 0) {
                indCounter++;
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dbPointer);
    
    return indCounter;
}

-(NSMutableArray *)getAllItemsByCategory:(NSString*)category {
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    NSNumber *itemID;
    NSString *itemLabel;
    NSString *itemCategory;
    NSNumber *itemLatitude;
    NSNumber *itemLongitude;
    NSString *itemDate;
    sqlite3 *dbPointer = [self getNewDBConnection];
    sqlite3_stmt *statement = nil;
    
    NSString *sql_query = [NSString stringWithFormat:@"SELECT * FROM locationItems WHERE category='%@'", category];
    const char *query_stmt = [sql_query UTF8String];
    
    if (sqlite3_prepare_v2(dbPointer, query_stmt, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error preparing statement /getLastIDNumber/ %s", sqlite3_errmsg(dbPointer));
        [categoryArray release];
        return nil;
    } else {
        while(sqlite3_step(statement) == SQLITE_ROW) {
            itemID = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            itemLabel = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
            itemCategory = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
            itemLatitude = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement, 3)];
            itemLongitude = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement, 4)];
            itemDate = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
            
            [categoryArray addObject:[NSMutableArray arrayWithObjects:itemID, itemLabel, itemCategory, itemLatitude, itemLongitude, itemDate, nil]];
        }
        sqlite3_finalize(statement);
        sqlite3_close(dbPointer);
        dbPointer = nil;
        return categoryArray;
    }
}

-(BOOL)deleteItemWithID:(NSNumber *)ID {
    sqlite3 *dbPointer = [self getNewDBConnection];
    sqlite3_stmt *statement = nil;
    BOOL success;
    NSString *sql_query = [NSString stringWithFormat:@"DELETE FROM locationItems WHERE id='%i'", [ID intValue]];
    const char *query_stmt = [sql_query UTF8String];
    if (sqlite3_prepare_v2(dbPointer, query_stmt, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error preparing statement /addNewItem/ %s", sqlite3_errmsg(dbPointer));
        success = NO;
    } else {
        if (sqlite3_step(statement)) {
            success = YES;
        } else {
            success = NO;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dbPointer);
    
    return success; 
}

-(void)dealloc {
    [super dealloc];
}

@end