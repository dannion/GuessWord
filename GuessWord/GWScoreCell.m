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



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        _imageView = [[UIImageView alloc] init];
//        _imageView.contentMode = UIViewContentModeScaleToFill;
//        
//        _label = [[UILabel alloc] init];
//        _label.textColor = [UIColor blackColor];
//        _label.textAlignment = NSTextAlignmentCenter;
//        _label.backgroundColor = [UIColor clearColor];
//        _label.userInteractionEnabled = NO;
        
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        
        _crownImageView = [[UIImageView alloc] init];
        _crownImageView.contentMode = UIViewContentModeScaleAspectFit;
        _crownImageView.image = [UIImage imageNamed:@"king_icon.png"];
        [_crownImageView sizeToFit];
        
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = [self colorForLabelText];
        _rankLabel.textAlignment = NSTextAlignmentLeft;
        _rankLabel.backgroundColor = [UIColor clearColor];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [self colorForLabelText];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.backgroundColor = [UIColor clearColor];
        
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = [self colorForLabelText];
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
        _scoreLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_bgImageView];
        [self.contentView addSubview:_crownImageView];
        [self.contentView addSubview:_rankLabel];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_scoreLabel];

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
    _bgImageView.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);
    _crownImageView.frame = CGRectMake(10, 15, _crownImageView.frame.size.width, _crownImageView.frame.size.height);
    _rankLabel.frame = CGRectMake(49, 0, self.frame.size.width, self.frame.size.height);
    _nameLabel.frame = CGRectMake(140, 0, self.frame.size.width, self.frame.size.height);
    _scoreLabel.frame = CGRectMake(244, 0, self.frame.size.width, self.frame.size.height);
}

- (UIColor*)colorForLabelText
{
    return [UIColor blackColor];
}

@end
