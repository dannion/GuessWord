//
//  ModelTest.m
//  GuessWord
//
//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "ModelTest.h"
#import "PlayBoard.h"
#import "CDVol+Interface.h"
#import "GWAppDelegate.h"

@implementation ModelTest

+(void)testFunction{

    PlayBoard * pb = [PlayBoard playBoardFromFile:@"td2"];
//    PlayBoard *pb = [PlayBoard playBoardFromLocalDatabaseByUniqueID:[NSNumber numberWithInt:10002]];
    NSLog(@"-----init PB ---%@",pb);
    [pb nextPointByUpdatingBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
    pb.level = 2;
    [pb saveToDataBase];
    
//    //获取id是1的CDVol并保存在客户端一个文件下
//    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext *context = appDelegate.managedObjectContext;
//    CDVol *vol = [CDVol CDVolWithUniqueVolNumber:[NSNumber numberWithInt:1] inManagedObjectContext:context];
//    [vol saveToFile:@"vol1.txt"];
    
//    //通过volNumber来获取棋盘
//    NSNumber *volNumber = [NSNumber numberWithInt:1];
//    NSArray *playboards = [PlayBoard playBoardsFromLocalDatabaseVolNumber:volNumber];
//
//    NSLog(@"从数据库中获得 %d 个第【%@】期的棋盘",[playboards count],volNumber);
//    for (PlayBoard *pb in playboards) {
//        NSLog(@"%@",pb);
//    }
//    pb.score = 20;//修改不会影响数据库中的数据
    
    
//        [CDVol saveArrayToFile:@"allVols.txt" withArray:[CDVol cdvolArray]];

    NSLog(@"------------------------------Model测试结束------------------------");

}
@end
