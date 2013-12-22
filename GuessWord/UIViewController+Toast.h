//
//  UIViewController+Toast.h
//  GuessWord
//
//  Created by Dannion on 13-12-22.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Toast)

- (void)showToastWithDescription:(NSString*)description;
- (void)showToastWithDescription:(NSString*)description whichWillHideAfterDelay:(NSUInteger)delay;//if delay=0, toast will not hide until you call hideToast;

- (void)hideToast:(BOOL)animated;

@end
