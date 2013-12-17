//
//  CDVol+Interface.m
//  GuessWord
//
//  Created by WangJZ on 12/13/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "CDVol+Interface.h"
#import "GWAppDelegate.h"

@implementation CDVol (Interface)


#warning 测试用，后期删掉
+(NSArray *)cdvolArray
{
    NSMutableArray *retArray = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        NSString *name = [NSString stringWithFormat:@"第%d期",i];
        NSNumber *uniqueNumber = [NSNumber numberWithInt:100+i];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *opendata = [NSDate date];
        NSString *formattedDateString = [dateFormatter stringFromDate:opendata];
        
        NSNumber *amount = [NSNumber numberWithInt:10+i];

        NSDictionary *oneDic = @{KEY_FOR_UNIQUENUMBER:uniqueNumber,
                                   KEY_FOR_NAME:name,
                                   KEY_FOR_OPENDATE:formattedDateString,
                                   KEY_FOR_AMOUNTLEVELS:amount};
        [retArray addObject:oneDic];
    }
    return retArray;
}
#warning 测试用，后期删掉
+(void)saveArrayToFile:(NSString *)saveFile withArray:(NSArray *)array
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *file = [documentDirectory stringByAppendingPathComponent:saveFile];
    
    NSError *error = nil;
    NSData *jsData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"dic->%@",error);
    }
    if (jsData) {
        BOOL succeed = [jsData writeToFile:file atomically:YES];
        if (succeed) {
            NSLog(@"Save succeed");
        }else {
            NSLog(@"Save fail");
        }
    }
}

-(void)saveToFile:(NSString *)saveFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *file = [documentDirectory stringByAppendingPathComponent:saveFile];

    //生成时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    NSDate *opendata = [NSDate date];
    NSString *formattedDateString = [dateFormatter stringFromDate:opendata];

    NSDictionary *cdVolDic = @{KEY_FOR_UNIQUENUMBER:self.uniqueVolNumber,
                              KEY_FOR_NAME:@"第一期",
                               KEY_FOR_OPENDATE:formattedDateString,
                              KEY_FOR_AMOUNTLEVELS:self.amountOfLevels};
    NSError *error = nil;
    NSData *jsData = [NSJSONSerialization dataWithJSONObject:cdVolDic options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"dic->%@",error);
    }
    if (jsData) {
        BOOL succeed = [jsData writeToFile:file atomically:YES];
        if (succeed) {
            NSLog(@"Save succeed");
        }else {
            NSLog(@"Save fail");
        }
    }
}

/*创建CDVol:根据Dictionary来查找CDVol，如果库中有，取出，如果没有，创建并返回创建后的CDVol*/
+(CDVol *)CDVolWithVolDictionary:(NSDictionary *)volDictionary
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    CDVol *vol = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDVol"];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1))  {
        //handle error
    }else if (![matches count]){
        NSLog(@"数据库中没有的%@的CDVol，插入",volDictionary );
        vol = [NSEntityDescription insertNewObjectForEntityForName:@"CDVol"
                                            inManagedObjectContext:context];
        
        vol.uniqueVolNumber     = [volDictionary objectForKey:KEY_FOR_UNIQUENUMBER];
        vol.name                = [volDictionary objectForKey:KEY_FOR_NAME];
#warning 这里open_date是一个NSDate类型的变量
        vol.open_date           = [volDictionary objectForKey:KEY_FOR_OPENDATE];
        vol.amountOfLevels      = [volDictionary objectForKey:KEY_FOR_AMOUNTLEVELS];
        
    }else{
        vol = [matches firstObject];
    }
    
    return vol;
}

/*根据uniqueVolNumber来查找CDVol，如果库中有，取出，如果没有，创建并返回创建后CDVol*/
+(CDVol *)CDVolWithUniqueVolNumber:(NSNumber *)uniqueVolNumber
            inManagedObjectContext:(NSManagedObjectContext *)context
{

    CDVol *vol = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDVol"];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1))  {
        //handle error
    }else if (![matches count]){
#warning 就目前的需求来看，此处不应该有插入操作
        NSLog(@"数据库中没有uniqueVolNumber == %@ 的CDVol，插入",uniqueVolNumber);
        vol = [NSEntityDescription insertNewObjectForEntityForName:@"CDVol"
                                            inManagedObjectContext:context];
        vol.uniqueVolNumber = uniqueVolNumber;
    }else{
        vol = [matches firstObject];
    }
    return vol;
}
@end
