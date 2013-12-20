//
//  DatabaseGenerator.h
//  GuessWord
//
//  Created by WangJZ on 12/20/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DatabaseGenerator : NSObject

/*
 
 将数据导入到数据库
 offline数据 数据来源，根据特别的期来确定类别
 诗词歌赋  900001
 流行经典  900002
 
 */



+(void)importCDVolsToDatabaseWithFile:(NSString *)file;             //将 CDVols          的信息导入到数据库
+(void)importCDPlayBoardsToDatabaseWithFile:(NSString *)file;       //将 CDPlayBoards    的信息导入到数据库

@end
