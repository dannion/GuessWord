//
//  GWAccount.m
//  GuessWord
//
//  Created by Dannion on 13-12-21.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWAccount.h"

@implementation GWAccount

- (GWAccount*)initWithDictionary:(NSDictionary*)dic
{
    self.username = [dic objectForKey:@"username"];
    return self;
}

@end
