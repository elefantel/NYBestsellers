//
//  NYBestsellerRankingsTableViewController.m
//  Bestseller Archiver
//
//  Created by Mpendulo Ndlovu on 2016/03/04.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import "NYBestsellerRankingsTableViewController.h"
#import "NYBestsellerAPIConnectionController.h"
#import "Book.h"
#import "BookList.h"
#import "NYBestsellerBookProfileViewController.h"
#import "LoadingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NYBestsellerRankingsTableViewController()
@property(nonatomic, strong) NSArray *bookList;
@end

@implementation NYBestsellerRankingsTableViewController
    {
    __weak IBOutlet UILabel *_sectionHeaderLabel;
    NYBestsellerAPIConnectionController *_connectionController;
    }

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sectionHeaderLabel.text = [self.displayName uppercaseString];

    [LoadingViewController displayLoadingView];
    _connectionController = [NYBestsellerAPIConnectionController new];
    [_connectionController updateDatabaseInventoryForItemsCategory:self.category
    success:^()
        {
            [self fetchBookListFromDatabase];
            [self.tableView reloadData];
            [LoadingViewController removeLoadingView];
        }
    failure:^(NSError * error)
        {   //repeating the success block code here, but these methods can't be conveniently bundled into one
            [self fetchBookListFromDatabase];
            [self.tableView reloadData];
            [LoadingViewController removeLoadingView];
        }
    ];
}


- (void)fetchBookListFromDatabase
{
    NSManagedObjectContext * context = _connectionController.managedObjectContext;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BookList"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"displayName = %@",self.displayName];

    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    BookList * bookList = [fetchedObjects firstObject];
    NSArray * books = [[NSArray alloc] initWithArray:[[bookList books] allObjects]];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES selector:@selector(compare:)];
    self.bookList = [books sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
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
    return [self.bookList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"bookCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"bookCellIdentifier"];
    }
    
    Book * book = [self.bookList objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"%d. %@", @"Book Title"), indexPath.row + 1, book.title];
    cell.detailTextLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"%@", @"Book Author"), book.author];
    if (cell.imageView.image == nil)
    {
        cell.imageView.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:book.imageUrl]]];
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
        Book * book = [self.bookList objectAtIndex:indexPath.row];
        NYBestsellerBookProfileViewController * bookProfileViewController = [segue destinationViewController];
        bookProfileViewController.book = book;
    }
}

@end
