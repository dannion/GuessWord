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


//#warning 测试用，后期删掉
//+(NSArray *)cdvolArray
//{
//    NSMutableArray *retArray = [[NSMutableArray alloc]init];
//    for (int i=0; i<3; i++) {
//        NSString *name = [NSString stringWithFormat:@"第%d期",i];
//        NSNumber *uniqueNumber = [NSNumber numberWithInt:100+i];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate *opendata = [NSDate date];
//        NSString *formattedDateString = [dateFormatter stringFromDate:opendata];
//        
//        NSNumber *amount = [NSNumber numberWithInt:10+i];
//
//        NSDictionary *oneDic = @{KEY_FOR_UNIQUENUMBER:uniqueNumber,
//                                   KEY_FOR_NAME:name,
//                                   KEY_FOR_OPENDATE:formattedDateString,
//                                   KEY_FOR_AMOUNTLEVELS:amount};
//        [retArray addObject:oneDic];
//    }
//    return retArray;
//}
//#warning 测试用，后期删掉
//+(void)saveArrayToFile:(NSString *)saveFile withArray:(NSArray *)array
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString *file = [documentDirectory stringByAppendingPathComponent:saveFile];
//    
//    NSError *error = nil;
//    NSData *jsData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
//    if (error) {
//        NSLog(@"dic->%@",error);
//    }
//    if (jsData) {
//        BOOL succeed = [jsData writeToFile:file atomically:YES];
//        if (succeed) {
//            NSLog(@"Save succeed");
//        }else {
//            NSLog(@"Save fail");
//        }
//    }
//}
//
//-(void)saveToFile:(NSString *)saveFile{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString *file = [documentDirectory stringByAppendingPathComponent:saveFile];
//
//    //生成时间
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
////    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
//    NSDate *opendata = [NSDate date];
//    NSString *formattedDateString = [dateFormatter stringFromDate:opendata];
//
//    NSDictionary *cdVolDic = @{KEY_FOR_UNIQUENUMBER:self.uniqueVolNumber,
//                              KEY_FOR_NAME:@"第一期",
//                               KEY_FOR_OPENDATE:formattedDateString,
//                              KEY_FOR_AMOUNTLEVELS:self.amountOfLevels};
//    NSError *error = nil;
//    NSData *jsData = [NSJSONSerialization dataWithJSONObject:cdVolDic options:NSJSONWritingPrettyPrinted error:&error];
//    if (error) {
//        NSLog(@"dic->%@",error);
//    }
//    if (jsData) {
//        BOOL succeed = [jsData writeToFile:file atomically:YES];
//        if (succeed) {
//            NSLog(@"Save succeed");
//        }else {
//            NSLog(@"Save fail");
//        }
//    }
//}

//通过文件获取cdVols数组
+(NSArray *)cdVolsFromFile:(NSString *)file
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSString *js_file_path = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:js_file_path];
    return [CDVol cdVolsWithJsonData:jsonData inManagedObjectContext:context];
}

//通过jsonData获取cdVols数组
+(NSArray *)cdVolsWithJsonData:(NSData *)jsonData
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil){
        assert([jsonObject isKindOfClass:[NSArray class]]);
        NSArray *array = (NSArray *)jsonObject;
        return [CDVol cdVolsWithVolArrary:array inManagedObjectContext:context];
    }else{
        return nil;
    }
}

//根据数组数组返回一组CDVol
+(NSArray *)cdVolsWithVolArrary:(NSArray *)volArray
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableArray *retArray = [[NSMutableArray alloc]init];
    for (NSDictionary *volDic in volArray) {
        CDVol *oneVol = [CDVol cdVolWithVolDictionary:volDic inManagedObjectContext:context];
        [retArray addObject:oneVol];
    }
    return retArray;
}

/*创建CDVol:根据Dictionary来查找CDVol，如果库中有，取出，如果没有，创建并返回创建后的CDVol*/
+(CDVol *)cdVolWithVolDictionary:(NSDictionary *)volDictionary
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    CDVol *vol = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDVol"];
    NSNumber *uniqueVolNumber = [volDictionary objectForKey:KEY_FOR_UNIQUENUMBER];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uniqueVolNumber = %d)", [uniqueVolNumber intValue]];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1))  {
        //handle error
    }else if (![matches count]){
        NSLog(@"数据库中没有uniqueVolNumber == %@ 的CDVol，插入",uniqueVolNumber);
        vol = [NSEntityDescription insertNewObjectForEntityForName:@"CDVol"
                                            inManagedObjectContext:context];
        vol.uniqueVolNumber     = [volDictionary objectForKey:KEY_FOR_UNIQUENUMBER];
        vol.name                = [volDictionary objectForKey:KEY_FOR_NAME];
        
#warning 应该用dateString来转换成NSDate对象，目前没有做
        NSString *dateString = [volDictionary objectForKey:KEY_FOR_OPENDATE];
        NSDateComponents *comps = [[NSDateComponents alloc]init];
        [comps setMonth:01];
        [comps setDay:31];
        [comps setYear:2013];
        [comps setHour:10];
        
#warning ChineseCalendar
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSChineseCalendar];
        NSDate *date = [calendar dateFromComponents:comps];
        vol.open_date           = date;
        vol.amountOfLevels      = [volDictionary objectForKey:KEY_FOR_AMOUNTLEVELS];
        
        NSError *error;
        BOOL succes = [context save:&error];
        if (!succes) {
            NSLog(@"保存CDVol失败%@",error);
        }else{
            NSLog(@"保存CDVol成功");
        }
    }else{
        NSLog(@"数据库中有uniqueVolNumber == %@ 的CDVol,直接返回",uniqueVolNumber);
        vol = [matches firstObject];
    }
    return vol;
}

/*根据uniqueVolNumber来查找CDVol，如果库中有，取出，如果没有，创建并返回创建后CDVol*/
+(CDVol *)cdVolWithUniqueVolNumber:(NSNumber *)uniqueVolNumber
            inManagedObjectContext:(NSManagedObjectContext *)context
{

    CDVol *vol = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDVol"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uniqueVolNumber = %d)", [uniqueVolNumber intValue]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1))  {
        //handle error
    }else if (![matches count]){
        NSLog(@"数据库中没有uniqueVolNumber == %@ 的CDVol，插入",uniqueVolNumber);
        vol = [NSEntityDescription insertNewObjectForEntityForName:@"CDVol"
                                            inManagedObjectContext:context];
        vol.uniqueVolNumber = uniqueVolNumber;
        NSError *error;
        BOOL succes = [context save:&error];
        if (!succes) {
            NSLog(@"保存CDVol失败%@",error);
        }else{
            NSLog(@"保存CDVol成功");
        }
    }else{
        NSLog(@"数据库中有uniqueVolNumber == %@ 的CDVol",uniqueVolNumber);
        vol = [matches firstObject];
    }
    return vol;
}
-(NSString *)description{
    NSMutableString *retString = [[NSMutableString alloc]init];
    [retString appendString:[NSString stringWithFormat:@"name = %@\n",self.name]];
    [retString appendString:[NSString stringWithFormat:@"amount Levels = %@\n",self.amountOfLevels]];
    [retString appendString:[NSString stringWithFormat:@"unique number = %@\n",self.uniqueVolNumber]];
    return retString;
}
@end
