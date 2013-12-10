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

#define BLOCK @"#"
#define BLANK @"-"

/*Model：游戏的Board*/
@interface PlayBoard : NSObject


-(PlayBoard *)initWith;
//获取当前游戏状态：
-(NSArray *)current_state;

//通过point获得指定方向的单词
-(Word *)wordOfPoint:(CGPoint *)point inDirection:(BOOL)direction;

//判断某个点所在单词是否
-(BOOL)isBingoOfWordAtPoint:(CGPoint)point inDirection:(BOOL)direction;

//是否闯关成功
-(BOOL)isFinished;

//判断该点是否能够点击
-(BOOL)isClickableOfPoint:(CGPoint)point;

//获取下一个坐标
-(CGPoint *)nextPoint;

@end
