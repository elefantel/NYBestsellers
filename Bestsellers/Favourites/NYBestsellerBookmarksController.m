//
//  NYBestsellerBookmarksController.m
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/03/16.
//  Copyright © 2016 Comscie. All rights reserved.
//

#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import "NYBestsellerBookmarksController.h"
#import "NYBestsellerAPIConnectionController.h"
#include "Book.h"

@implementation NYBestsellerBookmarksController
{

}

- (NSArray *)bookmarkedBooks
{
    NSMutableArray *books = [[NSMutableArray alloc] init];
    NSMutableDictionary *booksDictionary = [[NSMutableDictionary alloc] init];
    booksDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarks"];
    
    if ([booksDictionary count] == 0)
    {
        return nil;
    }
    
    NSManagedObjectContext * context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    
    for (NSString *bookImageURL in [booksDictionary allKeys])
    {
        NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"imageUrl = %@", bookImageURL];
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        Book *book = [fetchedObjects firstObject];
        
        if (book)
        {
            [books addObject:book];
        }
    }
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(compare:)];
    return [books sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
