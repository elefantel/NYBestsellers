//
//  NYBestsellerAPIConnectionController.h
//  Bestseller Archiver
//
//  Created by Mpendulo Ndlovu on 2016/03/05.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface NYBestsellerAPIConnectionController : NSObject
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void) updateDatabaseInventoryForItemsCategory:(NSString *) category success:(void (^)(void))successBlock failure:(void (^)(NSError * error))failureBlock;
@end
