//
//  GWAccountStore.m
//  GuessWord
//
//  Created by Dannion on 13-12-20.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWAccountStore.h"


@implementation GWAccountStore

+ (GWAccountStore *)shareStore
{
    static GWAccountStore *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GWAccountStore alloc] init];
    });
    return instance;
}

- (void)saveToLocalCacheWithUsername:(NSString*)username andPassword:(NSString*)password
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:username forKey:@"username"];
    [userDefaults setObject:password forKey:@"password"];
    [userDefaults setBool:YES forKey:@"hasLogined"];
    
    [userDefaults synchronize];
}

- (BOOL)hasLogined
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [userDefaults boolForKey:@"hasLogined"];
}

- (NSDictionary*)currentAccount//后续应该改为用gwaccount类去存取，而不是nsdictionary.
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary* currentAccount = [NSMutableDictionary dictionary];
    [currentAccount setObject:[userDefaults stringForKey:@"username"] forKey:@"username"];
    [currentAccount setObject:[userDefaults stringForKey:@"password"] forKey:@"password"];
    
    return currentAccount;
}

@end