//
//  GWScoreCell.h
//  GuessWord
//
//  Created by Dannion on 13-12-19.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWScoreCell : UITableViewCell

@property (strong, nonatomic) UIImageView* bgImageView;

@property (strong, nonatomic) UIImageView* crownImageView;
@property (strong, nonatomic) UILabel* rankLabel;
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UILabel* scoreLabel;


@end
