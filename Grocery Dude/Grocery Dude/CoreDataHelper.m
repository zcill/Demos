//
//  CoreDataHelper.m
//  Grocery Dude
//
//  Created by zlk_meitu on 16/6/6.
//  Copyright © 2016年 Tim Roadley. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

#define debug 1

#pragma mark - FILES
NSString *storeFilename = @"Grocery-Dude.sqlite";

#pragma mark - PATHS

// 返回沙盒的Document目录
- (NSString *)applicationDocumentDirectory {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
}

// 在Documents目录下新建Stores目录
- (NSURL *)applicationStoreDirectory {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentDirectory]] URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        
        if ([fileManager createDirectoryAtURL:storesDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error]) {
            if (debug == 1) {
                NSLog(@"Successfully created Stores directory");
            }
            
        } else {
                NSLog(@"Failed to create Stores directory");
        }
    }
    
    return storesDirectory;
    
}

// 返回数据库文件的path url
- (NSURL *)storeURL {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    return [[self applicationStoreDirectory] URLByAppendingPathComponent:storeFilename];
    
}

#pragma mark - SETUP

- (id)init {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    
    return self;
}


- (void)loadStore {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if (_store) {
        // 如果已经存在，就直接return
        return;
    }
    
    NSError *error = nil;
    
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:nil
                                                error:&error];
    if (!_store) {
        NSLog(@"Failed to Add store. Error: %@", error);
        abort();
    } else {
        if (debug == 1) {
            NSLog(@"Successfully added store: %@", _store);
        }
    }
    
}

- (void)setupCoreData {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    [self loadStore];
    
    
}

#pragma mark - SAVING

- (void)saveContext {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context SAVED changes to persistent store");
        } else {
            NSLog(@"Failed to save _context: %@", error);
        }
        
    } else {
        NSLog(@"SKIPPED _context save, there are no changes!");
    }
    
}

@end
