//
//  InsetsLabel.h
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWInsetsLabel : UILabel

@property(nonatomic, assign) UIEdgeInsets insets;
- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets;
- (id)initWithInsets:(UIEdgeInsets)insets;

@end