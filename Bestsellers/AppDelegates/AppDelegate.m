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
    NSMutableDictionary * apiKeyData;
    apiKeyData = [[NSUserDefaults standardUserDefaults] objectForKey:@"apiKeyData"];

    if (apiKeyData == nil)
        {
        apiKeyData = [[NSMutableDictionary alloc] init];
        //store to NSUserDefaults the NYT API key required to access their data
        [apiKeyData setObject: @"ab68052fb3ea20655df09719804424c8:16:74623694" forKey:@"apiKeyData"];
        [[NSUserDefaults standardUserDefaults] setObject:apiKeyData forKey:@"apiKeyData"];
        }

    _reachabilityViewController = [[ReachabilityViewController alloc] init];
    [_reachabilityViewController registerForReachabilityChanges];
    return YES;
}
@end
