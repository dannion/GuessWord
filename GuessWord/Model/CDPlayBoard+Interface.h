//
//  CDPlayBoard+Interface.h
//  GuessWord

//  数据库的接口

//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "CDPlayBoard.h"
#import "PlayBoard.h"

@interface CDPlayBoard (Interface)

+(CDPlayBoard *)CDPlayBoardConvertFromPlayBoard:(PlayBoard *)thePlayBoard;//通过PlayBoard获取CDPlayBoard


//将PlayBoard插入到数据库中
+(void)inserToDatabaseWithPlayBoard:(PlayBoard *)thePlayBoard
                       withUniqueID:(NSNumber *)uniqueID;

//通过id获取CDPlayBoard
+(CDPlayBoard *)CDPlayBoardByUniqueID:(NSNumber *)uniqueID;

@end
