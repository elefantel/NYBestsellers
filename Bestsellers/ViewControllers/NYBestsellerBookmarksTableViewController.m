//
//  NYBestsellerBookmarksTableViewController.m
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/03/17.
//  Copyright © 2016 Comscie. All rights reserved.
//

#import "NYBestsellerBookmarksTableViewController.h"
#include "NYBestsellerBookmarksController.h"
#include "NYBestsellerBookProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#include "Book.h"

@interface NYBestsellerBookmarksTableViewController ()

@end

@implementation NYBestsellerBookmarksTableViewController
{
    NYBestsellerBookmarksController *_bookBookmarksController;
    NSArray *_bookmarkedBooks;
    __weak IBOutlet UIView *_bookmarkInfoUIView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _bookBookmarksController = [[NYBestsellerBookmarksController alloc] init];
    _bookmarkedBooks = [_bookBookmarksController bookmarkedBooks];
    
    if ([_bookmarkedBooks count] == 0)
    {
        _bookmarkInfoUIView.hidden = FALSE;
    }
    else
    {
         _bookmarkInfoUIView.hidden = TRUE;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_bookmarkedBooks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarksCellIdentifier" forIndexPath:indexPath];
    
     if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"bookmarksCellIdentifier"];
    }
    
    Book * book = [_bookmarkedBooks objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"%d. %@", @"Book Title"), indexPath.row + 1, book.title];
    cell.detailTextLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"%@", @"Book Author"), book.author];
    
    NSString * cachedImageURL = [NSString stringWithFormat:(@"%@+%ld.png"),book.imageUrl,(long)indexPath.row];
    
    if (cell.imageView.image == nil)
    {
        cell.imageView.image = [UIImage imageWithData:nil];
    }
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:book.imageUrl]
                 placeholderImage:[UIImage imageNamed:cachedImageURL]
                          options:SDWebImageRefreshCached];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"bookmarksToProfile"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Book * book = [_bookmarkedBooks objectAtIndex:indexPath.row];
        NYBestsellerBookProfileViewController * bookProfileViewController = [segue destinationViewController];
        bookProfileViewController.book = book;
        [bookProfileViewController setHidesBottomBarWhenPushed:YES];
    }
}

@end
