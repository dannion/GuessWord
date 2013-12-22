//
//  GWScoreCounter.m
//  GuessWord
//
//  Created by Dannion on 13-12-19.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWScoreCounter.h"

#define INITIAL_SCORE 0
#define HINT_PENALTY 5
#define SCORE_PER_CHARACTER 3
#define WORD_ERROR_PENALTY 1


@interface GWScoreCounter(){
    BOOL isCountingScore;
    int currentScore;
}

- (void)start;

@end
//负责游戏计分
@implementation GWScoreCounter



+ (GWScoreCounter*)beginGame
{
    GWScoreCounter* scoreCounter = [[GWScoreCounter alloc] init];
    
    [scoreCounter start];
    
    return scoreCounter;
}

- (void)start
{
    isCountingScore = YES;
    currentScore = INITIAL_SCORE;
    //计时
}

- (void)userUseTip
{
    if (isCountingScore) {
        currentScore -= HINT_PENALTY;
    }
}
- (void)userEnterWrongAnswer
{
    if (isCountingScore) {
        currentScore -= WORD_ERROR_PENALTY;
    }
}
- (void)userEnterCorrectWord:(Word*)word
{
    if (isCountingScore) {
        currentScore += SCORE_PER_CHARACTER * word.length;
    }
}

- (void)endGame
{
    //结束计时，对currentScore加上时间加成。
    isCountingScore = NO;
}

- (int)currentScore
{
    return currentScore;
}

- (void)resetCounter
{
    isCountingScore = YES;
    currentScore = INITIAL_SCORE;
}

@end










