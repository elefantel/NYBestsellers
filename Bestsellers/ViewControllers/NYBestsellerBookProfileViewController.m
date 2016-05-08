//
//  NYBestsellerBookProfileViewController.m
//  Bestseller Archiver
//
//  Created by Mpendulo Ndlovu on 2016/03/04.
//  Copyright © 2016 Elefantel. All rights reserved.
//

#import "NYBestsellerBookProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NYBestsellerBookProfileViewController()

@end

@implementation NYBestsellerBookProfileViewController
{
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIImageView *_profileImage;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_authorLabel;
    __weak IBOutlet UILabel *_publisherLabel;
    __weak IBOutlet UITextView *_amazonLinkTextView;
    __weak IBOutlet UILabel *_descriptionLabel;

    UITapGestureRecognizer *_bookmarkTapGesture;
    NSMutableDictionary *_bookmarks;
    BOOL _isBookmarked;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleLabel.text = [NSString stringWithFormat:@"Title: %@",self.book.title];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    
    _authorLabel.text = [NSString stringWithFormat:@"Author: %@",self.book.author];
    
    _publisherLabel.text = [NSString stringWithFormat:@"Publisher: %@",self.book.publisher];
    
    _amazonLinkTextView.text = [NSString stringWithFormat:@"Amazon Link: %@",self.book.productUrl];
    
    _descriptionLabel.text = [NSString stringWithFormat:@"Description: %@",self.book.bookDescription];
    
    NSString * cachedImageURL = [NSString stringWithFormat:(@"%@.png"),self.book.imageUrl];
    [_profileImage sd_setImageWithURL:[NSURL URLWithString:_book.imageUrl]
                 placeholderImage:[UIImage imageNamed:cachedImageURL]
                          options:SDWebImageRefreshCached];
    _profileImage.contentMode = UIViewContentModeScaleAspectFit;
    
    _profileImage.userInteractionEnabled = YES;
    _bookmarkTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookmarkTapGesture:)];
    _bookmarkTapGesture.numberOfTapsRequired = 1;
    [_profileImage addGestureRecognizer:_bookmarkTapGesture];
    
    _bookmarks = [[NSMutableDictionary alloc] init];
    _isBookmarked = NO;
    
    NSMutableDictionary * booksDictionary = [[NSMutableDictionary alloc] init];
    booksDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarks"] mutableCopy];
    
    if ([booksDictionary count] == 0)
    {
        return;
    }
    
    if ([booksDictionary objectForKey:self.book.imageUrl] != nil)
    {
        _isBookmarked = YES;
        [_profileImage.layer setBorderColor: [[UIColor magentaColor] CGColor]];
        [_profileImage.layer setBorderWidth: 2.0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) bookmarkTapGesture:(id)sender
{
    _bookmarks = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarks"] mutableCopy];
    
   if (_isBookmarked)
   {
        [_bookmarks removeObjectForKey:self.book.imageUrl];
        [[NSUserDefaults standardUserDefaults] setObject:_bookmarks forKey:@"bookmarks"];
        [_profileImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [_profileImage.layer setBorderWidth: 0.0];
   }
   else
   {
        [_bookmarks setValue:self.book.imageUrl forKey:self.book.imageUrl];
        [[NSUserDefaults standardUserDefaults] setObject:_bookmarks forKey:@"bookmarks"];
        [_profileImage.layer setBorderColor: [[UIColor magentaColor] CGColor]];
        [_profileImage.layer setBorderWidth: 2.0];
   }
   
   [[NSUserDefaults standardUserDefaults] synchronize];
   _isBookmarked = !_isBookmarked;
}

@end
