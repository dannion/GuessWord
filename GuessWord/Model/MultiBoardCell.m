//
//  MultiBoardCell.m
//  GuessWord
//
//  Created by WangJZ on 12/16/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import "MultiBoardCell.h"

@implementation MultiBoardCell

/*遍历multiCorrect，如果其中有和input相等的string，那么是正确的*/
-(BOOL)isCellCorrect{
    BOOL answer = NO;
    for (NSString *oneAlphabet in self.multiCorrect) {
        if ([oneAlphabet isEqualToString:self.input]) {
            answer = YES;
            break;
        }
    }
    return answer;
}


@end
