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
@property(nonatomic,strong) NSArray *words;//包含了全部的单词
@property(nonatomic,strong) NSString *file; // 对应的文件
@property(nonatomic) NSDate *date; // 游戏的日期
@property(nonatomic,strong) NSString *gamename; // 游戏名字
@property(nonatomic,strong) NSString *author; // 作者
@property(nonatomic) int score;//得分
@property(nonatomic) int percent;//完成度
@property(nonatomic) int level;//游戏等级
@property(nonatomic) int width;//横向有多少个格子
@property(nonatomic) int height;//纵向有多少个格子
@property(nonatomic) CGPoint current_point;//当前坐标x

@property(nonatomic,strong)NSMutableArray *areaOfCorrect;//正确的文字
@property(nonatomic,strong)NSMutableArray *areaOfInput;//输入的字母
@property(nonatomic,strong)NSMutableArray *areaOfDisplay;//应该显示的内容，目前看来没啥用处，可以考虑删掉。。。


/*********************************私有API*************************/
-(void)initAreaOfInputAndAreaOfCorrectBasedOnTMP;//根据tmp信息初始化两个area数组

//-(CGPoint)nextPointFromPoint:(CGPoint)fromPoint;//找到一个点的下一个点
-(void) updateAreaOfDisplayByWord:(Word *)word;//根据一个word更新areaOfDisplay
-(BOOL)isBingoOfWord:(Word *)word;//查看某个单词是否完成
//-(PlayBoard *)readFromFile:(NSString *)fromFile;//根据信息生成PlayBoard
//-(void)saveToFile:(NSString *)saveFile;//将信息保存到文件中（或数据库）

    
@end

@implementation PlayBoard
/*判断该点是否能够点击*/
#warning 当前的实现方式看该位置是否是墙，而不考虑是不是有汉字，有待商榷
-(BOOL)isClickableAtPoint:(CGPoint)point{
    int x = point.x;
    int y = point.y;
    if ([self.areaOfCorrect[y][x]  isEqualToString: BLOCK]) {
        return NO;
    }else{
        return YES;
    }
}

/*是否闯关成功*/
-(BOOL)isCompleted{
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
        
        //check该坐标位置不是Block,暂时不检查是否已经是正确答案
        if (![self.areaOfCorrect[y][x] isEqualToString:BLOCK]) {
            self.areaOfInput[y][x] = oneAlphabet;
        }
    }
}

//指定的初始化函数
-(PlayBoard *)initWith{
    self = [super init];
    if (self) {
        Word *word1 = [[Word alloc]init];
        word1.answer_capital = @"hyl";
        word1.answer_chinese_character = @"好运来";
        word1.mask = @"100";
        word1.description = @"时来运转";
        word1.tmp = @"h-l";
        word1.horizontal = YES;
        word1.start_x = 1;
        word1.start_y = 2;
        word1.length = 3;
        self.words = @[word1];
        self.width = 5;
        self.height = 5;
        [self initAreaOfInputAndAreaOfCorrectBasedOnTMP];
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
                    self.areaOfInput[y][x+i]   = [tmp isEqualToString:@""] ? [ans_cap substringWithRange:NSMakeRange(i,1)] : BLANK;
                }
            } else {
                if (x >= 0 && x < self.width && y+i >= 0 && y+i < self.height) {
                    self.areaOfCorrect[y+i][x] = [ans_cap substringWithRange:NSMakeRange(i,1)];
                    self.areaOfCorrect[y+i][x] = [tmp isEqualToString:@""] ? [ans_cap substringWithRange:NSMakeRange(i,1)] : BLANK;
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


//判断某个点所在单词是否完成
-(BOOL)isBingoOfWordAtPoint:(CGPoint)point inDirection:(BOOL)isHorizontal{
    //先获取当前的点上对应的那两个词
    Word *word = [self wordOfPoint:point inDirection:isHorizontal];
    //查看对应的单词是否完成
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











@end
