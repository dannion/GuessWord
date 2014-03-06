//
//  NewBoard.m
//  GuessWord
//
//  Created by WangJZ on 3/5/14.
//  Copyright (c) 2014 BUPTMITC. All rights reserved.
//

#import "NewBoard.h"
#import "NewBoardCell.h"
#import "NewWord.h"
#import "GWAppDelegate.h"
#import "CDPlayBoard+Interface.h"

@implementation NewBoard

#pragma mark --
#pragma mark Generators

//在数据库中找到所有该volNumber的 playBoards
+(NSArray *)playBoardsFromLocalDatabaseVolNumber:(NSNumber *)volNumber
{
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSArray *cdpbs = [CDPlayBoard cdPlayBoardsByVolNumber:volNumber inManagedObjectContext:context];
    if (cdpbs == nil) {
        return nil;
    }else{
        NSMutableArray *playBoardsArray = [[NSMutableArray alloc]initWithCapacity:40];
        for (CDPlayBoard *onecdpb in cdpbs) {
            if ([onecdpb.gotFromNetwork isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                NewBoard *pb = [[NewBoard alloc]initWithJsonData:onecdpb.jsonData];
                [playBoardsArray addObject:pb];
            }
        }
        return playBoardsArray;
    }
}

+(NewBoard *)playBoardFromFile:(NSString *)file{
    NSString *js_file_path = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:js_file_path];
    return [NewBoard playBoardFromData:jsonData];
}

+(NewBoard *)playBoardFromData:(NSData *)jsonData{
    if (!jsonData) {
        return nil;
    }else{
        return [[NewBoard alloc]initWithJsonData:jsonData];
    }
}

