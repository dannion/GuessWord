//
//  CDPlayBoard.h
//  GuessWord
//
//  Created by WangJZ on 12/10/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDPlayBoard : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSData * jsonData;
@property (nonatomic, retain) NSNumber * level;

@end
