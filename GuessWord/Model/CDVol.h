//
//  CDVol.h
//  GuessWord
//
//  Created by WangJZ on 12/13/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPlayBoard;

@interface CDVol : NSManagedObject

@property (nonatomic, retain) NSNumber * uniqueVolNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numberOfLevels;
@property (nonatomic, retain) NSDate * open_date;
@property (nonatomic, retain) NSSet *hasBoards;
@end

@interface CDVol (CoreDataGeneratedAccessors)

- (void)addHasBoardsObject:(CDPlayBoard *)value;
- (void)removeHasBoardsObject:(CDPlayBoard *)value;
- (void)addHasBoards:(NSSet *)values;
- (void)removeHasBoards:(NSSet *)values;

@end
