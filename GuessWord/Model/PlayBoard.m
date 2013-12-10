//
//  PlayBoard.m
//  DMTXW
//
//  Created by WangJZ on 12/9/13.
//  Copyright (c) 2013 WangJZ. All rights reserved.
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


/*********************************私有函数*************************/
-(void)initAreaOfInputAndAreaOfCorrectBasedOnTMP;//根据tmp信息初始化两个area数组

-(CGPoint)nextPointFromPoint:(CGPoint)fromPoint;//找到一个点的下一个点

-(PlayBoard *)readFromFile:(NSString *)fromFile;//根据信息生成PlayBoard
-(void)saveToFile:(NSString *)saveFile;//将信息保存到文件中（或数据库）

    
@end

@implementation PlayBoard

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


//根据tmp信息初始化两个area数组
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

//更新并返回得到当前应该显示的状态
-(NSArray *)current_state
{
    for (Word *aWord in self.words) {
        BOOL horizontal     = aWord.horizontal;
        int x               = aWord.start_x;
        int y               = aWord.start_y;
        int length          = aWord.length;
        for (int i = 0 ; i < length; i++) {
            if (horizontal) {
                if (y >= 0 && y < self.height && x+i >= 0 && x+i < self.width) {
                    //应该显示的内容：当用户输入和正确答案一致时，显示汉字，否则显示用户输入
                    if ([self.areaOfCorrect[y][x+i] isEqualToString:self.areaOfInput[y][x+i]]) {
                        self.areaOfDisplay[y][x+i] = [aWord.answer_chinese_character substringWithRange:NSMakeRange(i,1)];
                    } else {
                        self.areaOfDisplay[y][x+i] = self.areaOfInput[y][x+i];
                    }
                }
            } else {
                if (x >= 0 && x < self.width && y+i >= 0 && y+i < self.height) {
                    if ([self.areaOfCorrect[y+i][x] isEqualToString:self.areaOfInput[y][x+i]]) {
                        self.areaOfDisplay[y+i][x] = [aWord.answer_chinese_character substringWithRange:NSMakeRange(i,1)];
                    } else {
                        self.areaOfDisplay[y+i][x] = self.areaOfInput[y][x+i];
                    }
                }
            }
        }
    }
    return self.areaOfDisplay;
}

//在某个坐标上输入一个字母
-(void)updateBoardWithInputValue:(NSString *)oneAlphabet atPoint:(CGPoint)point{
    int x = (int)point.x;
    int y = (int)point.y;
    
    //check坐标在方格内
    if (x>= 0 && x< self.width && y>= 0 && y <self.height ) {
        //check该坐标位置不是Block，不是汉字
        if (![self.areaOfCorrect[y][x] isEqualToString:BLOCK] && ![self.areaOfInput[y][x] isEqualToString:self.areaOfCorrect[y][x]]) {
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









@end
