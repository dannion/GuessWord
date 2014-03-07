//
//  NewWord.m
//  GuessWord
//
//  Created by WangJZ on 3/5/14.
//  Copyright (c) 2014 BUPTMITC. All rights reserved.
//

#import "NewWord.h"
#import "NewBoardCell.h"

@implementation NewWord

#warning 这样写coveredCells可以吧？
-(NSMutableSet *)coveredCells{
    if (!_coveredCells) {
        _coveredCells = [[NSMutableSet alloc]init];
        return _coveredCells;
    }else{
        return _coveredCells;
    }
}

-(BOOL)isComplete{
    for (NewBoardCell *cell in self.coveredCells) {
        if (![cell isCellInputBlank]) {//如果有某个cell是空的，说明这个单词没有填完
            return NO;
        }
    }
    return YES;
}
-(NSDictionary *)dictionaryOfDescription{
    NSDictionary *retDic = @{@"desc":self.firstLevelDescription,
                             @"desc2":self.secondLevelDescription,
                             @"to":[NSNumber numberWithInt:self.indexID ]};
    return retDic;
}

-(NSDictionary *)jsonDicOfDescriptions{
//{"desc":"烟花三月","desc2":"烟花三月下扬州","to":1},
    NSDictionary *retDic = @{@"desc":self.firstLevelDescription,
                             @"desc2":self.secondLevelDescription,
                             @"to":[NSNumber numberWithInt:self.indexID]};
    return retDic;
}

-(NSDictionary *)jsonDicOfExplanations{
//    {"exp":"李白《送孟浩然之广陵》中的第二句，描写扬州春天烟花满城的场景","to":1,
    NSDictionary *retDic = @{@"exp":self.explanation,
                             @"to":[NSNumber numberWithInt:self.indexID]};
    return retDic;
}

-(NSArray *)itemsOfCharacters{
//    [{"cap":"Y","chi":"烟","x":4,"y":1,"temp":"-","i":1,"j":1},{"cap":"H","chi":"花","x":4,"y":2,"temp":"-","i":1,"j":2}]
    NSMutableArray *retArray = [[NSMutableArray alloc]initWithCapacity:5];
    for (NewBoardCell *cell in self.coveredCells) {
        for (GWCharacter *oneChar in cell.gwChars) {
            NSDictionary *temp = @{@"cap":oneChar.correct_answer,
                                   @"chi":cell.chinese,
                                   @"x":[NSNumber numberWithInt:cell.x],
                                   @"y":[NSNumber numberWithInt:cell.y],
                                   @"temp":cell.input,
                                   @"i":[NSNumber numberWithInt:oneChar.wordIndex],
                                   @"j":[NSNumber numberWithInt:oneChar.positionInWord]};
            [retArray addObject:temp];
        }
    }
    return retArray;
}

-(void)updateCellsState
{
    //更新该单词的所有cells的状态（显示，状态）
    BOOL bingo      = [self isBingo];
    for (NewBoardCell *cell in self.coveredCells) {
        if (cell.currentState != GWGridCellCurrentStateDone) {
            if (bingo) {
                cell.display = cell.chinese;
                cell.currentState = GWGridCellCurrentStateDone;
            }else{
                cell.display = cell.input;
                cell.currentState = [cell isCellInputBlank] ? GWGridCellCurrentStateBlank : GWGridCellCurrentStateGuessing;
            }
        }
    }
}

-(BOOL)isBingo{
    //如果当前word的多个cell中有一个不是正确的，
    for (NewBoardCell *cell in self.coveredCells) {
        if (![cell isCellCorrect]) {
            return NO;
        }
    }
    return YES;
}

@end
