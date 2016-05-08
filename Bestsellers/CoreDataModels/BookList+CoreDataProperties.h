//
//  BookList+CoreDataProperties.h
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/03/09.
//  Copyright © 2016 Elefantel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BookList.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *bestsellersDate;
@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSString *listName;
@property (nullable, nonatomic, retain) NSNumber *normalListEndsAt;
@property (nullable, nonatomic, retain) NSDate *publishedDate;
@property (nullable, nonatomic, retain) NSString *updated;
@property (nullable, nonatomic, retain) NSSet<Book *> *books;

@end

@interface BookList (CoreDataGeneratedAccessors)

- (void)addBooksObject:(Book *)value;
- (void)removeBooksObject:(Book *)value;
- (void)addBooks:(NSSet<Book *> *)values;
- (void)removeBooks:(NSSet<Book *> *)values;

@end

NS_ASSUME_NONNULL_END
