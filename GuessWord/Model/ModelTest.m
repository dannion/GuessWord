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
    PlayBoard * pb = [PlayBoardHelper playBoardFromFile:@"td"];
    NSLog(@"%@",pb);
    [pb updateBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
    pb.level = 2;
    [PlayBoardHelper insertPlayBoardToDatabase:pb withUniqueID:pb.uniqueid];


    NSLog(@"===new PB ====%@",pb);
    NSLog(@"------------------------------Model测试结束------------------------");

}
@end
