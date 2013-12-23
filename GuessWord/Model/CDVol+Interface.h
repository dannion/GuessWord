//
//  CDVol+Interface.h
//  GuessWord
//
//  Created by WangJZ on 12/13/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//  每次通过cdVolsWithJsonData来将网络的数据更新到本地，如果本地有，不改变，如果某一期没有，那么创建，并根据amountOfLevels来创建所有棋盘


#define KEY_FOR_UNIQUENUMBER    @"vol_no"
#define KEY_FOR_NAME            @"name"
#define KEY_FOR_AMOUNTLEVELS    @"amount_of_levels"
#define KEY_FOR_OPENDATE        @"open_date"
#define KEY_FOR_CURRENTLEVEL    @"cur_level"
#define KEY_FOR_VOLSCORE        @"vol_score"

#import "CDVol.h"

@interface CDVol (Interface)

-(NSString *)description;

+(NSArray *)cdVolsWithJsonData:(NSData *)jsonData                       //(read and write)  通过jsonData获取全部期的数据,cdVols数组
        inManagedObjectContext:(NSManagedObjectContext *)context;

-(void)updateScore;                                                     //将本CDVol的所有boards的积分相加并保存


+(CDVol *)cdVolWithVolDictionary:(NSDictionary *)volDictionary          //创建CDVol:根据Dictionary来查找CDVol，如果库中有，取出，如果没有，创建并返回创建后的CDVol[直播时候调用]
          inManagedObjectContext:(NSManagedObjectContext *)context;

+(CDVol *)cdVolWithUniqueVolNumber:(NSNumber *)uniqueVolNumber
            inManagedObjectContext:(NSManagedObjectContext *)context;   //根据uniqueVolNumber来查找CDVol，如果库中有，取出，如果没有，创建并返回创建后CDVol 【用来查询offline每个类别的数据】

#warning 测试用，过后删除
+(NSArray *)cdVolsFromFile:(NSString *)file                             //通过网络文件获取全部期的数据
    inManagedObjectContext:(NSManagedObjectContext *)context;


@end
