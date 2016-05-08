//
//  LoadingViewController.m
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/03/10.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import "LoadingViewController.h"

static LoadingViewController *__LoadingViewController;
@interface LoadingViewController ()
@end

@implementation LoadingViewController
{
    __weak IBOutlet UIActivityIndicatorView *_loadingIndicator;
    __weak IBOutlet UILabel *_loadingTextLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_loadingIndicator startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    [_loadingIndicator stopAnimating];
}

+ (void) displayLoadingView
{
    UIWindow* mainWindow;
    mainWindow = [UIApplication sharedApplication].delegate.window;
    __LoadingViewController = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    CGRect rect = CGRectMake(mainWindow.bounds.size.width/2.0, mainWindow.bounds.size.height/2.0, 20,20);
    __LoadingViewController.view.frame = rect;
    [mainWindow addSubview:__LoadingViewController.view];
    __LoadingViewController.view.alpha = 0.5;
}

+ (void) removeLoadingView
{
    [UIView animateWithDuration:0.35 animations:^
        {
        __LoadingViewController.view.alpha = 0;
        }
    completion:^(BOOL finished)
        {
        if(finished)
            {
            [__LoadingViewController.view removeFromSuperview];
            }
        }];
}

@end
