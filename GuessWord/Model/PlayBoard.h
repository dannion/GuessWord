//
//  PlayBoard.h
//  DMTXW
//
//  Created by WangJZ on 12/9/13.
//  Copyright (c) 2013 WangJZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

#define VERTICAL_DIRECTION YES;
#define HORIZONTAL_DERECTION NO;

#define BLOCK @"#"  //不能填写的位置
#define BLANK @"-"  //空着的位置

@interface PlayBoard : NSObject/*Model：游戏的Board*/

/************************************************公有变量***************************************/
@property(nonatomic,strong) NSArray *words;//包含了全部的单词
@property(nonatomic,strong) NSString *category;//包含了全部的单词
@property(nonatomic,strong) NSString *file; // 对应的文件
@property(nonatomic) NSDate *date; // 游戏的日期
@property(nonatomic,strong) NSString *gamename; // 游戏名字
@property(nonatomic,strong) NSString *author; // 作者
@property(nonatomic) int score;//得分
@property(nonatomic) int percent;//完成度
@property(nonatomic) int level;//游戏等级
@property(nonatomic) int width;//横向有多少个格子
@property(nonatomic) int height;//纵向有多少个格子
@property(nonatomic) CGPoint current_point;//当前坐标x



/**************************************************API******************************************/

//Controller调用方式：先用initWith初始化，然后每次用户输入更新Board，获取current_state


#warning 没啥用吧
-(void)saveToFile:(NSString *)saveFile;


//测试用
-(NSString*)description;


-(NSData *)jsonDataDescription;//返回对象的json数据

-(void)updateBoardWithInputValue:(NSString *)oneAlphabet atPoint:(CGPoint)point;//必须调用！每次用户输入一个字母

-(PlayBoard *)initWithJsonData:(NSData *)jsonData;//默认的初始化函数
-(NSArray *)current_state;//of cells获取当前游戏显示状态：
-(Word *)wordOfPoint:(CGPoint)point inHorizontalDirection:(BOOL)isHorizontal;//通过point获得指定方向的单词
-(BOOL)isBingoOfWordAtPoint:(CGPoint)point inHorizontalDirection:(BOOL)isHorizontal;//判断某个点所在单词是否完成
-(BOOL)isGameBoardCompleted;//是否闯关成功
-(BOOL)isClickableAtPoint:(CGPoint)point;//判断该点是否能够点击
//-(CGPoint *)nextPoint;//获取下一个坐标



@end
