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
    __weak IBOutlet UIImageView *_profileImage;
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_authorLabel;
    __weak IBOutlet UILabel *_publisherLabel;
    __weak IBOutlet UITextView *_amazonLinkTextView;
    __weak IBOutlet UILabel *_descriptionLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleLabel.text = [NSString stringWithFormat:@"Title: %@",self.book.title];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    
    _authorLabel.text = [NSString stringWithFormat:@"Author: %@",self.book.author];
    _authorLabel.font = [UIFont systemFontOfSize:14];
    
    _publisherLabel.text = [NSString stringWithFormat:@"Publisher: %@",self.book.publisher];
    _publisherLabel.font = [UIFont systemFontOfSize:14];
    
    _amazonLinkTextView.text = [NSString stringWithFormat:@"Amazon Link: %@",self.book.productUrl];
    _amazonLinkTextView.font = [UIFont systemFontOfSize:14];
    
    _descriptionLabel.text = [NSString stringWithFormat:@"Description: %@",self.book.bookDescription];
    _descriptionLabel.font = [UIFont systemFontOfSize:14];
    
    NSString * cachedImageURL = [NSString stringWithFormat:(@"%@.png"),self.book.imageUrl];
    [_profileImage sd_setImageWithURL:[NSURL URLWithString:_book.imageUrl]
                 placeholderImage:[UIImage imageNamed:cachedImageURL]
                          options:SDWebImageRefreshCached];
    _profileImage.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
