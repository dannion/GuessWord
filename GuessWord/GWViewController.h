//
//  GWViewController.h
//  GuessWord
//
//  Created by Dannion on 13-12-9.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayBoard.h"
#import "GWBaseViewController.h"

@interface GWViewController : GWBaseViewController <PSTCollectionViewDataSource,PSTCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong, readonly) PlayBoard* playBoard;

@end
