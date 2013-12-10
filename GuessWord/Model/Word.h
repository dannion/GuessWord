//
//  Word.h
//  DMTXW
//
//  Created by WangJZ on 12/9/13.
//  Copyright (c) 2013 WangJZ. All rights reserved.
//

#import <Foundation/Foundation.h>

/*Model：一个单词*/
@interface Word : NSObject

@property(nonatomic,strong)NSString *answer_capital;//标准答案，首字母
@property(nonatomic,strong)NSString *answer_chinese_character;//标准答案，用汉语表达
@property(nonatomic,strong)NSString *mask;//掩码
@property(nonatomic,strong)NSString *description;//描述
@property(nonatomic,strong)NSString *tmp;//保存用户的输入

@property(nonatomic) BOOL horizontal;//是否是水平的
@property(nonatomic) int start_x;//起始坐标x
@property(nonatomic) int start_y;//起始坐标y
@property(nonatomic) int length;//单词长度

@end
