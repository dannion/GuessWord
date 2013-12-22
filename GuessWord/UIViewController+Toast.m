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
    [self showToastWithDescription:description whichWillHideAfterDelay:1.5];
}

- (void)showToastWithDescription:(NSString*)description whichWillHideAfterDelay:(NSUInteger)delay
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor whiteColor];
    hud.labelTextColor = [UIColor colorWithRed:64.0/256 green:64.0/256 blue:64.0/256 alpha:1.0];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = description;
    [hud hide:YES afterDelay:delay];
}

- (void)hideToast:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:animated];
}
@end
