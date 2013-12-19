//
//  CDVol+Interface.h
//  GuessWord
//
//  Created by WangJZ on 12/13/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//


#define KEY_FOR_UNIQUENUMBER    @"vol_no"
#define KEY_FOR_NAME            @"name"
#define KEY_FOR_AMOUNTLEVELS    @"amount_of_levels"
#define KEY_FOR_OPENDATE        @"open_date"

#import "CDVol.h"

@interface CDVol (Interface)

-(NSString *)description;


//通过jsonData获取全部期的数据,cdVols数组
+(NSArray *)cdVolsWithJsonData:(NSData *)jsonData
        inManagedObjectContext:(NSManagedObjectContext *)context;

//通过网络文件获取全部期的数据
+(NSArray *)cdVolsFromFile:(NSString *)file
    inManagedObjectContext:(NSManagedObjectContext *)context;

//通过VolDictionary创建CDVol
+(CDVol *)cdVolWithVolDictionary:(NSDictionary *)VolDictionary
          inManagedObjectContext:(NSManagedObjectContext *)context;

//通过唯一的ID获取CDVol或者创建CDVol
+(CDVol *)cdVolWithUniqueVolNumber:(NSNumber *)uniqueVolNumber
            inManagedObjectContext:(NSManagedObjectContext *)context;

/*将CDVol保存到本地下*/
//-(void)saveToFile:(NSString *)saveFile;


@end
