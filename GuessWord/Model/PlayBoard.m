//
//
//  【重要信息】
//  从tmp读取input，将input写入文件中的tmp
//  每次输入改变input
//  根据每个word的的坐标找到对应的input和correct，改变display
//
//

#import "PlayBoard.h"

@interface PlayBoard()

/*********************************私有变量*************************/

@property(nonatomic,strong)NSMutableArray *areaOfCorrect;//正确的文字
@property(nonatomic,strong)NSMutableArray *areaOfInput;//输入的字母
@property(nonatomic,strong)NSMutableArray *areaOfDisplay;//应该显示的内容，目前看来没啥用处，可以考虑删掉。。。


/*********************************私有API*************************/

-(void)initAreaOfInputAndAreaOfCorrectBasedOnTMP;//根据tmp信息初始化两个area数组
-(void)updateAreaOfDisplayByWord:(Word *)word;//根据一个word更新areaOfDisplay
-(BOOL)isBingoOfWord:(Word *)word;//查看某个单词是否完成
-(Word *)wordOfPoint:(CGPoint)point inDirection:(BOOL)isHorizontal;//获得该point该方向上的单词

//-(CGPoint)nextPointFromPoint:(CGPoint)fromPoint;//找到一个点的下一个点
//-(void)saveToFile:(NSString *)saveFile;//将信息保存到文件中（或数据库）

    
@end

@implementation PlayBoard

#pragma mark LAZY-INSTANCE
#pragma mark --
-(NSMutableArray *)areaByLazyInstance
{
    //初始化各种area，使用Lazy instance,初始化都为BLOCK
    int i,j;
    NSMutableArray *theArea = [[NSMutableArray alloc]init];
    for (j = 0; j < self.height; j++) {
        NSMutableArray *column_array = [[NSMutableArray alloc]initWithCapacity:10];
        for (i = 0; i < self.width; i++) {
            [column_array addObject:BLOCK];
        }
        [theArea addObject:column_array];
    }
    return theArea;
}
-(NSMutableArray *)areaOfCorrect
{
    if (! _areaOfCorrect) _areaOfCorrect = [self areaByLazyInstance];
    return _areaOfCorrect;
}
-(NSMutableArray *)areaOfInput
{
    if (! _areaOfInput) _areaOfInput = [self areaByLazyInstance];
    return _areaOfInput;
}

-(NSMutableArray *)areaOfDisplay
{
    if (! _areaOfDisplay) _areaOfDisplay = [self areaByLazyInstance];
    return _areaOfDisplay;
}


#pragma mark PUBLIC-API
#pragma mark --

//判断某个点所在单词是否完成
-(BOOL)isBingoOfWordAtPoint:(CGPoint)point inDirection:(BOOL)isHorizontal{
    //先获取当前的点上对应的那两个词
    Word *word = [self wordOfPoint:point inDirection:isHorizontal];
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

//Lazy更新,返回得到当前应该显示的状态
-(NSArray *)current_state
{
    //batch update
    for (Word *aWord in self.words) {
        [self updateAreaOfDisplayByWord:aWord];
    }
    return self.areaOfDisplay;
}

/*判断该点是否能够点击*/
#warning 当前的实现方式看该位置是否是墙，而不考虑是不是有汉字，有待商榷
-(BOOL)isClickableAtPoint:(CGPoint)point{
    int x = point.x;
    int y = point.y;
    if ([self.areaOfCorrect[y][x] isEqualToString: BLOCK]) {
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


//在某个坐标上输入一个字母，修改areaOfInput
-(void)updateBoardWithInputValue:(NSString *)oneAlphabet atPoint:(CGPoint)point{
    int x = (int)point.x;
    int y = (int)point.y;
    
    //check坐标在方格内
    if (x>= 0 && x< self.width && y>= 0 && y <self.height ) {
        
        //if (![self.areaOfCorrect[y][x] isEqualToString:BLOCK] && ![self.areaOfInput[y][x] isEqualToString:self.areaOfCorrect[y][x]]) {
        
#warning check该坐标位置不是Block,暂时不检查是否已经是正确答案的情况
        if (![self.areaOfCorrect[y][x] isEqualToString:BLOCK]) {
            self.areaOfInput[y][x] = oneAlphabet;
        }
    }
}

/*指定的初始化函数*/
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
            self.category   = [playBoardDic objectForKey:@"category"];
            self.date       = [playBoardDic objectForKey:@"date"];
            self.gamename   = [playBoardDic objectForKey:@"gamename"];
            self.author     = [playBoardDic objectForKey:@"author"];
            
            self.score      = [(NSNumber *)[playBoardDic objectForKey:@"score"] intValue];
            self.percent    = [(NSNumber *)[playBoardDic objectForKey:@"percent"] intValue];
            self.level      = [(NSNumber *)[playBoardDic objectForKey:@"level"] intValue];
            self.width      = [(NSNumber *)[playBoardDic objectForKey:@"width"] intValue];
            self.height     = [(NSNumber *)[playBoardDic objectForKey:@"height"] intValue];
            [self initAreaOfInputAndAreaOfCorrectBasedOnTMP];
        }
    }
    return self;
}

