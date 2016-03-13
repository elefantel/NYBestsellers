//
//  Book+CoreDataProperties.h
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/03/09.
//  Copyright © 2016 Elefantel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *bookDescription;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *primaryIsbn10;
@property (nullable, nonatomic, retain) NSString *primaryIsbn13;
@property (nullable, nonatomic, retain) NSString *productUrl;
@property (nullable, nonatomic, retain) NSString *publisher;
@property (nullable, nonatomic, retain) NSNumber *rankLastWeek;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *weeksOnList;
@property (nullable, nonatomic, retain) NSNumber *rank;
@property (nullable, nonatomic, retain) NSString *contributor;

@end

NS_ASSUME_NONNULL_END
