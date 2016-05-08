//
//  NYBestsellerBookSearchController.h
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/03/19.
//  Copyright © 2016 Comscie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NYBestsellerBookSearchController : NSObject
+ (NSArray *)booksMatchingSearchForText:(NSString *)searchText;
@end
