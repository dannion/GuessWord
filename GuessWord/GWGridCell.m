//
//  GWGridCell.m
//  GuessWord
//
//  Created by Dannion on 13-12-9.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWGridCell.h"

static UIEdgeInsets ContentInsets = { .top = 0, .left = 0, .right = 0, .bottom = 0 };
//static CGFloat SubTitleLabelHeight = 24;

@implementation GWGridCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
//        UIView *background = [[UIView alloc] init];
//        background.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.000 alpha:1.000];
//        self.backgroundView = background;
        
        UIView *selectedBackground = [[UIView alloc] init];
        selectedBackground.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.000 alpha:1.000];
        self.selectedBackgroundView = selectedBackground;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        
        _label = [[UITextField alloc] init];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];

        _label.userInteractionEnabled = NO;

        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_label];
        
    }
    return self;
}

- (void)layoutSubviews
{
    _imageView.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);
    _label.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);
}

- (void)setHighlighted:(BOOL)highlighted {
    NSLog(@"Cell %@ highlight: %@", _label.text, highlighted ? @"ON" : @"OFF");
    if (highlighted) {
        _label.backgroundColor = [UIColor redColor];
    }
    else {
        _label.backgroundColor = [UIColor clearColor];
    }
}

@end
