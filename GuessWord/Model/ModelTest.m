//
//  ModelTest.m
//  GuessWord
//
//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "ModelTest.h"
#import "PlayBoard.h"
@implementation ModelTest

+(void)testFunction{
    PlayBoard *pb = [[PlayBoard alloc]initWith];
    [pb updateBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
    [pb updateBoardWithInputValue:@"A" atPoint:CGPointMake(1, 1)];
    NSLog(@"%@",pb);

}
@end
