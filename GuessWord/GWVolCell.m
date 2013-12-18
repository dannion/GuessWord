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
        
        UIView *selectedBackground = [[UIView alloc] init];
        selectedBackground.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.000 alpha:1.000];
        self.selectedBackgroundView = selectedBackground;
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        
        _volNumberLabel = [[UILabel alloc] init];
        _volNumberLabel.textColor = [UIColor blackColor];
        _volNumberLabel.textAlignment = NSTextAlignmentCenter;
        _volNumberLabel.backgroundColor = [UIColor clearColor];
        _volNumberLabel.userInteractionEnabled = NO;
        
        [self.contentView addSubview:_backgroundImageView];
        [self.contentView addSubview:_volNumberLabel];
        
        _detailImageView = [[UIImageView alloc] init];
        _detailImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_detailImageView];
        [self.contentView addSubview:_detailLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    _backgroundImageView.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);
    _volNumberLabel.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);
    
    _detailImageView.frame = CGRectMake(30, 30, self.frame.size.width-30, self.frame.size.height-30);
    
    _detailLabel.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);

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
