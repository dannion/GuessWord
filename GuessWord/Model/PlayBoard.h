//
//  PlayBoard.h
//  DMTXW
//
//  Created by WangJZ on 12/9/13.
//  Copyright (c) 2013 WangJZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"
@class PowerBoardCell;

typedef NS_ENUM(NSInteger, GWPlayBoardCurrentDirection) {
    VERTICAL_DIRECTION,
    HORIZONTAL_DERECTION,
};

#define BLOCK @"#"  //不能填写的位置
#define BLANK @"-"  //空着的位置

@interface PlayBoard : NSObject/*Model：游戏的Board*/

/************************构造类实例的方法************************/
+(NSArray *)playBoardsFromLocalDatabaseVolNumber:(NSNumber *)volNumber;     //在数据库中找到所有该volNumber的 playBoards
+(PlayBoard *)playBoardFromLocalDatabaseByUniqueID:(NSNumber *)uniqueID;    //通过BoardNumber生成一个PlayBoard
+(PlayBoard *)playBoardFromFile:(NSString *)jsonFile;                       //通过file生成一个PlayBoard
+(PlayBoard *)playBoardFromData:(NSData *)jsonData;                         //通过NSData生成一个PlayBoard

/************************************************公有变量***************************************/
@property(nonatomic,strong) NSArray *words;         //包含了全部的单词
@property(nonatomic,strong) NSString *category;     //包含了全部的单词
@property(nonatomic) NSNumber *uniqueid;            //board的id
@property(nonatomic) NSNumber *volNumber;           //对应的第几集
@property(nonatomic,strong) NSString *file;         //对应的文件
@property(nonatomic) NSDate *date;                  //游戏的日期
@property(nonatomic,strong) NSString *gamename;     //游戏名字
@property(nonatomic,strong) NSString *author;       //作者
@property(nonatomic) int degree;                    //难度
@property(nonatomic) int score;                     //得分
@property(nonatomic) int percent;                   //完成度
@property(nonatomic) int level;                     //游戏等级
@property(nonatomic) int width;                     //横向有多少个格子
@property(nonatomic) int height;                    //纵向有多少个格子

#warning #warning 棋盘添加字段位置0
@property(nonatomic) BOOL islocked;                 //该棋盘是否已经解锁
@property(nonatomic) CGPoint last_point;            //上一次的坐标

/**************************************************API******************************************/

-(void)saveToFile:(NSString *)saveFile;
-(void)saveToDataBase;                                                                  //保存到数据库
-(void)insertToDatabase;                                                                //插入到数据库
-(PowerBoardCell *)cellAtPoint:(CGPoint)point;                                               //获取某个坐标上的boardcell
-(NSString*)description;
-(NSData *)jsonDataDescription;                                                         //返回对象的json数据

-(CGPoint)nextPointByUpdatingBoardWithInputValue:(NSString *)oneAlphabet                //必须调用！每次用户输入一个字母
                                         atPoint:(CGPoint)point;
-(PlayBoard *)initWithJsonData:(NSData *)jsonData;                                      //默认的初始化函数
-(NSArray *)current_state;                                                              //of cells获取当前游戏显示状态：
-(Word *)wordOfPoint:(CGPoint)point inHorizontalDirection:(BOOL)isHorizontal;           //通过point获得指定方向的单词

-(BOOL)isGameBoardCompleted;                                                            //是否闯关成功
-(BOOL)isClickableAtPoint:(CGPoint)point;                                               //判断该点是否能够点击

-(BOOL)isBingoOfWordAtPoint:(CGPoint)point inHorizontalDirection:(BOOL)isHorizontal;    //判断某个点所在单词是否完成
-(BOOL)isFullFillOfWordAtPoint:(CGPoint)point inHorizontalDirection:(BOOL)isHorizontal; //判断某个点所在单词是否全部输入（不一定正确）


@end
