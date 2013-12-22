//
//  GWCatagoryCell.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWCatagoryCell.h"

static UIEdgeInsets ContentInsets = { .top = 0, .left = 0, .right = 0, .bottom = 0 };
//static CGFloat SubTitleLabelHeight = 24;

@implementation GWCatagoryCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //        UIView *background = [[UIView alloc] init];
        //        background.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.000 alpha:1.000];
        //        self.backgroundView = background;
        
//        UIView *selectedBackground = [[UIView alloc] init];
//        selectedBackground.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.000 alpha:1.000];
//        self.selectedBackgroundView = selectedBackground;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];//[UIColor colorWithRed:127.0/256 green:184.0/256 blue:115.0/256 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"随机模式";
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [_titleLabel sizeToFit];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor blackColor];//[UIColor colorWithRed:182.0/256 green:182.0/256 blue:182.0/256 alpha:1.0];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.text = @"已完成：20/100关";
        _detailLabel.font = [UIFont systemFontOfSize:13];
        [_detailLabel sizeToFit];
        
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_detailLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    _imageView.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);
    _titleLabel.frame = CGRectMake(60, 10, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    _detailLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+4, _detailLabel.frame.size.width, _detailLabel.frame.size.height);
}

- (void)setHighlighted:(BOOL)highlighted {
    //    NSLog(@"Cell %@ highlight: %@", _label.text, highlighted ? @"ON" : @"OFF");
    //    if (highlighted) {
    //        _label.backgroundColor = [UIColor brownColor];
    //    }
    //    else {
    //        _label.backgroundColor = [UIColor clearColor];
    //    }
}

@end
