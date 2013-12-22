//
//  GWCatagoryCell.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWCatagoryCell.h"

static UIEdgeInsets ContentInsets = { .top = 0, .left = 0, .right = 0, .bottom = 0 };

@implementation GWCatagoryCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [self colorForTitleLabelText];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"随机模式";
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [_titleLabel sizeToFit];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [self colorForDetailLabelText];
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

- (UIColor*)colorForTitleLabelText
{
//    return [UIColor  colorWithRed:182.0/256 green:182.0/256 blue:182.0/256 alpha:1.0];
    return [UIColor  colorWithRed:64.0/256 green:64.0/256 blue:64.0/256 alpha:1.0];
}

- (UIColor*)colorForDetailLabelText
{
    //    return [UIColor  colorWithRed:182.0/256 green:182.0/256 blue:182.0/256 alpha:1.0];
    return [UIColor  colorWithRed:128.0/256 green:128.0/256 blue:128.0/256 alpha:1.0];
}

@end
