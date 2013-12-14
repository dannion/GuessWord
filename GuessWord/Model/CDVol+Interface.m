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
        vol.open_date           = [volDictionary objectForKey:KEY_FOR_OPENDATE];
        vol.numberOfLevels      = [volDictionary objectForKey:KEY_FOR_NUMBERLEVELS];
        
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
