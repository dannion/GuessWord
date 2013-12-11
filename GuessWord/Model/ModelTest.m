//
//  ModelTest.m
//  GuessWord
//
//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "ModelTest.h"
#import "PlayBoard.h"
#import "PlayBoardHelper.h"
@implementation ModelTest

+(void)testFunction{
    PlayBoard *pb = [PlayBoardHelper playBoardFromFile:@"td"];
    NSLog(@"%@",pb);
    [pb updateBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
    [PlayBoardHelper insertPlayBoardToDatabase:pb];

    PlayBoard * newPB = [PlayBoardHelper playBoardFromLocalDatabaseByUniqueID:[NSNumber numberWithInt:123456]];
    NSLog(@"===new PB ====%@",newPB);
    NSLog(@"------------------------------Model测试结束------------------------");

}
@end
