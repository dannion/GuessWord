////
////  Cell.m
////  GuessWord
////
////  Created by WangJZ on 12/11/13.
////  Copyright (c) 2013 BUPTMITC. All rights reserved.
////
//
//#import "BoardCell.h"
//#import "PlayBoard.h"
//@implementation BoardCell
//
//-(void)setStateDoneWithChineseCharacter:(NSString *)chineseCharacter{
//    self.display = chineseCharacter;
//    self.currentState = GWGridCellCurrentStateDone;
//}
//
//-(BOOL)isCellCanInput{
//    if (![self isCellDone] && ![self isCellBlock]) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
//
//-(BOOL)isCellDone{
//    if (self.currentState == GWGridCellCurrentStateDone) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
//-(BOOL)isCellBlock{
//    if ([self.correct isEqualToString:BLOCK]) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
//
//-(BOOL)isCellCorrect{
//    if ([self.input isEqualToString:self.correct]) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
//-(BOOL)isCellInputBlank{
//    if ([self.input isEqualToString:BLANK]) {
//        return YES;
//    }else {
//        return NO;
//    }
//}
//@end
