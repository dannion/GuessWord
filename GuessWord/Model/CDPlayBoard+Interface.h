//
//  CDPlayBoard+Interface.h
//  GuessWord

//  数据库的接口

//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "CDPlayBoard.h"
#import "PlayBoard.h"
//islocked star volNumber是必须填写的
@interface CDPlayBoard (Interface)


/*               //将PlayBoard插入到数据库中*/
+(void)inserToDatabaseWithPlayBoard:(PlayBoard *)thePlayBoard
             inManagedObjectContext:(NSManagedObjectContext *)context;


+(CDPlayBoard *)cdPlayBoardByVolNumber:(NSNumber *)vol_number               //通过vol_number和level获取CDPlayBoard
                              andLevel:(NSNumber *)level
                inManagedObjectContext:(NSManagedObjectContext *)context;

+(CDPlayBoard *)cdPlayBoardByUniqueID:(NSNumber *)uniqueID                  //通过id获取CDPlayBoard
               inManagedObjectContext:(NSManagedObjectContext *)context;



+(NSArray *)cdPlayBoardsByVolNumber:(NSNumber *)volNumber                //通过volNumber来获取一堆CDPlayBoards
             inManagedObjectContext:(NSManagedObjectContext *)context;

@end
