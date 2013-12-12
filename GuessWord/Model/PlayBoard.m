//
//
//  【重要信息】
//  从tmp读取input，将input写入文件中的tmp
//  每次输入改变input
//  根据每个word的的坐标找到对应的input和correct，改变display
//
//

#import "PlayBoard.h"
#import "BoardCell.h"
#import "CDPlayBoard+Interface.h"
@interface PlayBoard()

/*********************************私有变量*************************/

@property(nonatomic,strong)NSMutableArray *cells;


/*********************************私有API*************************/

-(void)initBoardCells;//根据tmp信息初始化两个area数组
-(void)updateCellsDisplayByWord:(Word *)word;//根据一个word更新display
-(BOOL)isBingoOfWord:(Word *)word;//查看某个单词是否完成
//-(Word *)wordOfPoint:(CGPoint)point inDirection:(BOOL)isHorizontal;//获得该point该方向上的单词

//-(CGPoint)nextPointFromPoint:(CGPoint)fromPoint;//找到一个点的下一个点
//-(void)saveToFile:(NSString *)saveFile;//将信息保存到文件中（或数据库）

    
@end

@implementation PlayBoard

#pragma mark 构造方法
#pragma mark --

//通过BoardNumber生成一个PlayBoard
+(PlayBoard *)playBoardFromLocalDatabaseByUniqueID:(NSNumber *)uniqueID
{
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
                    withUniqueID:(NSNumber *)uniqueID
{
    [CDPlayBoard inserToDatabaseWithPlayBoard:thePlayBoard withUniqueID:thePlayBoard.uniqueid];
}

+(PlayBoard *)playBoardFromFile:(NSString *)file{
    NSString *js_file_path = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:js_file_path];
    return [PlayBoard playBoardFromData:jsonData];
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
            BoardCell *cell = [[BoardCell alloc]init];
            cell.input = BLOCK;
            cell.correct = BLOCK;
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

/*获取某个坐标上的boardcel*/
-(BoardCell *)cellAtPoint:(CGPoint)point{
    int x = (int)point.x;
    int y = (int)point.y;
    return self.cells[y][x];
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
    BoardCell *cell = self.cells[y][x];
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
-(void)updateBoardWithInputValue:(NSString *)oneAlphabet atPoint:(CGPoint)point{
    int x = (int)point.x;
    int y = (int)point.y;
    
    //check坐标在方格内
    if (x>= 0 && x< self.width && y>= 0 && y <self.height ) {
#warning check该坐标位置不是Block,暂时不检查是否已经是正确答案的情况
        BoardCell *cell = self.cells[y][x];
        if (![cell isCellBlock] && ![cell isCellDone]) {
            cell.input = oneAlphabet;
            [self updateCellsDisplayByPoint:point];
        }

    }
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
                BoardCell *boarCell = self.cells[y][x+i];
                [tmpString appendString:boarCell.input];
            }else{
                BoardCell *boarCell = self.cells[y+i][x];
                [tmpString appendString:boarCell.input];
            }
        }

        NSDictionary *aWordDic = @{@"cap"       :aWord.answer_capital             == nil ? @"":aWord.answer_capital,
                                   @"chi"       :aWord.answer_chinese_character   == nil ? @"":aWord.answer_chinese_character,
                                   @"mask"      :aWord.mask                       == nil ? @"":aWord.mask,
                                   @"desc"      :aWord.description                == nil ? @"":aWord.description,
                                   @"tmp"       :tmpString,
                                   @"horiz"     :aWord.horizontal                 == YES ? [NSNumber numberWithInt:1]:[NSNumber numberWithInt:0],
                                   @"x"         :[NSNumber numberWithInt:aWord.start_x],
                                   @"y"         :[NSNumber numberWithInt:aWord.start_y],
                                   @"len"       :[NSNumber numberWithInt:aWord.length]
                                   };
        [word_writable_array addObject:aWordDic];
    }
    //局面写入一个字典
    NSDictionary *dictionary = @{@"file"        :self.file                        == nil ? @"":self.file,
                                 @"category"    :self.category                    == nil ? @"":self.category,
                                 @"uniqueid"    :self.uniqueid,
                                 @"vol"         :self.vol,
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
            assert([jsonObject isKindOfClass:[NSDictionary class]]);
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
                        
            /*********解析基础数据*********/
            self.file       = [playBoardDic objectForKey:@"file"];
            self.uniqueid   = [playBoardDic objectForKey:@"uniqueid"];
            self.vol        = [playBoardDic objectForKey:@"vol"];
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
            [self initBoardCells];
        }
    }
    return self;
}

//为了打印输出查看结果
-(NSString*)description
{
    NSMutableString *retString = [[NSMutableString alloc]init];
    [retString appendString:@"\n[Correct]\n"];
    for (NSArray *row_array in self.cells) {
        for (BoardCell *cell in row_array) {
            [retString appendString:cell.correct];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    [retString appendString:@"\n[Input]\n"];
    for (NSArray *row_array in self.cells) {
        for (BoardCell *cell in row_array) {
            [retString appendString:cell.input];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    [retString appendString:@"\n[Display]\n"];
    for (NSArray *row_array in self.cells) {
        for (BoardCell *cell in row_array) {
            [retString appendString:cell.display];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    return retString;
}


#pragma mark PRIVATE-API
#pragma mark --

//根据tmp信息初始化两个area数组，只在最初调用
-(void)initBoardCells{
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
                    BoardCell *cell      = (BoardCell *)self.cells[y][x+i];
                    cell.correct    = [ans_cap substringWithRange:NSMakeRange(i,1)];
                    cell.input      = [tmp isEqualToString:@""] ? BLANK:[tmp substringWithRange:NSMakeRange(i,1)];//用户输入,如果tmp为空，那么设置为Blank，如果tmp有值，设置为tmp的值
                }
            } else {
                if (x >= 0 && x < self.width && y+i >= 0 && y+i < self.height) {
                    BoardCell *cell      = (BoardCell *)self.cells[y+i][x];
                    cell.correct    = [ans_cap substringWithRange:NSMakeRange(i,1)];
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
            BoardCell *cell = self.cells[y][x+i];
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
            BoardCell *cell = self.cells[y+i][x];
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
            BoardCell *cell = self.cells[y][x+i];
            if (![cell isCellCorrect]) {
                bingo = NO;
                break;
            }
        } else {
            BoardCell *cell = self.cells[y+i][x];
            if (![cell isCellCorrect]) {
                bingo = NO;
                break;
            }
        }
    }
    return bingo;
}


-(void)saveToFile:(NSString *)saveFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *file = [documentDirectory stringByAppendingPathComponent:saveFile];
    //目前保存的位置Users/wangjz/Library/Application Support/iPhone Simulator/6.0/Applications/83275A71-8E2A-41D1-AF0B-E82044AFAD88
    NSData *jsData = [self jsonDataDescription];
    if (jsData) {
        BOOL succeed = [jsData writeToFile:file atomically:YES];
        if (succeed) {
            NSLog(@"Save succeed");
        }else {
            NSLog(@"Save fail");
        }
    }
}


@end
