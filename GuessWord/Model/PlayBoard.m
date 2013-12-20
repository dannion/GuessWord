//
//
//  【重要信息】
//  从tmp读取input，将input写入文件中的tmp
//  每次输入改变input
//  根据每个word的的坐标找到对应的input和correct，改变display
//
//

#import "PlayBoard.h"
#import "CDPlayBoard+Interface.h"
#import "GWAppDelegate.h"
#import "PowerBoardCell.h"

@interface PlayBoard()

/*********************************私有*************************/

@property(nonatomic,strong)NSMutableArray *cells;

-(void)initPowerBoardCells;                                 //根据tmp信息初始化两个area数组
-(void)updateCellsDisplayByWord:(Word *)word;               //根据一个word更新display
-(BOOL)isBingoOfWord:(Word *)word;                          //查看某个单词是否完成
-(CGPoint)nextPointFromCurrentPoint:(CGPoint)fromPoint;     //找到一个点的下一个点

@end

@implementation PlayBoard

#pragma mark 构造方法
#pragma mark --

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
                PlayBoard *pb = [[PlayBoard alloc]initWithJsonData:onecdpb.jsonData];
                [playBoardsArray addObject:pb];
            }
        }
        return playBoardsArray;
    }
}

/*通过X期和Y关来获取PlayBoard*/
+(PlayBoard *)playBoardFromLocalDataBaseByVolNumber:(NSNumber *)vol_number
                                           andLevel:(NSNumber *)level
{
    PlayBoard *retPlayBoard = nil;
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    CDPlayBoard *cdpb = [CDPlayBoard cdPlayBoardByVolNumber:vol_number andLevel:level inManagedObjectContext:context];
    if (cdpb) {
        if ([cdpb.gotFromNetwork isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            retPlayBoard = [[PlayBoard alloc]initWithJsonData:cdpb.jsonData];
        }
    }
    return retPlayBoard;
}

//通过BoardNumber生成一个PlayBoard,如果不是从网络重新刷新过的，那么不返回值
+(PlayBoard *)playBoardFromLocalDatabaseByUniqueID:(NSNumber *)uniqueID
{
    PlayBoard *retPlayBoard = nil;
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    CDPlayBoard *cdpb = [CDPlayBoard cdPlayBoardByUniqueID:uniqueID inManagedObjectContext:context];
    if (cdpb) {
        if ([cdpb.gotFromNetwork isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            retPlayBoard = [[PlayBoard alloc]initWithJsonData:cdpb.jsonData];
        }
    }
    return retPlayBoard;
}

+(PlayBoard *)playBoardFromData:(NSData *)jsonData{
    if (!jsonData) {
        return nil;
    }else{
        return [[PlayBoard alloc]initWithJsonData:jsonData];
    }
}


+(PlayBoard *)playBoardFromFile:(NSString *)file{
    NSString *js_file_path = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:js_file_path];
    return [PlayBoard playBoardFromData:jsonData];
}

#warning 写入数据库前保证信息完整：包括star，得分等，另外得分情况是不是每一次点击都记录得分
-(void)saveToDataBaseWithFinalScore:(int)finalScore
{
    self.score = finalScore;
    GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    [CDPlayBoard inserToDatabaseWithPlayBoard:self inManagedObjectContext:context];
}

#pragma mark LAZY-INSTANCE
#pragma mark --

-(NSMutableArray *)cellsByLazyInstance
{
    //初始化各种area，使用Lazy instance,初始化都为BLOCK
    int i,j;
    NSMutableArray *theCells = [[NSMutableArray alloc]init];
    for (j = 0; j < self.height; j++) {
        NSMutableArray *column_array = [[NSMutableArray alloc]initWithCapacity:10];
        for (i = 0; i < self.width; i++) {
            PowerBoardCell *cell = [[PowerBoardCell alloc]init];
            cell.input = BLOCK;
//            cell.correct = BLOCK;
//            [cell addCorrectAnswerWithOneAlphabet:BLOCK];
            cell.display = BLOCK;
            cell.currentState = GWGridCellCurrentStateBlock;
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


#pragma mark PUBLIC-API
#pragma mark --

/*重置棋盘*/
-(void)resetBoard{
    for (NSArray *rowArray in self.cells) {
        for (PowerBoardCell *pbc in rowArray) {
            [pbc reset];
        }
    }
}
/*获取某个坐标上的boardcel*/
-(PowerBoardCell *)cellAtPoint:(CGPoint)point{
    int x = (int)point.x;
    int y = (int)point.y;
    return self.cells[y][x];
}

//判断某个点所在单词是否全部输入（不一定正确）
-(BOOL)isFullFillOfWordAtPoint:(CGPoint)point inHorizontalDirection:(BOOL)isHorizontal{
    //先获取当前的点上对应的那两个词
    Word *word = [self wordOfPoint:point inHorizontalDirection:isHorizontal];
    //查看对应的单词是否完成
    if (!word) {
        return NO;
    }
    if ([self isFullFillOfWord:word]) {
        return YES;
    }else{
        return NO;
    }
}

//判断某个点所在单词是否完成
-(BOOL)isBingoOfWordAtPoint:(CGPoint)point inHorizontalDirection:(BOOL)isHorizontal{
    //先获取当前的点上对应的那两个词
    Word *word = [self wordOfPoint:point inHorizontalDirection:isHorizontal];
    //查看对应的单词是否完成
    if (!word) {
        return NO;
    }
    if ([self isBingoOfWord:word]) {
        return YES;
    }else{
        return NO;
    }
}

//返回得到当前应该显示的状态
-(NSArray *)current_state
{
    return self.cells;
}

//根据一个点周围cells的状态
-(void)updateCellsDisplayByPoint:(CGPoint)point{
    Word *h_word = [self wordOfPoint:point inHorizontalDirection:YES];
    if (h_word) {
        [self updateCellsDisplayByWord:h_word];
    }
    Word *v_word = [self wordOfPoint:point inHorizontalDirection:NO];
    if (v_word) {
        [self updateCellsDisplayByWord:v_word];
    }
}


/*判断该点是否能够点击*/
#warning 当前的实现方式看该位置是否是墙，而不考虑是不是有汉字，有待商榷
-(BOOL)isClickableAtPoint:(CGPoint)point{
    int x = (int)point.x;
    int y = (int)point.y;
    PowerBoardCell *cell = self.cells[y][x];
    if ([cell isCellBlock]) {
        return NO;
    }else{
        return YES;
    }
}

/*是否闯关成功*/
-(BOOL)isGameBoardCompleted{
    //遍历所有单词，只要其中有一个单词没有完成，那么就返回未完成
    BOOL completed = YES;
    for (Word *aWord in self.words) {
        if (![self isBingoOfWord:aWord]) {
            completed = NO;
            break;
        }
    }
    return completed;
}

//在某个坐标上输入一个字母，修改cell.Input
-(CGPoint)nextPointByUpdatingBoardWithInputValue:(NSString *)oneAlphabet atPoint:(CGPoint)point
{
    int x = (int)point.x;
    int y = (int)point.y;
 
    //更新cells的状态
    PowerBoardCell *cell = self.cells[y][x];
    if (![cell isCellBlock] && ![cell isCellDone]) {
        cell.input = oneAlphabet;
        [self updateCellsDisplayByPoint:point];
    }
    return [self nextPointFromCurrentPoint:point];
}

//将类转化成json数据
-(NSData *)jsonDataDescription{
    //重点是考虑input的内容写入到tmp字段！！
    
    NSMutableArray *word_writable_array = [[NSMutableArray alloc]initWithCapacity:50];
    
    //将每一个单词写入json格式的数组
    for (Word *aWord in self.words) {
        //从cells中重新构建tmpString
        NSMutableString *tmpString = [[NSMutableString alloc]init];
        int x = aWord.start_x;
        int y = aWord.start_y;
        BOOL isHorizontal = aWord.horizontal;
        for (int i = 0; i< aWord.length; i++) {
            if (isHorizontal) {
                PowerBoardCell *boarCell = self.cells[y][x+i];
                [tmpString appendString:boarCell.input];
            }else{
                PowerBoardCell *boarCell = self.cells[y+i][x];
                [tmpString appendString:boarCell.input];
            }
        }

        NSDictionary *aWordDic = @{@"cap"       :aWord.answer_capital             == nil ? @"":aWord.answer_capital,
                                   @"chi"       :aWord.answer_chinese_character   == nil ? @"":aWord.answer_chinese_character,
                                   @"mask"      :aWord.mask                       == nil ? @"":aWord.mask,
                                   @"desc"      :aWord.description                == nil ? @"":aWord.description,
                                   @"tmp"       :tmpString,
                                   @"horiz"     :aWord.horizontal                 == YES ? [NSNumber numberWithBool:YES]:[NSNumber numberWithBool:NO],
                                   @"x"         :[NSNumber numberWithInt:aWord.start_x],
                                   @"y"         :[NSNumber numberWithInt:aWord.start_y],
                                   @"len"       :[NSNumber numberWithInt:aWord.length]
                                   };
        [word_writable_array addObject:aWordDic];
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
                                 @"words"       :word_writable_array
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
-(PlayBoard *)initWithJsonData:(NSData *)jsonData{
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
            /*********解析每一个单词*********/
            NSArray *words_json_arr = [playBoardDic objectForKey:@"words"];
            NSMutableArray *output_words = [[NSMutableArray alloc]initWithCapacity:50];
            for (NSDictionary *aWordDic in words_json_arr) {
                Word *tmpWord = [[Word alloc]init];
                tmpWord.answer_capital              = [aWordDic objectForKey:@"cap"];
                tmpWord.answer_chinese_character    = [aWordDic objectForKey:@"chi"];
                tmpWord.mask                        = [aWordDic objectForKey:@"mask"];
                tmpWord.description                 = [aWordDic objectForKey:@"desc"];
                tmpWord.tmp                         = [aWordDic objectForKey:@"tmp"];
                tmpWord.horizontal                  = [(NSNumber *)[aWordDic objectForKey:@"horiz"] intValue];
                tmpWord.start_x                     = [(NSNumber *)[aWordDic objectForKey:@"x"] intValue];
                tmpWord.start_y                     = [(NSNumber *)[aWordDic objectForKey:@"y"] intValue];
                tmpWord.length                      = [(NSNumber *)[aWordDic objectForKey:@"len"] intValue];
                [output_words addObject:tmpWord];
            }
            self.words      = output_words;
            
#warning 棋盘添加字段位置1
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
            [self initPowerBoardCells];
        }
    }
    return self;
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
        for (PowerBoardCell *cell in row_array) {
//            [retString appendString:cell.correct];
            [retString appendString:[cell stringOfCorrectAnswers]];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    [retString appendString:@"[Input]\n"];
    for (NSArray *row_array in self.cells) {
        for (PowerBoardCell *cell in row_array) {
            [retString appendString:cell.input];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    [retString appendString:@"[Display]\n"];
    for (NSArray *row_array in self.cells) {
        for (PowerBoardCell *cell in row_array) {
            [retString appendString:cell.display];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    for (NSArray *row_array in self.cells) {
        for (PowerBoardCell *cell in row_array) {
            [retString appendString:[NSString stringWithFormat:@"%d",cell.currentState]];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    return retString;
}


#pragma mark PRIVATE-API
#pragma mark --

#warning 实现策略有待商榷
//找到一个点的下一个点
-(CGPoint)nextPointFromCurrentPoint:(CGPoint)fromPoint
{
    //根据当前点的坐标找到下一个点的坐标，实现的策略是：找到用户输入的方向，根据放下找到下一个位置，如果下一个位置可以输入，就跳转到这个位置，如果不能，就原地不动
    CGPoint retPoint = fromPoint;
    int last_x = (int)self.last_point.x;
    int last_y = (int)self.last_point.y;
    int cur_x = (int)fromPoint.x;
    int cur_y = (int)fromPoint.y;
    
    //更新上一次的坐标
    self.last_point = fromPoint;
    
    if (last_x == cur_x && last_y+1 == cur_y && cur_y+1 < self.height) {        //1:如果方向是竖着的，并且下边还有格子
        PowerBoardCell *bcell = self.cells[cur_y+1][cur_x];
        if ([bcell isCellCanInput]) {
            retPoint = CGPointMake(cur_x,cur_y+1);
        }
    }else if (last_y == cur_y && last_x+1 == cur_x && cur_x+1 < self.width){    //2:如果方向是横着的，并且右边还有有格子
        PowerBoardCell *bcell = self.cells[cur_y][cur_x+1];
        if ([bcell isCellCanInput]) {
            retPoint = CGPointMake(cur_x+1,cur_y);
        }
    }else{
        if(cur_y+1 < self.height){                          //3.2:如果没有方向，并且下边有格子
            PowerBoardCell *bcell = self.cells[cur_y+1][cur_x];
            if ([bcell isCellCanInput]) {
                retPoint = CGPointMake(cur_x,cur_y+1);
            }
        }
        
        if(cur_x+1 < self.width){                           //3.1:如果没有方向，并且右边有格子
            PowerBoardCell *bcell = self.cells[cur_y][cur_x+1];
            if ([bcell isCellCanInput]) {
                retPoint = CGPointMake(cur_x+1,cur_y);
            }
        }

    }
    return retPoint;
}
//根据tmp信息初始化两个area数组，只在最初调用
-(void)initPowerBoardCells{
    //初始化correct和input
    for (Word *aWord in self.words) {
        NSString *tmp       = aWord.tmp;
        NSString *ans_cap   = aWord.answer_capital;
        BOOL horizontal     = aWord.horizontal;
        int x               = aWord.start_x;
        int y               = aWord.start_y;
        int length          = aWord.length;
        for (int i = 0 ; i < length; i++) {
            if (horizontal) {
                if (y >= 0 && y < self.height && x+i >= 0 && x+i < self.width) {
                    //正确答案（首字母）
                    PowerBoardCell *cell      = (PowerBoardCell *)self.cells[y][x+i];
                    [cell addCorrectAnswerWithOneAlphabet:[ans_cap substringWithRange:NSMakeRange(i,1)]];
                    cell.input      = [tmp isEqualToString:@""] ? BLANK:[tmp substringWithRange:NSMakeRange(i,1)];//用户输入,如果tmp为空，那么设置为Blank，如果tmp有值，设置为tmp的值
                }
            } else {
                if (x >= 0 && x < self.width && y+i >= 0 && y+i < self.height) {
                    PowerBoardCell *cell      = (PowerBoardCell *)self.cells[y+i][x];
                    [cell addCorrectAnswerWithOneAlphabet:[ans_cap substringWithRange:NSMakeRange(i,1)]];
                    cell.input      = [tmp isEqualToString:@""] ? BLANK:[tmp substringWithRange:NSMakeRange(i,1)];
                }
            }
        }
    }
    
    //初始化display
    for (Word *aWord in self.words) {
        [self updateCellsDisplayByWord:aWord];
    }
    
}

//根据一个word更新一些cells的display
-(void)updateCellsDisplayByWord:(Word *)word
{
    //根据word的方向和该word是否bingo来确定显示的内容
    BOOL bingo      = [self isBingoOfWord:word];
    int x           = word.start_x;
    int y           = word.start_y;
    NSString *chi   = word.answer_chinese_character;
    
    for (int i = 0 ; i < word.length; i++) {
        if (word.horizontal) {
            PowerBoardCell *cell = self.cells[y][x+i];
            if (cell.currentState != GWGridCellCurrentStateDone) {
                if (bingo) {
                    [cell setStateDoneWithChineseCharacter:[chi substringWithRange:NSMakeRange(i,1)]];
                } else {
                    cell.display = cell.input;
                    cell.currentState = [cell isCellInputBlank] ? GWGridCellCurrentStateBlank : GWGridCellCurrentStateGuessing;
                }
            }
        }
        else{
            PowerBoardCell *cell = self.cells[y+i][x];
            if (cell.currentState != GWGridCellCurrentStateDone) {
                if (bingo) {
                    [cell setStateDoneWithChineseCharacter:[chi substringWithRange:NSMakeRange(i,1)]];
                } else {
                    cell.display = cell.input;
                    cell.currentState = [cell isCellInputBlank] ? GWGridCellCurrentStateBlank : GWGridCellCurrentStateGuessing;
                }
            }
        }
    }
}

//获得该point该方向上的单词
-(Word *)wordOfPoint:(CGPoint)point inHorizontalDirection:(BOOL)isHorizontal
{
    //如果该点该方向上有单词，返回该单词，如果没有，返回nil
    Word *retWord = nil;
    int x = (int)point.x;
    int y = (int)point.y;
    
    for (Word *aWrod in self.words) {
        if (aWrod.horizontal == isHorizontal) {
            if (isHorizontal) {
                //满足三个条件 1）纵坐标一致， 2）横坐标在起始和终止范围内
                if (y == aWrod.start_y && x >= aWrod.start_x && x <= aWrod.start_x + aWrod.length) {
                    retWord = aWrod;
                    break;
                }
            } else {
                if (x == aWrod.start_x && y >= aWrod.start_y && y <= aWrod.start_y + aWrod.length) {
                    retWord = aWrod;
                }
            }
        }
    }
    return retWord;
}


//根据word的坐标和横纵方向从input重确定它是否已经全部填充了
-(BOOL)isFullFillOfWord:(Word *)word{
    
    if (!word) {
        return NO;
    }
    BOOL bingo = YES;
    int x = word.start_x;
    int y = word.start_y;
    for (int i = 0 ; i < word.length; i++) {
        if (word.horizontal) {
            PowerBoardCell *cell = self.cells[y][x+i];
            if ([cell isCellInputBlank]) {
                bingo = NO;
                break;
            }
        }else{
            PowerBoardCell *cell = self.cells[y+i][x];
            if ([cell isCellInputBlank]) {
                bingo = NO;
                break;
            }
        }
    }
    return bingo;
}

//查看某个单词是否完成
-(BOOL)isBingoOfWord:(Word *)word{
    //根据word的坐标和横纵方向来从correct和input中确定它是否已经完成
    if (!word) {
        return NO;
    }
    BOOL bingo = YES;
    int x = word.start_x;
    int y = word.start_y;
    
    for (int i = 0 ; i < word.length; i++) {
        if (word.horizontal) {
            PowerBoardCell *cell = self.cells[y][x+i];
            if (![cell isCellCorrect]) {
                bingo = NO;
                break;
            }
        } else {
            PowerBoardCell *cell = self.cells[y+i][x];
            if (![cell isCellCorrect]) {
                bingo = NO;
                break;
            }
        }
    }
    return bingo;
}


//-(void)saveToFile:(NSString *)saveFile{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString *file = [documentDirectory stringByAppendingPathComponent:saveFile];
//    //目前保存的位置/Users/wangjz/Library/Application Support/iPhone Simulator/6.0/Applications/83275A71-8E2A-41D1-AF0B-E82044AFAD88
//    NSData *jsData = [self jsonDataDescription];
//    if (jsData) {
//        BOOL succeed = [jsData writeToFile:file atomically:YES];
//        if (succeed) {
//            NSLog(@"Save succeed");
//        }else {
//            NSLog(@"Save fail");
//        }
//    }
//}


@end
