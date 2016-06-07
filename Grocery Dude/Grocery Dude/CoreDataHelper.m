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
- (NSString *)applicationDocumentDirectory {
    
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
}

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

@end
