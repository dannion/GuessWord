//
//  MultiBoardCell.h
//  GuessWord
//
//  Created by WangJZ on 12/16/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "BoardCell.h"

@interface MultiBoardCell : BoardCell

@property(nonatomic,strong)NSMutableSet *multiCorrect;

-(BOOL)isCellCorrect;       //该cell的输入是正确的
-(BOOL)isCellInputBlank;    //该cell的input是否为控？
-(BOOL)isCellBlock;         //该cell是否是Block的
-(BOOL)isCellDone;          //该cell是否是汉字的？
-(BOOL)isCellCanInput;      //该cell可以输入

@end
