//
//  Cell.h
//  GuessWord
//
//  Created by WangJZ on 12/11/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardCell : NSObject

@property(nonatomic,strong)NSString *correct;//正确的文字
@property(nonatomic,strong)NSString *input;//输入的字母
@property(nonatomic,strong)NSString *display;//应该显示的内容

@end
