//
//  NYBestsellerAPIConnectionController.h
//  Bestseller Archiver
//
//  Created by Mpendulo Ndlovu on 2016/03/05.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

@interface NYBestsellerAPIConnectionController : NSObject
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void) requestBooksForCategory:(NSString *) category success:(void (^)(void))successBlock failure:(void (^)(NSError * error))failureBlock;
@end
