//
//  NYBestsellerAPIConnectionController.m
//  Bestseller Archiver
//
//  Created by Mpendulo Ndlovu on 2016/03/05.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import "NYBestsellerAPIConnectionController.h"
#import "Book.h"
#import "BookList.h"

@interface NYBestsellerAPIConnectionController()
@property(nonatomic, strong) NSString *categoryListName;
@end

@implementation NYBestsellerAPIConnectionController

- (NSManagedObjectContext *) managedObjectContext
{
    return [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
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

- (void)requestDataForItemsCategory:(NSString *) category success:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSDictionary *APIConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"APIConfig"];
    NSString *APIKey = [APIConfig objectForKey:@"APIKey"];
    NSString *APIBooksPath = [APIConfig objectForKey:@"APIBooksExtension"];
    NSString *APIBaseURL = [APIConfig objectForKey:@"APIBaseURL"];
    NSString *requestPath = [[NSString alloc] initWithFormat:@"%@%@?&api-key=%@",APIBooksPath, category, APIKey];
    NSLog(@"requestPath: %@",requestPath);
    
    [self setupLocalClientDatabaseForAPI:[NSURL URLWithString:APIBaseURL]];
    
	[[RKObjectManager sharedManager]
     		getObjectsAtPath:requestPath
		      parameters:nil
        		 success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
                            {
                            //HTTP status 200:OK
                            RKLogInfo(@"Loading data from API successful.");
                            successBlock();
                        	}
        		  failure: ^(RKObjectRequestOperation *operation, NSError *error)
                            {
                            //Log interpretation/description of HTTP error codes
                            RKLogError(@"Loading from API failed. %@", error.localizedDescription);
                            failureBlock(error);
                        	}
     ];
}

- (void) updateDatabaseInventoryForItemsCategory:(NSString *) category success:(void (^)(void))successBlock failure:(void (^)(NSError * error))failureBlock
{
    [self requestDataForItemsCategory:category
        success:^()
        {
            successBlock();
        }
        failure:^(NSError * error)
        {
            failureBlock(error);
        }
        ];
}


@end
