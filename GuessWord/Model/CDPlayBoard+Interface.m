//
//  CDPlayBoard+Interface.m
//  GuessWord
//
//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "CDPlayBoard+Interface.h"
#import "PlayBoardHelper.h"
#import "GWAppDelegate.h"

@implementation CDPlayBoard (Interface)

//通过PlayBoard获取CDPlayBoard
+(CDPlayBoard *)CDPlayBoardConvertFromPlayBoard:(PlayBoard *)thePlayBoard{
    //TO DO:
    CDPlayBoard *cdpb = nil;
    return cdpb;
}

//将PlayBoard插入到数据库中
+(void)inserToDatabaseWithPlayBoard:(PlayBoard *)thePlayBoard
                       withUniqueID:(NSNumber *)uniqueID
{
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    /************先查询，删除************/
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CDPlayBoard" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uniqueid = %d)", [uniqueID intValue]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"uniqueid" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil) {
        NSLog(@"【error】读取数据库操作");
    }
    if ([array count] != 0) {
        [context deleteObject:[array firstObject]];
        NSLog(@"数据库有uniqueid = %@ 的棋盘格,删除",uniqueID);
    }else{
        NSLog(@"数据库中没有uniqueid = %@ 的棋盘格",uniqueID);
    }

    /**************再插入**************/
    CDPlayBoard *cdpb = [NSEntityDescription insertNewObjectForEntityForName:@"CDPlayBoard"
                                                      inManagedObjectContext:context];
    cdpb.uniqueid   = thePlayBoard.uniqueid;
    cdpb.category   = thePlayBoard.category;
    cdpb.level      = [NSNumber numberWithInt:thePlayBoard.level];
    cdpb.jsonData   = [thePlayBoard jsonDataDescription];

    BOOL isSaveSuccess = [context save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else {
        NSLog(@"插入新的uniqueid = %@ 的棋盘格",uniqueID);
    }
    [appDelegate saveContext];
}

//通过id获取CDPlayBoard
+(CDPlayBoard *)CDPlayBoardByUniqueID:(NSNumber *)uniqueID
{
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext=appDelegate.managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CDPlayBoard" inManagedObjectContext:managedObjectContext];

    [request setEntity:entity];
    
    /****************设置数据库查询的条件**************/
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uniqueid = %d)", [uniqueID intValue]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"uniqueid" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"%@",array);
    }
    return [array firstObject];
}

@end
