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

@interface GWGridViewController : GWBaseViewController <PSTCollectionViewDataSource,PSTCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong, readonly) PlayBoard* playBoard;


//初始化该页面需要上级页面用以下两种方式之一传递必要数据
//传递网格的UniqueID
@property (nonatomic, strong) NSNumber* uniqueID;
//或者传递网格的volNumber和level
@property (nonatomic, strong) NSNumber* volNumber;
@property (nonatomic, assign) int level;

@end