/*通过X期和Y关来获取PlayBoard*/
+(NewBoard *)newBoardFromLocalDataBaseByVolNumber:(NSNumber *)vol_number
                                         andLevel:(NSNumber *)level
{
    NewBoard *retPlayBoard = nil;
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    CDPlayBoard *cdpb = [CDPlayBoard cdPlayBoardByVolNumber:vol_number andLevel:level
                                     inManagedObjectContext:context];
    if (cdpb) {
        if ([cdpb.gotFromNetwork isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            retPlayBoard = [[NewBoard alloc]initWithJsonData:cdpb.jsonData];
        }
    }
    return retPlayBoard;
}

#pragma mark --
#pragma mark Lazy Instance Cells
-(NSMutableArray *)cellsByLazyInstance
{
    //初始化各种area，使用Lazy instance,初始化都为BLOCK
    int i,j;
    NSMutableArray *theCells = [[NSMutableArray alloc]init];
    //一行是一个数组，再把所有行放进一个数组，所以用的时候是cells[y][x]
    for (j = 0; j < self.height; j++) {
        NSMutableArray *column_array = [[NSMutableArray alloc]initWithCapacity:10];
        for (i = 0; i < self.width; i++) {
            NewBoardCell *cell = [[NewBoardCell alloc]init];
            //设定坐标
            cell.y = j;
            cell.x = i;
            [cell setToBlock];
            [column_array addObject:cell];
        }
        [theCells addObject:column_array];
    }
    return theCells;
}

-(NSMutableArray *)cells
{
    if (! _cells) _cells = [self cellsByLazyInstance];
    return _cells;
}

#pragma mark --
#pragma mark Data Convert
-(NSData *)jsonDataDescription{

    NSMutableArray *description = [[NSMutableArray alloc]initWithCapacity:50];
    NSMutableArray *explanation = [[NSMutableArray alloc]initWithCapacity:50];
    NSMutableArray *words = [[NSMutableArray alloc]initWithCapacity:50];

    //以每一个单词为单位进行书写
    for (NewWord *aWord in self.words) {
        [description addObject:[aWord jsonDicOfDescriptions]];
        [explanation addObject:[aWord jsonDicOfExplanations]];
        [words addObjectsFromArray:[aWord itemsOfCharacters]];
    }
    
#warning 棋盘添加字段位置2
    //局面写入一个字典
    NSDictionary *dictionary = @{@"star"        :self.star,
                                 @"file"        :self.file                        == nil ? @"":self.file,
                                 @"category"    :self.category                    == nil ? @"":self.category,
                                 @"uniqueid"    :self.uniqueid,
                                 @"volNumber"   :self.volNumber,
                                 @"islocked"        :[NSNumber  numberWithBool:self.islocked],
                                 @"date"        :self.date                        == nil ? @"":self.date,
                                 @"gamename"    :self.gamename                    == nil ? @"":self.gamename,
                                 @"author"      :self.author                      == nil ? @"":self.author,
                                 @"degree"      :[NSNumber numberWithInt:self.degree],
                                 @"score"       :[NSNumber numberWithInt:self.score],
                                 @"percent"     :[NSNumber numberWithInt:self.percent],
                                 @"level"       :[NSNumber numberWithInt:self.level],
                                 @"width"       :[NSNumber numberWithInt:self.width],
                                 @"height"      :[NSNumber numberWithInt:self.height],
                                 @"words"       :words,
                                 @"descriptions":description,
                                 @"explanations":explanation
                                 };
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"dic->%@",error);
        return nil;
    }else{
        return jsonData;
    }
}
/*指定的初始化函数,通过json的二进制数据来构造对象*/
-(NewBoard *)initWithJsonData:(NSData *)jsonData{
    self = [super init];
    if (self) {
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (jsonObject != nil && error == nil){
            if (![jsonObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"Json数据错误");
                return nil;
            }
            NSDictionary *playBoardDic = (NSDictionary *)jsonObject;
            
            /*********解析基础数据*********/
            self.star       = [playBoardDic objectForKey:@"star"];
            self.islocked   = [[playBoardDic objectForKey:@"islocked"] boolValue];//该棋盘是否已经解锁
            self.file       = [playBoardDic objectForKey:@"file"];
            self.uniqueid   = [playBoardDic objectForKey:@"uniqueid"];
            self.volNumber  = [playBoardDic objectForKey:@"volNumber"];
            self.category   = [playBoardDic objectForKey:@"category"];
            self.date       = [playBoardDic objectForKey:@"date"];
            self.gamename   = [playBoardDic objectForKey:@"gamename"];
            self.author     = [playBoardDic objectForKey:@"author"];
            self.degree     = [(NSNumber *)[playBoardDic objectForKey:@"degree"] intValue];
            self.score      = [(NSNumber *)[playBoardDic objectForKey:@"score"] intValue];
            self.percent    = [(NSNumber *)[playBoardDic objectForKey:@"percent"] intValue];
            self.level      = [(NSNumber *)[playBoardDic objectForKey:@"level"] intValue];
            self.width      = [(NSNumber *)[playBoardDic objectForKey:@"width"] intValue];
            self.height     = [(NSNumber *)[playBoardDic objectForKey:@"height"] intValue];
            
            /*****************解析每一个description***************/
            NSArray *descriptions = [playBoardDic objectForKey:@"descriptions"];
            NSMutableArray *output_words = [[NSMutableArray alloc]initWithCapacity:50];
            for (NSDictionary *aDespDic in descriptions) {
                NewWord *tmpWord = [[NewWord alloc]init];
                tmpWord.firstLevelDescription       = [aDespDic objectForKey:@"desc"];
                tmpWord.secondLevelDescription      = [aDespDic objectForKey:@"desc2"];
                tmpWord.indexID                     = [[aDespDic objectForKey:@"to"] intValue];

                [output_words addObject:tmpWord];
            }
            self.words = output_words;
            /********************解析explanation*************/
            NSArray *exp = [playBoardDic objectForKey:@"explanations"];
            for (NSDictionary *aExp in exp) {
                int index = [[aExp objectForKey:@"to"] intValue];
                [(NewWord *)self.words[index-1] setExplanation:[aExp objectForKey:@"exp"]];
            }
            
            /********************解析words*************/
            NSArray *charDic = [playBoardDic objectForKey:@"words"];
            for (NSDictionary *newChar in charDic) {
                //（1）设置cell （2）设置cell上的多个GWCharacter（2）关联cell和word
//                {"cap":"Y","chi":"烟","x":4,"y":1,"temp":"-","i":1,"j":1}
                int x = [[newChar objectForKey:@"x"] intValue];
                int y = [[newChar objectForKey:@"y"] intValue];
                int wordIndex = [[newChar objectForKey:@"i"] intValue];
                int positionInWord = [[newChar objectForKey:@"j"] intValue];
                NSString *correct_answer = [newChar objectForKey:@"cap"];
                NSString *chinese = [newChar objectForKey:@"chi"];
                NSString *temp = [newChar objectForKey:@"temp"];
                NewBoardCell *curCell = (NewBoardCell *)self.cells[y][x];
                GWCharacter *curChar = [[GWCharacter alloc]init];
                curChar.wordIndex = wordIndex;
                curChar.positionInWord = positionInWord;
                curChar.correct_answer = correct_answer;
                [curCell.gwChars addObject:curChar];//将新的Char添加到数组中
                curCell.input =[temp isEqualToString:@""] ? BLANK:temp;//设置cell
                curCell.chinese = chinese;
                NewWord *curWord = self.words[wordIndex - 1];//从0开始的
                [curWord.coveredCells addObject:curCell];//关联cell与word，如果重复，会自动去掉
            }
            /************更新所有单词的状态************/
            for (NewWord *word in self.words) {
                [word updateCellsState];
            }
        }
    }
    return self;
}

