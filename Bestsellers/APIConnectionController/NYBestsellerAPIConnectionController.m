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

- (void)requestBooksDataForCategory:(NSString *)category success:(void (^)(void))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSDictionary *APIConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"APIConfig"];
    NSString *APIKey = [APIConfig objectForKey:@"APIKey"];
    NSString *APIBooksPath = [APIConfig objectForKey:@"APIBooksExtension"];
    NSString *requestPath = [[NSString alloc] initWithFormat:@"%@%@?&api-key=%@",APIBooksPath, category, APIKey];
    
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

- (void) requestBooksForCategory:(NSString *) category success:(void (^)(void))successBlock failure:(void (^)(NSError * error))failureBlock
{
    [self requestBooksDataForCategory:category
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
