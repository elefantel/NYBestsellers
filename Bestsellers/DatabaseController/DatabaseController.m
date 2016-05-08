//
//  DatabaseController.m
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/03/14.
//  Copyright © 2016 Comscie. All rights reserved.
//

#import "DatabaseController.h"
#import "NYBestsellerAPIConnectionController.h"

@implementation DatabaseController
{
    NYBestsellerAPIConnectionController *_connectionController;
}

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        _connectionController = [NYBestsellerAPIConnectionController new];
    }
    return self;
}

- (NSArray *)fetchFromDatabaseBooksForDisplayName:(NSString *) displayName
{
    NSManagedObjectContext * context = _connectionController.managedObjectContext;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BookList"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"displayName = %@", displayName];

    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    BookList * bookList = [fetchedObjects firstObject];
    NSArray * books = [[NSArray alloc] initWithArray:[[bookList books] allObjects]];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES selector:@selector(compare:)];
    return [books sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

-(void) persistBooksForCategory:(NSString *)category success:(void (^)(void))successBlock failure:(void (^)(NSError * error))failureBlock
{
    [_connectionController requestBooksForCategory:category
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

- (void)booksForCategory:(NSString *) category andDisplayName:(NSString *)displayName resultHandler:(void (^)(NSArray * books))resultHandler
{
    [self persistBooksForCategory:category
    success:^
    {
        resultHandler([self fetchFromDatabaseBooksForDisplayName:displayName]);
    }
     failure:^(NSError * error)
     {
        resultHandler([self fetchFromDatabaseBooksForDisplayName:displayName]);
     }];
}

@end
