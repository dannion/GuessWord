//
//  GWAccount.h
//  GuessWord
//
//  Created by Dannion on 13-12-21.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWAccount : NSObject

@property(nonatomic,strong)NSString *username;

- (GWAccount*)initWithDictionary:(NSDictionary*)dic;

@end
