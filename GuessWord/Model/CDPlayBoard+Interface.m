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
{
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    
    CDPlayBoard *cdpb = [NSEntityDescription insertNewObjectForEntityForName:@"CDPlayBoard"
                                                      inManagedObjectContext:context];
    
    //将PlayBoard转化成CDPlayBoard
    cdpb.uniqueid   = thePlayBoard.uniqueid;
    cdpb.category   = thePlayBoard.category;
    cdpb.level      = [NSNumber numberWithInt:thePlayBoard.level];
    cdpb.jsonData   = [thePlayBoard jsonDataDescription];
    
    
    NSError *error;
    //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [context save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else {
        NSLog(@"Save successful!");
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
    
    // Set example predicate and sort orderings...
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
