//
//  GWAccountStore.h
//  GuessWord
//
//  Created by Dannion on 13-12-20.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWAccountStore : NSObject

+ (GWAccountStore*)shareStore;

- (void)saveToLocalCacheWithUsername:(NSString*)username andPassword:(NSString*)password;

- (BOOL)hasLogined;

- (NSDictionary*)currentAccount;//后续应该改为用gwaccount类去存取，而不是nsdictionary.

@end
