//
//  PowerBoardCell.m
//  GuessWord
//
//  Created by WangJZ on 12/16/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "PowerBoardCell.h"
#import "PlayBoard.h"

@implementation PowerBoardCell

//lazy_instance
-(NSMutableSet *)multi_correct{
    if (!_multi_correct) _multi_correct = [[NSMutableSet alloc]init];
    return _multi_correct;
}

//打印输出正确答案用
-(NSString *)stringOfCorrectAnswers{
    NSMutableString *retString = [[NSMutableString alloc]init];
    if ([self.multi_correct count] > 1) {
        for (NSString *oneAlphabet in self.multi_correct) {
            [retString appendFormat:@"%@|",oneAlphabet];
        }
    }else{
        for (NSString *oneAlphabet in self.multi_correct) {
            [retString appendFormat:@"%@",oneAlphabet];
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
-(void)addCorrectAnswerWithOneAlphabet:(NSString *)oneAlphabet{
    [self.multi_correct addObject:oneAlphabet];
}

-(BOOL)isCellBlock{
    //如果multi_correct是空的，那么是Block
    if ([self.multi_correct count] > 0) {
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
    [self.multi_correct removeAllObjects];
}
-(BOOL)isCellCorrect{
    BOOL answer = NO;
    for (NSString *oneAlphabet in self.multi_correct) {
        if ([oneAlphabet isEqualToString:self.input]) {
            answer = YES;
            break;
        }
    }
    return answer;
}

@end
