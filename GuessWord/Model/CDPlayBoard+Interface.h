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



+(CDPlayBoard *)CDPlayBoardByUniqueID:(NSNumber *)uniqueID                  //通过id获取CDPlayBoard
               inManagedObjectContext:(NSManagedObjectContext *)context;


+(void)inserToDatabaseWithPlayBoard:(PlayBoard *)thePlayBoard               //将PlayBoard插入到数据库中
             inManagedObjectContext:(NSManagedObjectContext *)context;

+(NSArray *)CDPlayBoardsByVolNumber:(NSNumber *)volNumber                //通过volNumber来获取一堆CDPlayBoards
             inManagedObjectContext:(NSManagedObjectContext *)context;

@end