//为了打印输出查看结果
-(NSString*)description
{
    NSMutableString *retString = [[NSMutableString alloc]init];
    [retString appendString:@"\n[Correct]\n"];
    for (NSArray *row_array in self.areaOfCorrect) {
        for (NSString *columnString in row_array) {
            [retString appendString:columnString];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    [retString appendString:@"\[Input]\n"];
    for (NSArray *row_array in self.areaOfInput) {
        for (NSString *columnString in row_array) {
            [retString appendString:columnString];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    [retString appendString:@"\[Display]\n"];
    for (NSArray *row_array in self.areaOfDisplay) {
        for (NSString *columnString in row_array) {
            [retString appendString:columnString];
            [retString appendString:@" "];
        }
        [retString appendString:@"\n"];
    }
    
    
    return retString;
}


#pragma mark PRIVATE-API
#pragma mark --

//根据tmp信息初始化两个area数组，只在最初调用
-(void)initAreaOfInputAndAreaOfCorrectBasedOnTMP{
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
                    self.areaOfCorrect[y][x+i] = [ans_cap substringWithRange:NSMakeRange(i,1)];
                    
                    //用户输入,如果tmp为空，那么设置为Blank，如果tmp有值，设置为tmp的值
                    self.areaOfInput[y][x+i]   = [tmp isEqualToString:@""] ? BLANK:[tmp substringWithRange:NSMakeRange(i,1)];
                }
            } else {
                if (x >= 0 && x < self.width && y+i >= 0 && y+i < self.height) {
                    self.areaOfCorrect[y+i][x] = [ans_cap substringWithRange:NSMakeRange(i,1)];
                    self.areaOfInput[y+i][x] = [tmp isEqualToString:@""] ? BLANK:[tmp substringWithRange:NSMakeRange(i,1)];
                }
            }
        }
    }
}

//根据一个word更新areaOfDisplay
-(void) updateAreaOfDisplayByWord:(Word *)word
{
    //根据word的方向和该word是否bingo来确定显示的内容
    BOOL bingo      = [self isBingoOfWord:word];
    int x           = word.start_x;
    int y           = word.start_y;
    NSString *chi   = word.answer_chinese_character;
    
    for (int i = 0 ; i < word.length; i++) {
        if (word.horizontal) {
            if (bingo) {
                self.areaOfDisplay[y][x+i] = [chi substringWithRange:NSMakeRange(i,1)];
            } else {
                self.areaOfDisplay[y][x+i] = self.areaOfInput[y][x+i];
            }
        }
        else{
            if (bingo) {
                self.areaOfDisplay[y+i][x] = [chi substringWithRange:NSMakeRange(i,1)];
            } else {
                self.areaOfDisplay[y+i][x] = self.areaOfInput[y+i][x];
            }
        }
    }
}

//获得该point该方向上的单词
-(Word *)wordOfPoint:(CGPoint)point inDirection:(BOOL)isHorizontal
{
    //如果该点该方向上有单词，返回该单词，如果没有，返回nil
    Word *retWord = nil;
    int x = (int)point.x;
    int y = (int)point.y;
    
    for (Word *aWrod in self.words) {
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
            if (![self.areaOfCorrect[y][x+i] isEqualToString:self.areaOfInput[y][x+i]]) {
                bingo = NO;
                break;
            }
        } else {
            if (![self.areaOfCorrect[y+i][x] isEqualToString:self.areaOfInput[y+i][x]]) {
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
//将类转化成json数据
-(NSData *)jsonDataDescription{
    NSMutableArray *word_writable_array = [[NSMutableArray alloc]initWithCapacity:50];

    //将每一个单词写入json格式的数组
    for (Word *aWord in self.words) {
        NSDictionary *aWordDic = @{@"cap"       :aWord.answer_capital             == nil ? @"":aWord.answer_capital,
                                   @"chi"       :aWord.answer_chinese_character   == nil ? @"":aWord.answer_chinese_character,
                                   @"mask"      :aWord.mask                       == nil ? @"":aWord.mask,
                                   @"desc"      :aWord.description                == nil ? @"":aWord.description,
                                   @"tmp"       :aWord.tmp                        == nil ? @"":aWord.tmp,
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
                                 @"date"        :self.date                        == nil ? @"":self.date,
                                 @"gamename"    :self.gamename                    == nil ? @"":self.gamename,
                                 @"author"      :self.author                      == nil ? @"":self.author,
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


@end
