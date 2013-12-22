//
//  GWScoreCounter.h
//  GuessWord
//
//  Created by Dannion on 13-12-19.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

@interface GWScoreCounter : NSObject

+ (GWScoreCounter*)beginGame;  //用户开始游戏

- (void)userUseTip;     //用户使用了提醒
- (void)userEnterWrongAnswer;//用户答错了
- (void)userEnterCorrectWord:(Word*)word;//用户猜对了word这个单词

- (void)endGame;   //结束游戏

- (int)currentScore;

- (void)resetCounter;

@end
