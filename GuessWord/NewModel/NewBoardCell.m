//
//  NewBoardCell.m
//  GuessWord
//
//  Created by WangJZ on 3/5/14.
//  Copyright (c) 2014 BUPTMITC. All rights reserved.
//

#import "NewBoardCell.h"
#import "PlayBoard.h"


@implementation GWCharacter

@end

@implementation NewBoardCell


-(void)setStateDone{
    
}


-(BOOL)isCellCanInput{
    if (![self isCellDone] && ![self isCellBlock]) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isCellDone{
    if (self.currentState == GWGridCellCurrentStateDone) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isCellInputBlank{
    if ([self.input isEqualToString:BLANK]) {
        return YES;
    }else {
        return NO;
    }
}
//lazy_instance,初始化chars
-(NSMutableSet *)gwChars{
    if (!_gwChars) _gwChars = [[NSMutableSet alloc]init];
    return _gwChars;
}

//打印输出正确答案用
-(NSString *)stringOfCorrectAnswers{
    NSMutableString *retString = [[NSMutableString alloc]init];
    if ([self.gwChars count] > 1) {
        for (GWCharacter *oneChar in self.gwChars) {
            [retString appendFormat:@"%@|",oneChar.correct_answer];
        }
    }else{
        for (GWCharacter *oneChar in self.gwChars) {
            [retString appendFormat:@"%@",oneChar.correct_answer];
        }
    }
    return retString;
}


//重置这个cell
-(void)reset{
    if ([self isCellBlock]) {
        self.input = BLOCK;
        self.display = BLOCK;
        self.currentState = GWGridCellCurrentStateBlock;
    }else{
        self.input = BLANK;
        self.display = BLANK;
        self.currentState = GWGridCellCurrentStateBlank;
    }
}

//向multiCorrect添加一个正确答案
-(void)addCharWithAnswer:(NSString *)correctAnswer
               wordIndex:(int )wordIndex
                position:(int )position
{
    GWCharacter *temp = [[GWCharacter alloc]init];
    temp.wordIndex = wordIndex;
    temp.positionInWord = position;
    temp.correct_answer = correctAnswer;
    
    [self.gwChars addObject:temp];
}

-(BOOL)isCellBlock{
    //如果multi_correct是空的，那么是Block
    if ([self.gwChars count] > 0) {
        return NO;
    }else{
        return YES;
    }
}

//置为BLOCK
-(void)setToBlock{
    self.currentState = GWGridCellCurrentStateBlock;
    self.input = BLOCK;
    self.display = BLOCK;
    self.chinese = BLOCK;
    [self.gwChars removeAllObjects];
}
-(BOOL)isCellCorrect{
    //需求改变，如果输入的是汉字，并且汉字正确，返回Correct
    if (self.input == self.chinese) {
        return YES;
    }
    for (GWCharacter *oneChar in self.gwChars) {
        if ([oneChar.correct_answer isEqualToString:self.input]){
            return YES;
        }
    }
    return NO;
}

@end