//计算星级，目前根据单词的完成度来计算单词
-(NSNumber *)starFromStarCalculator
{
    int amount_of_words     = [self.words count];
    int amount_of_correct   = 0;
    for (NewWord *aWord in self.words) {
        if ([aWord isBingo]) {
            amount_of_correct += 1;
        }
    }
    float rate = (float)amount_of_correct / (float)amount_of_words;
    if (rate == 1) {
        return [NSNumber numberWithInt:3];
    }else if(rate < 1 && rate >= 0.33){
        return [NSNumber numberWithInt:2];
    }else if(rate < 0.33 && rate > 0){
        return [NSNumber numberWithInt:1];
    }else{
        return [NSNumber numberWithInt:0];
    }
}

//为了打印输出查看结果
-(NSString*)description
{
    NSMutableString *retString = [[NSMutableString alloc]init];
    [retString appendString:[NSString stringWithFormat:@"\n[PlayBoard]\ncategory = %@\n",self.category]];
    [retString appendString:[NSString stringWithFormat:@"uniqueID = %@\n",self.uniqueid]];
    [retString appendString:[NSString stringWithFormat:@"isLocked = %d\n",self.islocked]];
    [retString appendString:[NSString stringWithFormat:@"volNumber = %@\n",self.volNumber]];
    [retString appendString:[NSString stringWithFormat:@"score = %d\n",self.score]];
    [retString appendString:[NSString stringWithFormat:@"star = %@\n",self.star]];
    
    [retString appendString:@"[Correct]\n"];
    for (NSArray *row_array in self.cells) {
        for (NewBoardCell *cell in row_array) {
            //            [retString appendString:cell.correct];
            [retString appendString:[cell stringOfCorrectAnswers]];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    [retString appendString:@"[Input]\n"];
    for (NSArray *row_array in self.cells) {
        for (NewBoardCell *cell in row_array) {
            [retString appendString:cell.input];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    [retString appendString:@"[Display]\n"];
    for (NSArray *row_array in self.cells) {
        for (NewBoardCell *cell in row_array) {
            [retString appendString:cell.display];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    for (NSArray *row_array in self.cells) {
        for (NewBoardCell *cell in row_array) {
            [retString appendString:[NSString stringWithFormat:@"%d",cell.currentState]];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    return retString;
}

-(void)saveToDataBaseWithFinalScore:(int)finalScore
{
    self.score = finalScore;//设置得分
    self.star = [self starFromStarCalculator];//设置星级
    
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    [CDPlayBoard inserToDatabaseWithPlayBoard:self inManagedObjectContext:context];
}


/*获取某个坐标上的boardcel*/
-(NewBoardCell *)cellAtPoint:(CGPoint)point{
    int x = (int)point.x;
    int y = (int)point.y;
    return self.cells[y][x];
}


/*根据一个点周围cells的状态*/
-(void)updateCellsDisplayByPoint:(CGPoint)point{
    //根据点找到对应的所有单词，根据每一个单词的来更新其cells状态
    NSArray *wordsAtThisPoint = [self wordsOfPoint:point];
    for (NewWord *word in wordsAtThisPoint) {
        [word updateCellsState];
    }
}

#warning 下一个点返回在哪有待商榷
/*在某个坐标上输入一个字母，修改cell.Input*/
-(CGPoint)nextPointByUpdatingBoardWithInputValue:(NSString *)oneAlphabet atPoint:(CGPoint)point
{
    int x = (int)point.x;
    int y = (int)point.y;
    
    //更新cells的状态
    NewBoardCell *cell = self.cells[y][x];
    if (![cell isCellBlock] && ![cell isCellDone]) {
        cell.input = oneAlphabet;
        [self updateCellsDisplayByPoint:point];
    }
#warning 暂时没有实现这个部分
    return point;
}

/*是否闯关成功*/
-(BOOL)isGameBoardCompleted{
    //遍历所有单词，只要其中有一个单词没有完成，那么就返回未完成
    for (NewWord *aWord in self.words) {
        if (![aWord isBingo]) {
            return NO;
        }
    }
    return YES;
}

/*判断该点是否能够点击*/
-(BOOL)isClickableAtPoint:(CGPoint)point{
    int x = (int)point.x;
    int y = (int)point.y;
    if ([(NewBoardCell *)self.cells[y][x] isCellBlock]) {
        return NO;
    }else{
        return YES;
    }
}

/*重置棋盘*/
-(void)resetBoard{
    for (NSArray *rowArray in self.cells) {
        for (NewBoardCell *nbc in rowArray) {
            [nbc reset];
        }
    }
}

//获得该point上所有的单词
-(NSArray *)wordsOfPoint:(CGPoint)point
{
    NSMutableArray *retArray = [[NSMutableArray alloc]init];
    int x = (int)point.x;
    int y = (int)point.y;
    //当前这个点的cell的所有的单词index，根据index遍历word
    NewBoardCell *currentCell = self.cells[y][x];
    for (GWCharacter *curChar in currentCell.gwChars) {
        for (NewWord *word in self.words) {
            if (curChar.wordIndex == word.indexID) {
                [retArray addObject:word];
            }
        }
    }
    
    return retArray;
}

@end
