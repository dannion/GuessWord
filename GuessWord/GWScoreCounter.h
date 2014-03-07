//
//  GWScoreCounter.h
//  GuessWord
//
//  Created by Dannion on 13-12-19.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"
#import "PlayBoard.h"
#import "NewBoard.h"
#import "NewWord.h"

@interface GWScoreCounter : NSObject

//begin
+ (GWScoreCounter*)beginGameWithCurrentPlayBoard:(PlayBoard*)currentPlayBoard;  //用户开始游戏
- (id)initWithCurrentPlayBoard:(PlayBoard*)currentPlayBoard;

//begin
+ (GWScoreCounter*)beginGameWithCurrentNewBoard:(NewBoard*)currentPlayBoard;  //用户开始游戏
- (id)initWithCurrentNewBoard:(NewBoard*)currentPlayBoard;

//counting
- (void)userUseTip;     //用户使用了提醒
- (void)userEnterWrongAnswer;//用户答错了
- (void)userEnterCorrectWord:(Word*)word;//用户猜对了word这个单词
- (void)userEnterCorrectNewWord:(NewWord*)word;//用户猜对了word这个单词

//end
- (void)endGame;   //结束游戏

//currentScore
- (int)currentScore;

//reset
- (void)resetCounter;

@end
