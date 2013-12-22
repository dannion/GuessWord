//
//  UIViewController+Toast.m
//  GuessWord
//
//  Created by Dannion on 13-12-22.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "UIViewController+Toast.h"

@implementation UIViewController (Toast)

- (void)showToastWithDescription:(NSString*)description
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor whiteColor];
    hud.labelTextColor = [UIColor blueColor];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = description;
    [hud hide:YES afterDelay:1.5];
}

@end
