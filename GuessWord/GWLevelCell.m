//
//  GWLevelCell.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWLevelCell.h"

static UIEdgeInsets ContentInsets = { .top = 0, .left = 0, .right = 0, .bottom = 0 };
//static CGFloat SubTitleLabelHeight = 24;

@implementation GWLevelCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //        UIView *background = [[UIView alloc] init];
        //        background.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.000 alpha:1.000];
        //        self.backgroundView = background;

        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = kFont;
        _label.userInteractionEnabled = NO;
        
        _lockImageView = [[UIImageView alloc] init];
        _lockImageView.contentMode = UIViewContentModeScaleAspectFit;
        _lockImageView.image = [UIImage imageNamed:@"locked_icon.png"];
        [_lockImageView sizeToFit];

        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_lockImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    _imageView.frame = CGRectMake(ContentInsets.left, ContentInsets.top, self.frame.size.width, self.frame.size.height);
    _label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20);
    
    _lockImageView.frame = CGRectMake(10, 64, _lockImageView.frame.size.width, _lockImageView.frame.size.height);
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
