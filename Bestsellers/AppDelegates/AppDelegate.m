//
//  AppDelegate.m
//  Bestseller Archiver
//
//  Created by Mpendulo Ndlovu on 2016/03/04.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import "AppDelegate.h"
#import "ReachabilityViewController.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    __strong ReachabilityViewController* _reachabilityViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xD5E5EB)];
    [[UITabBar appearance] setTintColor:UIColorFromRGB(0x77C6E0)];
    [[UINavigationBar appearance] setTranslucent:YES];
    
    NSMutableDictionary *APIConfig;
    NSMutableDictionary *bookmarks;
    APIConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"APIConfig"];
    bookmarks = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarks"];
    
    if (APIConfig == nil)
    {
        APIConfig = [[NSMutableDictionary alloc] init];
        [APIConfig setObject: @"http://api.nytimes.com" forKey:@"APIBaseURL"];
        [APIConfig setObject: @"ab68052fb3ea20655df09719804424c8:16:74623694" forKey:@"APIKey"];
        [APIConfig setObject: @"/svc/books/v3/lists/" forKey:@"APIBooksExtension"];
        [[NSUserDefaults standardUserDefaults] setObject:APIConfig forKey:@"APIConfig"];
    }
    
    if (bookmarks == nil)
    {
        bookmarks = [[NSMutableDictionary alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:@"bookmarks"];
    }

    [self setupLocalClientDatabaseForAPI:[NSURL URLWithString:[APIConfig objectForKey:@"APIBaseURL"]]];
    _reachabilityViewController = [[ReachabilityViewController alloc] init];
    [_reachabilityViewController registerForReachabilityChanges];
    return YES;
}

- (void) setupEntityMappingForObjectStore: (RKManagedObjectStore *) managedObjectStore withObjectManager: (RKObjectManager *) objectManager
{
    RKEntityMapping * bookListMapping = [RKEntityMapping mappingForEntityForName:@"BookList" inManagedObjectStore:managedObjectStore];
    bookListMapping.identificationAttributes = @[@"displayName"];
    [bookListMapping addAttributeMappingsFromDictionary:
                    @{@"results.list_name": @"listName",
                    @"results.bestsellers_date": @"bestsellersDate",
                    @"results.published_date": @"publishedDate",
                    @"results.display_name": @"displayName",
                    @"results.normal_list_ends_at": @"normalListEndsAt",
                    @"results.updated": @"updated"
                    }];

    RKEntityMapping * bookMapping = [RKEntityMapping mappingForEntityForName:@"Book" inManagedObjectStore:managedObjectStore];
    bookMapping.identificationAttributes = @[@"title"];
    [bookMapping addAttributeMappingsFromDictionary:
                @{@"rank": @"rank",
                @"rank_last_week": @"rankLastWeek",
                @"weeks_on_list": @"weeksOnList",
                @"primary_isbn10": @"primaryIsbn10",
                @"primary_isbn13": @"primaryIsbn13",
                @"amazon_product_url": @"productUrl",
                @"book_image": @"imageUrl",
                @"publisher": @"publisher",
                @"description": @"bookDescription",
                @"title": @"title",
                @"contributor": @"contributor",
                @"author": @"author",
                @"price": @"price"
                }];

    [bookListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"results.books" toKeyPath:@"books" withMapping:bookMapping]];

    RKResponseDescriptor * bookListResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:bookListMapping
                                             method:RKRequestMethodGET
                                        pathPattern:nil
                                            keyPath:nil
                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
    ];

    [objectManager addResponseDescriptor:bookListResponseDescriptor];
}

- (void) setupLocalClientDatabaseForAPI:(NSURL *)APIbaseURL
{
    // Initialize RestKit using API base address
    RKObjectManager * objectManager = [RKObjectManager managerWithBaseURL:APIbaseURL];
    
    // Initialize Core Data's managed object model from the bundle
    NSManagedObjectModel * managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // Initialize RestKit's managed object store
    RKManagedObjectStore * managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    // Complete Core Data stack initialization via RestKit
    [managedObjectStore createPersistentStoreCoordinator];
    NSString * persistentStorePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"BestsellersDB.sqlite"];
    NSError * error;
    
    if (!persistentStorePath)
    {
        RKLogError(@"Failed adding persistent store at path '%@': %@", persistentStorePath, error);
    }
    
    NSPersistentStore * persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:persistentStorePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
        
    // Create RestKit's managed object contexts
    [managedObjectStore createManagedObjectContexts];
     
    // Configure a managed object cache
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    [self setupEntityMappingForObjectStore:managedObjectStore withObjectManager:objectManager];
}
@end
