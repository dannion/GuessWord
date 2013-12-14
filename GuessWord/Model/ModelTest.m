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
    PlayBoard * pb = [PlayBoard playBoardFromFile:@"td"];
    NSLog(@"-----init PB ---%@",pb);
    [pb nextPointByUpdatingBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
    pb.level = 2;
    
    [pb saveToDataBase];

    NSLog(@"------------------------------Model测试结束------------------------");

}
@end
