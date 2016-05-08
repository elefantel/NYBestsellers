//
//  DatabaseController.h
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/03/14.
//  Copyright © 2016 Comscie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "BookList.h"

@interface DatabaseController : NSObject
- (void)booksForCategory:(NSString *) category andDisplayName:(NSString *)displayName resultHandler:(void (^)(NSArray * books))resultHandler;

@end
