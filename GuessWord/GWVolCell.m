//
//  GWVolCell.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWVolCell.h"

static UIEdgeInsets ContentInsets = { .top = 0, .left = 0, .right = 0, .bottom = 0 };
//static CGFloat SubTitleLabelHeight = 24;

@implementation GWVolCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //        UIView *background = [[UIView alloc] init];
        //        background.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.000 alpha:1.000];
        //        self.backgroundView = background;
        
//        UIView *selectedBackground = [[UIView alloc] init];
//        selectedBackground.backgroundColor = [UIColor colorWithRed:234.0 green:234.0 blue:234.000 alpha:1.000];
//        self.selectedBackgroundView = selectedBackground;
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        
        _volNumberLabel = [[UILabel alloc] init];
        _volNumberLabel.text = @"第一期";
        _volNumberLabel.textColor = [UIColor blackColor];
        _detailLabel.font = [UIFont systemFontOfSize:23];
        _volNumberLabel.textAlignment = NSTextAlignmentCenter;
        _volNumberLabel.backgroundColor = [UIColor clearColor];
        [_volNumberLabel sizeToFit];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont systemFontOfSize:8];
        _detailLabel.text = @"积分：340";
        [_detailLabel sizeToFit];
        
        [self.contentView addSubview:_backgroundImageView];
        [self.contentView addSubview:_volNumberLabel];
        [self.contentView addSubview:_detailLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    _backgroundImageView.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);
    _volNumberLabel.frame = CGRectMake(17, 24, _volNumberLabel.frame.size.width, _volNumberLabel.frame.size.height);
    _detailLabel.frame = CGRectMake(19, 63, _detailLabel.frame.size.width, _detailLabel.frame.size.height);

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
