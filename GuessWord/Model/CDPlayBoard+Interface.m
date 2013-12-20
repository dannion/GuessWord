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

-(void)setAttributesWithPlayBoard:(PlayBoard *)thePlayBoard{
    #warning 棋盘添加字段位置4
    self.star           = thePlayBoard.star;
    self.islocked       = [NSNumber numberWithBool:thePlayBoard.islocked];
    self.uniqueid       = thePlayBoard.uniqueid;
    self.category       = thePlayBoard.category;
    self.level          = [NSNumber numberWithInt:thePlayBoard.level];
    self.jsonData       = [thePlayBoard jsonDataDescription];
    self.volNumber      = thePlayBoard.volNumber;
    self.gotFromNetwork = [NSNumber numberWithBool:YES];
}

-(BOOL)isFirstLevel{
    if ([self.level isEqualToNumber:[NSNumber numberWithInt:1]]) {
        return YES;
    }else{
        return NO;
    }
}
-(void)setLock{
    //如果是第一关，那么是解锁的，如果上一关已经解锁，那么解锁
    if ([self isFirstLevel]) {
        self.islocked = [NSNumber numberWithBool:NO];
    }else{
        self.islocked = [NSNumber numberWithBool:YES];
    }
}

//通过volNumber来获取一堆PlayBoards
+(NSArray *)cdPlayBoardsByVolNumber:(NSNumber *)volNumber
             inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:@"CDPlayBoard" inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(volNumber = %d)", [volNumber intValue]];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"level" ascending:YES];//根据level排序，很重要！
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"查询volNumber == %@ 的CDPlayBoards 出错 ",volNumber);
        return nil;
    }else if([array count] == 0){
        NSLog(@"没有volNumber == %@ 的CDPlayBoards",volNumber);
        return nil;
    }else{
        return array;
    }
}



//将PlayBoard保存到数据库中,根据vol_number和level来修改
+(void)inserToDatabaseWithPlayBoard:(PlayBoard *)thePlayBoard
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CDPlayBoard" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"volNumber = %d AND level = %d",
                              [thePlayBoard.volNumber intValue],thePlayBoard.level];
    
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil || [array count] > 1) {
        NSLog(@"【error】读取数据库操作%@ 或者uniqueid 不唯一" ,error);
    }else if ([array count] == 1) {
        CDPlayBoard *cdpb = [array firstObject];
        if ([cdpb.gotFromNetwork isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSLog(@"库有 vol=%@ lv=%d的棋盘格,对其进行修改",thePlayBoard.volNumber,thePlayBoard.level);
        }else{
            NSLog(@"库仅有 初始化的 vol=%@ lv=%d的棋盘格,对其进行修改",thePlayBoard.volNumber,thePlayBoard.level);
        }
        [cdpb setAttributesWithPlayBoard:thePlayBoard];
        //如果库中已经有了，就不需要修改了belongToWhom了
        BOOL isSaveSuccess = [context save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error: %@,%@",error,[error userInfo]);
        }else {
            NSLog(@"修改 uniqueid = %@ 的棋盘格成功",thePlayBoard.uniqueid);
        }
    }else{
        NSLog(@"错误，棋盘未初始化");
//        NSLog(@"库中没有uniqueid = %@ 的棋盘格,新创建并插入",thePlayBoard.uniqueid);
//        CDPlayBoard *cdpb = [NSEntityDescription insertNewObjectForEntityForName:@"CDPlayBoard"
//                                                          inManagedObjectContext:context];
//        [cdpb setAttributesWithPlayBoard:thePlayBoard];
//        cdpb.belongToWhom   = [CDVol cdVolWithUniqueVolNumber:thePlayBoard.volNumber
//                                       inManagedObjectContext:context];
//        
//        BOOL isSaveSuccess = [context save:&error];
//        if (!isSaveSuccess) {
//            NSLog(@"Error: %@,%@",error,[error userInfo]);
//        }else {
//            NSLog(@"插入新的uniqueid = %@ 的棋盘格",thePlayBoard.uniqueid);
//        }
    }
}

//通过vol_number和level获取CDPlayBoard，如果没有，本地做初始化
+(CDPlayBoard *)cdPlayBoardByVolNumber:(NSNumber *)vol_number
                              andLevel:(NSNumber *)level
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CDPlayBoard" inManagedObjectContext:context];
    [request setEntity:entity];
    
    /****************设置数据库查询的条件**************/
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"volNumber = %d AND level = %d", [vol_number intValue],[level intValue]];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil){
        NSLog(@"查询数据库错误 【CDPlayboard】 with vol=%@ and level=%@ indatabase",vol_number,level);
        return nil;
    }else if ([array count] > 1) {
        NSLog(@"查询数据库错误 More than 1 CDPlayboard with vol=%@ level = %@ in database",vol_number,level);
        return nil;
    }else if ([array count] == 0){
        NSLog(@"数据库中没有cdplayboard with vol_no = %@ and level = %@ in local database，本地做初始化",vol_number,level);
        CDPlayBoard *cdpb = [NSEntityDescription insertNewObjectForEntityForName:@"CDPlayBoard"
                                                          inManagedObjectContext:context];
        cdpb.level          = level;
        cdpb.volNumber      = vol_number;
        cdpb.star           = [NSNumber numberWithInt:0];
        [cdpb setLock];         //目前的规则是：如果是第一关，那么设置为解锁的
        cdpb.gotFromNetwork = [NSNumber numberWithBool:NO];//本地初始化不是从网络获取来的
        return cdpb;
    }else{
        return [array firstObject];
    }
}

//通过id查询CDPlayBoard
+(CDPlayBoard *)cdPlayBoardByUniqueID:(NSNumber *)uniqueID
               inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CDPlayBoard" inManagedObjectContext:context];

    [request setEntity:entity];
    
    /****************设置数据库查询的条件**************/
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uniqueid = %d)", [uniqueID intValue]];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"%@",array);
    }
    CDPlayBoard *copyPlayBoard = [array firstObject];
    return copyPlayBoard;
}

//实例的打印信息
-(NSString *)description{
    NSMutableString *retString = [[NSMutableString alloc]init];
    
    [retString appendString:[NSString stringWithFormat:@"level = %@\n",self.level]];
    [retString appendString:[NSString stringWithFormat:@"star = %@\n",self.star]];
    [retString appendString:[NSString stringWithFormat:@"islocked = %@\n",self.islocked]];
    [retString appendString:[NSString stringWithFormat:@"volNumber = %@\n",self.volNumber]];
    [retString appendString:[NSString stringWithFormat:@"gotFromNetwork = %@\n",self.gotFromNetwork]];

    return retString;
}

@end
