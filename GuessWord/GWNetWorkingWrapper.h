//
//  GWNetWorkWrapper.h
//  GuessWord
//
//  Created by Dannion on 13-12-16.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWNetWorkingWrapper : NSObject

+ (void)getPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
                 successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                 failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

@end
