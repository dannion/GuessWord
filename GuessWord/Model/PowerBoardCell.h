//
//  PowerBoardCell.h
//  GuessWord
//
//  Created by WangJZ on 12/16/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "BoardCell.h"

@interface PowerBoardCell : BoardCell

@property(nonatomic,strong)NSMutableSet *multi_correct;

-(NSString *)stringOfCorrectAnswers;                            //打印输出正确答案用
-(void)addCorrectAnswerWithOneAlphabet:(NSString *)oneAlphabet; //向multiCorrect添加一个正确答案
-(BOOL)isCellBlock;                                             //重载
-(BOOL)isCellCorrect;                                           //重载

@end
