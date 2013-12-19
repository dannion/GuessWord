//
//  GWScoreCell.m
//  GuessWord
//
//  Created by Dannion on 13-12-19.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWScoreCell.h"

static UIEdgeInsets ContentInsets = { .top = 0, .left = 0, .right = 0, .bottom = 0 };
//static CGFloat SubTitleLabelHeight = 24;

@implementation GWScoreCell

@synthesize imageView = _imageView;
@synthesize label = _label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        _label.userInteractionEnabled = NO;
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_label];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    _imageView.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);
    _label.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);
}

@end
