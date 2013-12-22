//
//  GWAccountStore.h
//  GuessWord
//
//  Created by Dannion on 13-12-20.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWAccount.h"

@interface GWAccountStore : NSObject

+ (GWAccountStore*)shareStore;

- (void)saveToLocalCacheWithUsername:(NSString*)username andPassword:(NSString*)password;

- (BOOL)hasLogined;

- (void)signOut;

- (GWAccount*)currentAccount;

@end
