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

@property (nonatomic, strong) CDVol* vol;


@end
