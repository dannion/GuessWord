//
//  NewWord.h
//  GuessWord
//
//  Created by WangJZ on 3/5/14.
//  Copyright (c) 2014 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*一个单词，几乎不会改变*/
@interface NewWord : NSObject

@property(nonatomic,strong)NSString *firstLevelDescription;         //一级描述
@property(nonatomic,strong)NSString *secondLevelDescription;        //二级描述
@property(nonatomic,strong)NSString *explanation;                   //解释
@property(nonatomic,strong)NSMutableArray *coveredCells;            //它所包含的cells
@property(nonatomic) int number;                                    //表示它是第几个单词
@property(nonatomic) int length;                                    //单词长度

-(void)addCell;//添加新的cell

@end
