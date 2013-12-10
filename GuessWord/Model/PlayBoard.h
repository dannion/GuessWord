//
//  PlayBoard.h
//  DMTXW
//
//  Created by WangJZ on 12/9/13.
//  Copyright (c) 2013 WangJZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

enum DIRECTION{
    VERTIVAL = 0,
    HORIZANTAL
};

#define BLOCK @"#" //不能填写的位置
#define BLANK @"-"  //空着的位置

@interface PlayBoard : NSObject/*Model：游戏的Board*/


/**************************************************API******************************************/

/*Controller调用方式：先用initWith初始化，然后每次用户输入更新Board，获取current_state*/

-(void)updateBoardWithInputValue:(NSString *)oneAlphabet atPoint:(CGPoint)point;//必须调用！每次用户输入一个字母

-(PlayBoard *)initWith;//默认的初始化函数
-(NSArray *)current_state;//获取当前游戏状态：
-(Word *)wordOfPoint:(CGPoint *)point inDirection:(BOOL)direction;//通过point获得指定方向的单词
-(BOOL)isBingoOfWordAtPoint:(CGPoint)point inDirection:(BOOL)direction;//判断某个点所在单词是否完成
-(BOOL)isFinished;//是否闯关成功
-(BOOL)isClickableOfPoint:(CGPoint)point;//判断该点是否能够点击
-(CGPoint *)nextPoint;//获取下一个坐标



@end
