//
//  GWLevelViewController.h
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWBaseViewController.h"
#import "CDVol.h"

@interface GWLevelViewController : GWBaseViewController <PSTCollectionViewDataSource,PSTCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

//非直播形式传入页面的必须数据
@property (nonatomic, strong) CDVol* vol;

//直播形式传入页面的必须数据
@property (nonatomic, strong) NSNumber* volUniqueNumber;
@property (nonatomic, strong) NSNumber* volLevelAmount;
@property (nonatomic, strong) NSArray* activateLevel;

@end
