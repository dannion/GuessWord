//
//  NewBoard.h
//  GuessWord
//
//  Created by WangJZ on 3/5/14.
//  Copyright (c) 2014 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewBoardCell.h"
@interface NewBoard : NSObject

#define BLOCK @"#"  //不能填写的位置
#define BLANK @"-"  //空着的位置

@property(nonatomic,strong) NSMutableArray *cells;  //所有的cells

@property(nonatomic,strong) NSArray *words;         //包含了全部的单词
@property(nonatomic,strong) NSString *category;     //棋盘的类别
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
@property(nonatomic) NSNumber *star;                //星星：用户的完成度
@property(nonatomic) BOOL islocked;                 //该棋盘是否已经解锁
@property(nonatomic) CGPoint last_point;            //上一次的坐标

/*************************Generator*************************************/
+(NSArray *)playBoardsFromLocalDatabaseVolNumber:(NSNumber *)volNumber;     //在数据库中找到所有该volNumber的 playBoards
+(NewBoard *)playBoardFromFile:(NSString *)jsonFile;                       //通过file生成一个PlayBoard
+(NewBoard *)playBoardFromData:(NSData *)jsonData;                         //通过NSData生成一个PlayBoard

+(NewBoard *)newBoardFromLocalDataBaseByVolNumber:(NSNumber *)vol_number
                                         andLevel:(NSNumber *)level;
-(NewBoard *)initWithJsonData:(NSData *)jsonData;  //默认的初始化函数
-(void)saveToDataBaseWithFinalScore:(int)finalScore;                                    //保存到数据库

-(NSData *)jsonDataDescription;
-(NSString*)description;
-(NewBoardCell *)cellAtPoint:(CGPoint)point;        //获取某个坐标上的boardcell
-(CGPoint)nextPointByUpdatingBoardWithInputValue:(NSString *)oneAlphabet                //必须调用！每次用户输入一个字母
                                         atPoint:(CGPoint)point;
-(BOOL)isGameBoardCompleted;                        //是否闯关成功
-(BOOL)isClickableAtPoint:(CGPoint)point;           //判断该点是否能够点击
-(void)resetBoard;                                  //重置棋盘
-(NSArray *)wordsOfPoint:(CGPoint)point;            //返回一个单词数组


@end
