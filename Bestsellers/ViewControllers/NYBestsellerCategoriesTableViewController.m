//
//  NYBestsellerCategoriesTableViewController.m
//  Bestseller Archiver
//
//  Created by Mpendulo Ndlovu on 2016/03/05.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import "NYBestsellerCategoriesTableViewController.h"
#import "NYBestsellerRankingsTableViewController.h"

@interface NYBestsellerCategoriesTableViewController ()

@end

@implementation NYBestsellerCategoriesTableViewController
{
    NSMutableDictionary *_bookCategories;
    NSArray *_categoryDisplayNames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCategoryDisplayNames];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) loadCategoryDisplayNames
{
    _bookCategories = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                       @"Advice, How-To & Miscellaneous",@"advice-how-to-and-miscellaneous",
                        @"Animals", @"animals",
                        @"Business", @"business-books",
                        @"Children's Chapter Books", @"chapter-books",
                        @"Children's Picture Books", @"picture-books",
                        @"Children's Series", @"series-books",
                        @"Celebrities", @"celebrities",
                        @"Combined Print & E-Book Fiction", @"combined-print-and-e-book-fiction",
                        @"Combined Print & E-Book Nonfiction", @"combined-print-and-e-book-nonfiction",
                        @"Crime and Punishment", @"crime-and-punishment",
                        @"Culture", @"culture",
                        @"Education", @"education",
                        @"Espionage", @"espionage",
                        @"Expeditions, Disasters and Adventures", @"expeditions-disasters-and-adventures",
                        @"Family", @"family",
                        @"Fashion, Manners and Customs", @"fashion-manners-and-customs",
                        @"Food and Fitness", @"food-and-fitness",
                        @"Games and Activities", @"games-and-activities",
                        @"Health", @"health",
                        @"Humour", @"humor",
                        @"Indigenous Americans", @"indigenous-americans",
                        @"Manga", @"Manga",
                        @"Politics", @"hardcover-political-books",
                        @"Race and Civil Rights", @"race-and-civil-rights",
                        @"Relationships", @"relationships",
                        @"Religion, Spirituality and Faith", @"religion-spirituality-and-faith",
                        @"Science", @"science",
                        @"Sports", @"sports",
                        @"Travel", @"travel",
                        @"Young Adult", @"young-adult",
                        nil];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_bookCategories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * unsortedCategoryDisplayNames = [[NSMutableArray alloc] initWithArray:[_bookCategories allValues]];
    _categoryDisplayNames = [[NSArray alloc] init];
    _categoryDisplayNames = [unsortedCategoryDisplayNames sortedArrayUsingSelector:@selector(compare:)];
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCellIdentifier"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"categoryCellIdentifier"];
    }
    
    cell.textLabel.text = [_categoryDisplayNames objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"categoriesToRankings"])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        NSString * categoryDisplayName = [_categoryDisplayNames objectAtIndex:indexPath.row];
        NSArray * listNames = [_bookCategories allKeysForObject:categoryDisplayName];
        NSString * categoryListName = [listNames objectAtIndex:0];
        
        NYBestsellerRankingsTableViewController * rankingsTableViewController = [segue destinationViewController];
        rankingsTableViewController.category = categoryListName;
        rankingsTableViewController.displayName = categoryDisplayName;
        [rankingsTableViewController setHidesBottomBarWhenPushed:YES];
    }
}


@end
