//
//  BestsellersTests.m
//  BestsellersTests
//
//  Created by Mpendulo Ndlovu on 2016/03/09.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BestsellersTests : XCTestCase

@end

@implementation BestsellersTests

- (void)setUp
{
    [super setUp];
    
    NSMutableDictionary *APIConfig;
    APIConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"APIConfig"];
    
    if (APIConfig == nil)
    {
        APIConfig = [[NSMutableDictionary alloc] init];
        [APIConfig setObject: @"http://api.nytimes.com" forKey:@"APIBaseURL"];
        [APIConfig setObject: @"ab68052fb3ea20655df09719804424c8:16:74623694" forKey:@"APIKey"];
        [APIConfig setObject: @"/svc/books/v3/lists/" forKey:@"APIBooksExtension"];
        [[NSUserDefaults standardUserDefaults] setObject:APIConfig forKey:@"APIConfig"];
    }
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAPIBaseURLWorks
{
   NSMutableDictionary *APIConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"APIConfig"];
   XCTAssert([[APIConfig objectForKey:@"APIBaseURL"] isEqualToString:@"http://api.nytimes.com"]);
}

- (void) testAPIKeyisValid
{
    NSMutableDictionary *APIConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"APIConfig"];
   XCTAssert([[APIConfig objectForKey:@"APIKey"] isEqualToString:@"ab68052fb3ea20655df09719804424c8:16:74623694"]);
}

- (void)testClientCanConnectToAPI
{
    NSMutableDictionary * APIConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"APIConfig"];
    NSString *baseURL = [APIConfig objectForKey:@"APIBaseURL"];
    NSString *booksExtension = [APIConfig objectForKey:@"APIBooksExtension"];
    NSString *APIKey = [APIConfig objectForKey:@"APIKey"];
    NSString *booksCategory = @"business-books";
    NSString *requestPath = [[NSString alloc] initWithFormat:@"%@%@%@?&api-key=%@",baseURL,booksExtension, booksCategory, APIKey];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:requestPath]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
    XCTAssert(error == nil);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
