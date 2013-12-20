//
//  DatabaseGenerator.m
//  GuessWord
//
//  Created by WangJZ on 12/20/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "DatabaseGenerator.h"
#import "PlayBoard.h"
#import "CDVol+Interface.h"
#import "GWAppDelegate.h"

@implementation DatabaseGenerator
//将 CDPlayBoards    的信息导入到数据库
+(void)importCDPlayBoardsToDatabaseWithFile:(NSString *)file{
    NSString *js_file_path = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:js_file_path];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil){
        if (![jsonObject isKindOfClass:[NSArray class]]) {
            NSLog(@"Json数据错误");
        }
        NSArray *playBoards_array = (NSArray *)jsonObject;
        for (NSDictionary *one_board_dic in playBoards_array) {
            NSError *error = nil;
            NSData *jsData = [NSJSONSerialization dataWithJSONObject:one_board_dic options:NSJSONWritingPrettyPrinted error:&error];
            PlayBoard *pb = [PlayBoard playBoardFromData:jsData];
            [pb saveToDataBaseWithFinalScore:0];
        }
    }
}
//将 CDPlayBoards    的信息导入到数据库
+(void)importCDVolsToDatabaseWithFile:(NSString *)file{
//    NSString *js_file_path = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
//    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:js_file_path];
//    
//    NSError *error = nil;
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
//    if (jsonObject != nil && error == nil){
//        if (![jsonObject isKindOfClass:[NSArray class]]) {
//            NSLog(@"Json数据错误");
//        }
//        NSArray *cdVols_array = (NSArray *)jsonObject;
//        for (NSDictionary *one_vol_dic in cdVols_array) {
//            CDVol *oneVol = [CDVol cdVolsWithJsonData:<#(NSData *)#> inManagedObjectContext:<#(NSManagedObjectContext *)#>];
//            NSError *error = nil;
//            NSData *jsData = [NSJSONSerialization dataWithJSONObject:one_board_dic options:NSJSONWritingPrettyPrinted error:&error];
//            PlayBoard *pb = [PlayBoard playBoardFromData:jsData];
//            [pb saveToDataBaseWithFinalScore:0];
//        }
//    }
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    [CDVol cdVolsFromFile:file inManagedObjectContext:context];
}

@end
