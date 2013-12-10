//
//  PlayBoardHelper.m
//  GuessWord
//
//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "PlayBoardHelper.h"

@implementation PlayBoardHelper

+(PlayBoard *)playBoardFromData:(NSData *)jsonData{
    return [[PlayBoard alloc]initWithJsonData:jsonData];
}

+(void)savePlayBoardToDatabase:(PlayBoard *)thePlayBoard{
    [thePlayBoard saveToFile:@"tg.json"];
}

+(PlayBoard *)playBoardFromFile:(NSString *)file{
    NSString *js_file_path = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:js_file_path];
    return [PlayBoardHelper playBoardFromData:jsonData];
}
@end
