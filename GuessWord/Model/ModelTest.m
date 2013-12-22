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
#import "GWNetWorkingWrapper.h"

@implementation ModelTest

+(void)testFunction
{
//    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext *context = appDelegate.managedObjectContext;
// 
//
//    [GWNetWorkingWrapper getPath:@"overview.php"
//                      parameters:nil
//                    successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//                        NSLog(@"通过网络获取数据成功");
//                        
//                        //1、从网络全部期数据
////                        NSString *jsonString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
//                        NSArray *array = [CDVol cdVolsWithJsonData:operation.responseData
//                                            inManagedObjectContext:context];
//                        NSLog(@"通过网络获取的全部期信息，共有%d期数据",[array count]);
//                        
//                        //2、用户选择了第一期
//                        CDVol *currentCDVol = [array objectAtIndex:0];
//                        
//                        //3、查询第一期的关卡信息，关卡信息只显示，不修改，只有在保存PlayBoard的时候修改关卡信息
//                        NSArray *localCDPlayBoards = [CDPlayBoard cdPlayBoardsByVolNumber:currentCDVol.uniqueVolNumber
//                                                                   inManagedObjectContext:context];
//                        CDPlayBoard *onePB = [localCDPlayBoards objectAtIndex:0];//第一关信息
//                        NSLog(@"第 %@ 期的 boards星级、解锁信息%@",currentCDVol.uniqueVolNumber,localCDPlayBoards);
//                        
//                        //4、用户选择了第一期第一关，查询本地是否有，如果没有从网络获取
//                        PlayBoard *pbwithlevel = [PlayBoard playBoardFromLocalDataBaseByVolNumber:currentCDVol.uniqueVolNumber
//                                                                                         andLevel:[NSNumber numberWithInt:1]];
//                        if (pbwithlevel) {
//                            NSLog(@"本地[有]第%@期-第%d关",currentCDVol.uniqueVolNumber,1);
//                        }else{
//                            NSLog(@"本地[没有]第%@期-第%d关,从服务器获取",currentCDVol.uniqueVolNumber,1);
//                            pbwithlevel = [PlayBoard playBoardFromFile:@"td"];
//                        }
//                        NSLog(@"当前棋盘信息%@",pbwithlevel);
//                        [pbwithlevel nextPointByUpdatingBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
//                        [pbwithlevel resetBoard];//重置棋盘
//                        [pbwithlevel saveToDataBaseWithFinalScore:0];
//                        NSLog(@"------------------------------Model测试结束------------------------");
//                        
//    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        NSLog(@"通过网络获取数据错误");
//    }];
    

    
//    /*****************************获取X期Y关的信息**************************/
//    //1、先从本地查询是否有X期Y关
//    PlayBoard *responseObject = [PlayBoard playBoardFromLocalDataBaseByVolNumber:[NSNumber numberWithInt:101001]
//                                                                     andLevel:[NSNumber numberWithInt:1]];
//    //2、如果本地有，直接使用，如果没有，从网络获取
//    if (responseObject) {
//        NSLog(@"本地[有]第%d期-第%d关",101001,1);
//    }else{
//        NSLog(@"本地[没有]第%d期-第%d关,从服务器获取",101001,1);
//        NSDictionary *requestDic = @{@"vol":[NSString stringWithFormat:@"%d",101001]
//                                     ,@"lv":[NSString stringWithFormat:@"%d",1]};
//        
//        [GWNetWorkingWrapper getPath:@"playboard.php"
//                          parameters:requestDic
//                        successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//                            responseObject = [PlayBoard playBoardFromData:operation.responseData];
//                            if (responseObject) {
//                                [responseObject saveToDataBaseWithFinalScore:0];//从服务器获取数据后立即保存到数据库
//                                //3、修改保存
//                                NSLog(@"当前棋盘信息%@",responseObject);
//                                [responseObject nextPointByUpdatingBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
//                                [responseObject resetBoard];//重置棋盘
//                                [responseObject saveToDataBaseWithFinalScore:0];
//                                NSLog(@"------------------------------Model测试结束------------------------");
//                            }else{
//                                //handle error
//                            }
//                        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//                            NSLog(@"通过网络获取数据错误");
//                        }];
//    }

    
    
//    /*****************************从本地获取，如果获取不到，从服务器获取***************************/
//    PlayBoard *pbwithlevel = [PlayBoard playBoardFromLocalDataBaseByVolNumber:[NSNumber numberWithInt:1]
//                                                                     andLevel:[NSNumber numberWithInt:1]];
//    if (pbwithlevel) {
//        NSLog(@"本地[有]第%d期-第%d关",1,1);
//    }else{
//        NSLog(@"本地[没有]第%d期-第%d关,从服务器获取",1,1);
//        pbwithlevel = [PlayBoard playBoardFromFile:@"td"];
//    }
//    NSLog(@"当前棋盘信息%@",pbwithlevel);
//    [pbwithlevel nextPointByUpdatingBoardWithInputValue:@"A" atPoint:CGPointMake(3, 2)];
//    [pbwithlevel resetBoard];//重置棋盘
//    [pbwithlevel saveToDataBase];
//    /****************************************************************************************/

//    CDVol *vol = [CDVol cdVolWithUniqueVolNumber:[NSNumber numberWithInt:1] inManagedObjectContext:context];
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



}
@end
