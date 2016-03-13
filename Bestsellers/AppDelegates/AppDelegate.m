//
//  AppDelegate.m
//  Bestseller Archiver
//
//  Created by Mpendulo Ndlovu on 2016/03/04.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import "AppDelegate.h"
#import "ReachabilityViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    __strong ReachabilityViewController* _reachabilityViewController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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

    _reachabilityViewController = [[ReachabilityViewController alloc] init];
    [_reachabilityViewController registerForReachabilityChanges];
    return YES;
}
@end
