//
//  PlayBoardHelper.m
//  GuessWord
//
//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "PlayBoardHelper.h"
#import "CDPlayBoard+Interface.h"

@implementation PlayBoardHelper

//通过BoardNumber生成一个PlayBoard
+(PlayBoard *)playBoardFromLocalDatabaseByUniqueID:(NSNumber *)uniqueID{
    CDPlayBoard *cdpb = [CDPlayBoard CDPlayBoardByUniqueID:uniqueID];
    if (cdpb) {
        return [[PlayBoard alloc]initWithJsonData:cdpb.jsonData];
    }else{
        return nil;
    }
}
    

+(PlayBoard *)playBoardFromData:(NSData *)jsonData{
    return [[PlayBoard alloc]initWithJsonData:jsonData];
}

+(void)insertPlayBoardToDatabase:(PlayBoard *)thePlayBoard
{
    [CDPlayBoard inserToDatabaseWithPlayBoard:thePlayBoard];
    //[thePlayBoard saveToFile:@"tg.json"];
}

+(PlayBoard *)playBoardFromFile:(NSString *)file{
    NSString *js_file_path = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:js_file_path];
    return [PlayBoardHelper playBoardFromData:jsonData];
}
@end
