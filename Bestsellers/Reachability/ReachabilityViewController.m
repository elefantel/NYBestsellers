//
//  ReachabilityViewController.m
//  Bestseller Archiver
//
//  Created by Mpendulo Ndlovu on 2016/03/08.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import "ReachabilityViewController.h"
#import "Reachability.h"

@interface ReachabilityViewController ()

@property (nonatomic) Reachability* hostReachability;
@property (nonatomic) Reachability* internetReachability;
@property (nonatomic) Reachability* wifiReachability;
@property (nonatomic) BOOL isReachable;
@property (nonatomic) BOOL previousReachability;
@end

@implementation ReachabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) registerForReachabilityChanges
{
    self.isReachable = NO;
    self.previousReachability = YES;
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, (reachabilityChanged:) will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    //Uses www.google.com as the test host name for server to monitored for reachability.
    NSString *remoteHostName = @"www.google.com";
    
	self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];
    [self updateClientReachabilityStatus:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
	[self.wifiReachability startNotifier];
    
	
    
    //only update user if there is still no Reachability
    if (!self.isReachable)
    {
        [self updateClientReachabilityStatus:self.internetReachability];
    }
    
    if (!self.isReachable)
    {
        [self updateClientReachabilityStatus:self.wifiReachability];
    }
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)notification
{
	Reachability* currentReachability = [notification object];
	NSParameterAssert([currentReachability isKindOfClass:[Reachability class]]);
    
	[self updateClientReachabilityStatus:currentReachability];
}

/*!
 * Checks for Reachability status.
 */
- (void)updateClientReachabilityStatus:(Reachability *)reachability
{
    if (reachability == self.hostReachability
        ||reachability == self.internetReachability
        ||reachability == self.wifiReachability)
	{
        [self displayReachabilityChange:reachability];
    }
}

/*!
 * Alerts user whenever Reachability status changes.
 */
- (void)displayReachabilityChange:(Reachability *)reachability
{
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    NSString* connectivityStatusMessage = @"";
    
    switch (networkStatus)
    {
        case NotReachable:
        {
            self.isReachable = NO;
            connectivityStatusMessage = NSLocalizedString(@"Internet Not Reachable", @"Internet access is not available message");
            break;
        }

        case ReachableViaWWAN:
        {
            self.isReachable = YES;
            connectivityStatusMessage = NSLocalizedString(@"Internet Reachable via WWAN", @"WWAN Internet access message");
            break;
        }
        case ReachableViaWiFi:
        {
            self.isReachable = YES;
            connectivityStatusMessage= NSLocalizedString(@"Internet Reachable via WiFi", @"WiFi Internet access message");
            break;
        }
        default:
        {
            self.isReachable = NO;
            break;
        }
    }
    
    if (self.previousReachability == self.isReachable)
    {
        return;
    }
    
    self.previousReachability = self.isReachable;
    
    UIAlertView* connectivityAlertView;
    NSString* connectivityAlertTitle;
    NSString* dismissOption = NSLocalizedString(@"OK", @"Internet connection status change acknowledgement");
    
    connectivityAlertTitle = NSLocalizedString(@"Network Status", @"Header for network status alert");
    connectivityAlertView = [[UIAlertView alloc] initWithTitle:connectivityAlertTitle message:connectivityStatusMessage delegate:self cancelButtonTitle:dismissOption otherButtonTitles:nil, nil];
    [connectivityAlertView show];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
