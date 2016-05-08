//
//  NYBestsellerSearchTableViewController.m
//  Bestsellers
//
//  Created by Mpendulo Ndlovu on 2016/03/19.
//  Copyright © 2016 Comscie. All rights reserved.
//

#import "NYBestsellerSearchTableViewController.h"
#import "NYBestsellerBookSearchController.h"
#import "NYBestsellerBookProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Book.h"

@interface NYBestsellerSearchTableViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@end

@implementation NYBestsellerSearchTableViewController
{
    IBOutlet UITableView *_bookSearchBar;
    __weak IBOutlet UISearchBar *_booksSearchBar;
    NSArray *_searchResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _searchResults = [[NSMutableArray alloc] init];
    [_bookSearchBar resignFirstResponder];
    [self.searchDisplayController setActive:NO animated:NO];
    _booksSearchBar.text = @"";
}

- (void)didReceiveMemoryWarning
{
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

    return [_searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"searchResultsCellIdentifier"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchResultsCellIdentifier"];
    }
    
    Book * book = [_searchResults objectAtIndex:indexPath.row];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchDisplayController isActive])
    {
        [self performSegueWithIdentifier:@"bookSearchToProfile" sender:self];
    }
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"bookSearchToProfile"])
    {
        NSIndexPath *indexPath;
        
        if (self.searchDisplayController.active)
        {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            [_bookSearchBar resignFirstResponder];
            [self.searchDisplayController setActive:NO animated:NO];
        }
        else
        {
            indexPath = [self.tableView indexPathForSelectedRow];
        }
        
        Book * book = [_searchResults objectAtIndex:indexPath.row];
        NYBestsellerBookProfileViewController * bookProfileViewController = [segue destinationViewController];
        bookProfileViewController.book = book;
        [bookProfileViewController setHidesBottomBarWhenPushed:YES];
    }
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 0)
    {
        _searchResults = [NYBestsellerBookSearchController booksMatchingSearchForText:searchText];
    }
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
    {
    return (YES);
    }

@end
