//
//  GWNetWorkWrapper.m
//  GuessWord
//
//  Created by Dannion on 13-12-16.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWNetWorkingWrapper.h"

#define kGWBaseUrlString @"http://10.105.223.24//"

@implementation GWNetWorkingWrapper

+ (void)getPath:(NSString *)path
                   parameters:(NSDictionary *)parameters
                 successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                 failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kGWBaseUrlString]];
    
    NSMutableURLRequest* request =[client requestWithMethod:@"GET" path:path parameters:parameters];
    NSLog(@"%@", request);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:successBlock failure:failureBlock];
    [operation start];
}


@end
