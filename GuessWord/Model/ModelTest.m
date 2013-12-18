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

+(void)testFunction
{
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSArray *array = [CDVol cdVolsFromFile:@"allVols" inManagedObjectContext:context];
    NSLog(@"通过网络获取的全部期信息，共有%d期数据",[array count]);
    
//#warning //奇怪，没有这句话的话，不能保存完整
//    NSError *error;
//    [context save:&error];//奇怪，没有这句话的话，不能保存完整
    
    
//    CDVol *_vol = [CDVol cdVolWithUniqueVolNumber:[NSNumber numberWithInt:3] inManagedObjectContext:context];
//    NSLog(@"本地获取的CDVol ==== %@",_vol);

    
    /*****************************从本地获取，如果获取不到，从服务器获取***************************/
    PlayBoard *pbwithlevel = [PlayBoard playBoardFromLocalDataBaseByVolNumber:[NSNumber numberWithInt:1]
                                                                     andLevel:[NSNumber numberWithInt:1]];
    if (pbwithlevel) {
        NSLog(@"本地[有]第%d期-第%d关",1,1);
    }else{
        NSLog(@"本地[没有]第%d期-第%d关,从服务器获取",1,1);
        pbwithlevel = [PlayBoard playBoardFromFile:@"td2"];
    }
    NSLog(@"当前棋盘信息%@",pbwithlevel);
    [pbwithlevel nextPointByUpdatingBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
    [pbwithlevel resetBoard];//重置棋盘
    [pbwithlevel saveToDataBase];
    /****************************************************************************************/
    

    


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
