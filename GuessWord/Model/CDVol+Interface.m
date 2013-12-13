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

+(CDVol *)CDVolWithVolDictionary:(NSDictionary *)VolDictionary
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    CDVol *vol = nil;
    return vol;
}

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
        vol = [NSEntityDescription insertNewObjectForEntityForName:@"CDVol"
                                            inManagedObjectContext:context];
        vol.uniqueVolNumber = uniqueVolNumber;
    }else{
        vol = [matches firstObject];
    }
    return vol;
}
@end
