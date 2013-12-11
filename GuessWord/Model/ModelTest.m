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
    NSArray *a = [pb current_state];
    
    NSLog(@"%@",pb);
    
    [pb updateBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
    [pb updateBoardWithInputValue:@"A" atPoint:CGPointMake(1, 1)];
    
    BOOL bingo = [pb isBingoOfWordAtPoint:CGPointMake(2, 2) inHorizontalDirection:NO];
    
    a = [pb current_state];
    NSLog(@"%@",pb);
    NSLog(@"------------------------------Model测试结束------------------------");

}
@end
