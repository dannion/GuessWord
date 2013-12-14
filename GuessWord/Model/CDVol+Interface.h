//
//  CDVol+Interface.h
//  GuessWord
//
//  Created by WangJZ on 12/13/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//


#define KEY_FOR_UNIQUENUMBER    @"vol_no"
#define KEY_FOR_NAME            @"name"
#define KEY_FOR_NUMBERLEVELS    @"levels_no"
#define KEY_FOR_OPENDATE        @"opendate"


#import "CDVol.h"

@interface CDVol (Interface)

//通过VolDictionary创建CDVol
+(CDVol *)CDVolWithVolDictionary:(NSDictionary *)VolDictionary
          inManagedObjectContext:(NSManagedObjectContext *)context;

//通过唯一的ID获取CDVol或者创建CDVol
+(CDVol *)CDVolWithUniqueVolNumber:(NSNumber *)uniqueVolNumber
            inManagedObjectContext:(NSManagedObjectContext *)context;


@end
