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
+(PlayBoard *)playBoardFromCoreDataByBoardNumber:(NSNumber *)BoardNumber{
    CDPlayBoard *cdpb = [CDPlayBoard CDPlayBoardByNumber:BoardNumber];
    return [[PlayBoard alloc]initWithJsonData:cdpb.jsonData];
}

+(PlayBoard *)playBoardFromData:(NSData *)jsonData{
    return [[PlayBoard alloc]initWithJsonData:jsonData];
}

+(void)savePlayBoardToDatabase:(PlayBoard *)thePlayBoard
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    [CDPlayBoard inserToDatabaseWithPlayBoard:thePlayBoard inManagedObjectContext:context];
    //[thePlayBoard saveToFile:@"tg.json"];
}

+(PlayBoard *)playBoardFromFile:(NSString *)file{
    NSString *js_file_path = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:js_file_path];
    return [PlayBoardHelper playBoardFromData:jsonData];
}
@end
