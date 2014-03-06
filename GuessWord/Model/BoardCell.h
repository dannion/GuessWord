//
//  Cell.h
//  GuessWord
//
//  Created by WangJZ on 12/11/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//


#import <Foundation/Foundation.h>
//#import "PlayBoard.h"



@interface BoardCell : NSObject

typedef NS_ENUM(NSInteger, GWGridCellCurrentState) {
    GWGridCellCurrentStateBlock,
    GWGridCellCurrentStateBlank,
    GWGridCellCurrentStateGuessing,
    GWGridCellCurrentStateDone,
    GWGridCellCurrentStateUnKnown,
};

@property(nonatomic,strong)NSString *correct;//正确的文字
@property(nonatomic,strong)NSString *input;//输入的字母
@property(nonatomic,strong)NSString *display;//应该显示的内容
@property(nonatomic)GWGridCellCurrentState currentState;

-(void)setStateDoneWithChineseCharacter:(NSString *)chineseCharacter;//完成该cell,修改状态，设置汉字

-(BOOL)isCellCorrect;       //该cell的输入是正确的
-(BOOL)isCellInputBlank;    //该cell的input是否为控？
-(BOOL)isCellBlock;         //该cell是否是Block的
-(BOOL)isCellDone;          //该cell是否是汉字的？
-(BOOL)isCellCanInput;      //该cell可以输入

@end
