//
//  CDPlayBoard.h
//  GuessWord
//
//  Created by WangJZ on 12/13/13.
//  Copyright (c) 2013 BUPTMITC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDVol;

@interface CDPlayBoard : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSData * jsonData;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * uniqueid;
@property (nonatomic, retain) NSNumber * vol;
@property (nonatomic, retain) CDVol *belongToWhom;

@end
