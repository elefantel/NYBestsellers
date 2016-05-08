//
//  NYBestsellerBookSearchController.m
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/03/19.
//  Copyright © 2016 Comscie. All rights reserved.
//

#import "NYBestsellerBookSearchController.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

@implementation NYBestsellerBookSearchController

+ (NSArray *)booksMatchingSearchForText:(NSString *)searchText
{
    NSArray *books;
    
    if ([searchText length] > 0)
    {
    NSManagedObjectContext * context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@ OR author contains[cd] %@ OR bookDescription contains[cd] %@", searchText, searchText, searchText];

    NSError *error = nil;
    books = [context executeFetchRequest:fetchRequest error:&error];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(compare:)];
    
    return [books sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    return books;
}


@end
