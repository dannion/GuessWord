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
    PlayBoard * pb = [PlayBoard playBoardFromFile:@"puz1"];
    NSLog(@"-----init PB ---%@",pb);
    [pb updateBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
    pb.level = 2;
    [PlayBoard insertPlayBoardToDatabase:pb withUniqueID:pb.uniqueid];
    
    
    NSLog(@"===new PB ====%@",pb);
    NSLog(@"------------------------------Model测试结束------------------------");

}
@end
