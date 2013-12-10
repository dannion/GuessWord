//
//  CDPlayBoard+Interface.m
//  GuessWord
//
//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "CDPlayBoard+Interface.h"
#import "PlayBoardHelper.h"
@implementation CDPlayBoard (Interface)

//通过PlayBoard获取CDPlayBoard
+(CDPlayBoard *)CDPlayBoardConvertFromPlayBoard:(PlayBoard *)thePlayBoard{
    //TO DO:
    CDPlayBoard *cdpb = nil;
    return cdpb;
}
//将PlayBoard插入到数据库中
+(void)inserToDatabaseWithPlayBoard:(PlayBoard *)thePlayBoard
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    CDPlayBoard *cdpb = [NSEntityDescription insertNewObjectForEntityForName:@"CDPlayBoard"
                                                      inManagedObjectContext:context];
    
    //将PlayBoard转化成CDPlayBoard
    cdpb.category   = thePlayBoard.category;
    cdpb.level      = [NSNumber numberWithInt:thePlayBoard.level];
    cdpb.jsonData   = [thePlayBoard jsonDataDescription];
    
    
    NSError *error;
    //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [context save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else {
        NSLog(@"Save successful!");
    }
}

//通过id获取CDPlayBoard
+(CDPlayBoard *)CDPlayBoardByNumber:(NSNumber *)number{
    //TO DO:
    CDPlayBoard *cdpb = nil;
    return cdpb;
}

@end
