//
//  NYBestsellerRankingsTableViewController.m
//  Bestseller Archiver
//
//  Created by Mpendulo Ndlovu on 2016/03/04.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import "NYBestsellerRankingsTableViewController.h"
#import "Book.h"
#import "NYBestsellerBookProfileViewController.h"
#import "LoadingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DatabaseController.h"

@interface NYBestsellerRankingsTableViewController()
@property(nonatomic, strong) NSArray *books;
@end

@implementation NYBestsellerRankingsTableViewController
    {
    __weak IBOutlet UILabel *_sectionHeaderLabel;
    __strong DatabaseController *_databaseController;
    }

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sectionHeaderLabel.text = [self.displayName uppercaseString];
    _databaseController = [DatabaseController new];
    [LoadingViewController displayLoadingView];
    
    [_databaseController booksForCategory:self.category andDisplayName:self.displayName resultHandler:^(NSArray * books)
    {
        self.books = books;
        [self.tableView reloadData];
        [LoadingViewController removeLoadingView];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.books count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"bookCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"bookCellIdentifier"];
    }
    
    Book * book = [self.books objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"%d. %@", @"Book Title"), indexPath.row + 1, book.title];
    cell.detailTextLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"%@", @"Book Author"), book.author];
    if (cell.imageView.image == nil)
    {
        cell.imageView.image = [UIImage imageWithData:nil];
    }
    
    NSString * cachedImageURL = [NSString stringWithFormat:(@"%@+%ld.png"),book.imageUrl,(long)indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:book.imageUrl]
                 placeholderImage:[UIImage imageNamed:cachedImageURL]
                          options:SDWebImageRefreshCached];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"rankingsToProfile"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Book * book = [self.books objectAtIndex:indexPath.row];
        NYBestsellerBookProfileViewController * bookProfileViewController = [segue destinationViewController];
        bookProfileViewController.book = book;
        [bookProfileViewController setHidesBottomBarWhenPushed:YES];
    }
}

@end
