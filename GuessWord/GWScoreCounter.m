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


@interface GWScoreCounter()
{
    BOOL isCountingScore;
    int currentScore;
}

@end
//负责游戏计分
@implementation GWScoreCounter



+ (GWScoreCounter*)beginGameWithCurrentPlayBoard:(PlayBoard*)currentPlayBoard
{
    GWScoreCounter* scoreCounter = [[GWScoreCounter alloc] initWithCurrentPlayBoard:currentPlayBoard];
    
    
    return scoreCounter;
}

- (id)initWithCurrentPlayBoard:(PlayBoard*)currentPlayBoard
{
    self = [super init];
    if (self) {
        isCountingScore = YES;
        
        if (currentPlayBoard.score == 0) {
            currentScore = INITIAL_SCORE;
        }else{
            currentScore = currentPlayBoard.score;
        }
        //计时

    }
    return self;
}

+ (GWScoreCounter*)beginGameWithCurrentNewBoard:(NewBoard*)currentPlayBoard
{
    GWScoreCounter* scoreCounter = [[GWScoreCounter alloc] initWithCurrentNewBoard:currentPlayBoard];
    
    
    return scoreCounter;
}

- (id)initWithCurrentNewBoard:(NewBoard*)currentPlayBoard
{
    self = [super init];
    if (self) {
        isCountingScore = YES;
        
        if (currentPlayBoard.score == 0) {
            currentScore = INITIAL_SCORE;
        }else{
            currentScore = currentPlayBoard.score;
        }
        //计时
        
    }
    return self;
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
- (void)userEnterCorrectNewWord:(NewWord*)word
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










