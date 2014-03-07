//
//  NewBoardCell.h
//  GuessWord
//
//  Created by WangJZ on 3/5/14.
//  Copyright (c) 2014 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoardCell.h"

//typedef NS_ENUM(NSInteger, GWGridCellCurrentState) {
//    GWGridCellCurrentStateBlock,
//    GWGridCellCurrentStateBlank,
//    GWGridCellCurrentStateGuessing,
//    GWGridCellCurrentStateDone,
//    GWGridCellCurrentStateUnKnown,
//};

/*字类，只有NewBoardCell持有这个类*/
@interface GWCharacter : NSObject

@property(nonatomic) int wordIndex;                //该字所在的词
@property(nonatomic) int positionInWord;          //该字在词中的位置
@property(nonatomic,strong) NSString *correct_answer;       //正确答案

@end



/*Cell类*/
@interface NewBoardCell : NSObject

@property(nonatomic) int x;//横向坐标
@property(nonatomic) int y;//纵向坐标
@property(nonatomic,strong)NSMutableSet *gwChars;                       //cell包含的字数组
@property(nonatomic,strong)NSString *input;                             //输入的字母
@property(nonatomic,strong)NSString *display;                           //当前显示的内容
@property(nonatomic,strong)NSString *chinese;                           //应该显示的汉字

@property(nonatomic)GWGridCellCurrentState currentState;


-(NSString *)stringOfCorrectAnswers;                                    //打印输出正确答案用
-(BOOL)isCellCorrect;                                                   //该cell的输入是正确的
-(BOOL)isCellInputBlank;                                                //该cell的input是否为控？
-(BOOL)isCellBlock;                                                     //该cell是否是Block的
-(BOOL)isCellDone;                                                      //该cell是否是汉字的？
-(BOOL)isCellCanInput;                                                  //该cell可以输入
-(void)reset;                                                           //重置这个cell
-(void)setToBlock;                                                      //置为BLOCK

-(void)addCharWithAnswer:(NSString *)correctAnswer                      //为cell添加字
               wordIndex:(int)wordIndex
                position:(int)position;

@end
