//
//  CDEpisode.h
//  GuessWord
//
//  Created by WangJZ on 12/12/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDPlayBoard;

@interface CDEpisode : NSManagedObject

@property (nonatomic, retain) NSNumber * episodeID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numberOfLevels;
@property (nonatomic, retain) NSDate * open_date;
@property (nonatomic, retain) NSSet *boards;
@end

@interface CDEpisode (CoreDataGeneratedAccessors)

- (void)addBoardsObject:(CDPlayBoard *)value;
- (void)removeBoardsObject:(CDPlayBoard *)value;
- (void)addBoards:(NSSet *)values;
- (void)removeBoards:(NSSet *)values;

@end
