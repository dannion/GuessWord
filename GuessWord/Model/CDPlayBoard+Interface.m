//
//  CDPlayBoard+Interface.m
//  GuessWord
//
//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "CDPlayBoard+Interface.h"
#import "GWAppDelegate.h"
#import "CDVol+Interface.h"

@implementation CDPlayBoard (Interface)

//通过volNumber来获取一堆PlayBoards
+(NSArray *)CDPlayBoardsByVolNumber:(NSNumber *)volNumber
             inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CDPlayBoard" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    /****************设置数据库查询的条件**************/
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(volNumber = %d)", [volNumber intValue]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"volNumber" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"没有volNumber == %@ 的CDPlayBoards",volNumber);
        return nil;
    }
    return array;
}

+(void)documentIsReady:(UIManagedDocument *)document{
//    if (document.documentState == UIDocumentStateNormal) {
//        //start using document
//        NSManagedObjectContext *context = document.managedObjectContext;
//        //插入 context is the hook
//        CDPlayBoard *cdpb = [NSEntityDescription insertNewObjectForEntityForName:@"CDPlayBoard"
//                                                              inManagedObjectContext:context];
//        //目前cdpb中的所有peoperty都是nil的，可以通过字典的形式设置每个字段的值
//        //[cdpb setValue:@"" forKey:@""];
//        //当然，使用字典的方式有时候很丑陋，我们愿意使用@property的方式，怎么办呢？创建NSManagedObject的子类
//        cdpb.level = [NSNumber numberWithInt:1];
//        
//        //也可以为relationship赋值，而且强大的是你只要设置reletionship的单方向即可
//        
//        //所有以上的操作只会在内存中，不会保存到实际的数据库中，直到你调用save
//        
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@""];
//        request.fetchBatchSize = 20;
//        request.fetchLimit = 100;
//        request.sortDescriptors = ;
//        request.predicate = ;
//    }
}

+(void)openCoreDataBase{
    //获取文件url
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"MyDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    
    //通过url获取文件
    UIManagedDocument *document = [[UIManagedDocument alloc]initWithFileURL:url];
    
    //查看文件是否存在
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    if (fileExists) {
        [document openWithCompletionHandler:^(BOOL success){
        //TO DO:处理打开成功，因为打开和创建是异步的，所以需要用completionHandler
            if (success) {[self documentIsReady:document];}
            if (!success) {NSLog(@"不能在 %@ 创建文件",url);}
        }];
    }else{
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success){
          //TO DO:处理创建成功
              if (success) {[self documentIsReady:document];}
              if (!success) {NSLog(@"不能在 %@ 创建文件",url);}
          }];
    }
}


//将PlayBoard插入到数据库中
+(void)inserToDatabaseWithPlayBoard:(PlayBoard *)thePlayBoard
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    /************先查询，删除************/
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CDPlayBoard" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uniqueid = %d)", [thePlayBoard.uniqueid intValue]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"uniqueid" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil || [array count] > 1) {
        NSLog(@"【error】读取数据库操作%@ 或者uniqueid 不唯一" ,error);
    }
    if ([array count] != 0) {
        
#warning 棋盘添加字段位置4
        NSLog(@"数据库有uniqueid = %@ 的棋盘格,对其进行修改",thePlayBoard.uniqueid);
        CDPlayBoard *cdpb = [array firstObject];
        cdpb.star           = thePlayBoard.star;
        cdpb.islocked       = [NSNumber numberWithBool:thePlayBoard.islocked];
        cdpb.uniqueid       = thePlayBoard.uniqueid;
        cdpb.category       = thePlayBoard.category;
        cdpb.level          = [NSNumber numberWithInt:thePlayBoard.level];
        cdpb.jsonData       = [thePlayBoard jsonDataDescription];
        cdpb.volNumber      = thePlayBoard.volNumber;
        //如果库中已经有了，就不需要修改了belongToWhom了
        
        BOOL isSaveSuccess = [context save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error: %@,%@",error,[error userInfo]);
        }else {
            NSLog(@"修改 uniqueid = %@ 的棋盘格成功",thePlayBoard.uniqueid);
        }
    }else{
        NSLog(@"数据库中没有uniqueid = %@ 的棋盘格,新创建并插入",thePlayBoard.uniqueid);
        CDPlayBoard *cdpb = [NSEntityDescription insertNewObjectForEntityForName:@"CDPlayBoard"
                                                          inManagedObjectContext:context];
        
#warning 棋盘添加字段位置3
        cdpb.star           = thePlayBoard.star;
        cdpb.islocked       = [NSNumber numberWithBool:thePlayBoard.islocked];
        cdpb.uniqueid       = thePlayBoard.uniqueid;
        cdpb.category       = thePlayBoard.category;
        cdpb.level          = [NSNumber numberWithInt:thePlayBoard.level];
        cdpb.jsonData       = [thePlayBoard jsonDataDescription];
        cdpb.volNumber      = thePlayBoard.volNumber;
        CDVol *belongVol    = [CDVol CDVolWithUniqueVolNumber:thePlayBoard.volNumber inManagedObjectContext:context];
        cdpb.belongToWhom   = belongVol;
        
        BOOL isSaveSuccess = [context save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error: %@,%@",error,[error userInfo]);
        }else {
            NSLog(@"插入新的uniqueid = %@ 的棋盘格",thePlayBoard.uniqueid);
        }
        //[appDelegate saveContext];
    }
}

//通过vol_number和level获取CDPlayBoard
+(CDPlayBoard *)CDPlayBoardByVolNumber:(NSNumber *)vol_number
                              andLevel:(NSNumber *)level
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CDPlayBoard" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    /****************设置数据库查询的条件**************/
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"volNumber = %d AND level = %d", [vol_number intValue],[level intValue]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"volNumber" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"No such playboard with vol_no = %@ and level = %@ in local database",vol_number,level);
        return nil;
    }else if ([array count] > 1) {
        NSLog(@"Error: More than 1 cdplayboard with vol_no = %@ and level = %@ in local database",vol_number,level);
        return nil;
    }else{
        return [array firstObject];
    }
}

//通过id获取CDPlayBoard
+(CDPlayBoard *)CDPlayBoardByUniqueID:(NSNumber *)uniqueID
               inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CDPlayBoard" inManagedObjectContext:context];

    [request setEntity:entity];
    
    /****************设置数据库查询的条件**************/
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uniqueid = %d)", [uniqueID intValue]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"uniqueid" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"%@",array);
    }
    CDPlayBoard *copyPlayBoard = [array firstObject];
    return copyPlayBoard;
}

@end
