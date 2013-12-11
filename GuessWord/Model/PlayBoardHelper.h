//
//  PlayBoardHelper.h
//  GuessWord
//
//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayBoard.h"
@interface PlayBoardHelper : NSObject

/************************API************************/

+(PlayBoard *)playBoardFromLocalDatabaseByUniqueID:(NSNumber *)uniqueID;   //通过BoardNumber生成一个PlayBoard
+(PlayBoard *)playBoardFromFile:(NSString *)jsonFile;                       //通过file生成一个PlayBoard
+(PlayBoard *)playBoardFromData:(NSData *)jsonData;                         //通过NSData生成一个PlayBoard

//将PlayBoard保存到数据库
+(void)insertPlayBoardToDatabase:(PlayBoard *)thePlayBoard;

@end
