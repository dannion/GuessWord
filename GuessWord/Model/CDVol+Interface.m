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

//+(CDVol *)CDVolWithUniqueVolNumber:(NSNumber *)uniqueVolNumber{
//    CDVol *vol = nil;
//    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSManagedObjectContext *context = appDelegate.managedObjectContext;
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CDVol"];
//    NSError *error;
//    NSArray *matches = [context executeFetchRequest:request error:&error];
//    if (!matches || ([matches count] > 1))  {
//        //handle error
//    }else if (![matches count]){
//        vol = [NSEntityDescription insertNewObjectForEntityForName:@"CDVol"
//                                            inManagedObjectContext:context];
//        vol.uniqueVolNumber = uniqueVolNumber;
//    }
//}
@end
