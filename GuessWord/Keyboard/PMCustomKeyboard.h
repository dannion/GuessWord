//
//  PMCustomKeyboard.h
//  PunjabiKeyboard
//
//  Created by Kulpreet Chilana on 7/31/12.
//  Copyright (c) 2012 Kulpreet Chilana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kFont [UIFont fontWithName:@"GurmukhiMN" size:20]

#define kChar @[ @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"W", @"X", @"Y", @"Z", @" " ]

#define kCustomKeyboardWillShowNotification @"CustomKeyboardWillShowNotification"
#define kCustomKeyboardWillHideNotification @"CustomKeyboardWillHideNotification"
#define kCustomKeyboardDidEnterACharacterNotification @"CustomKeyboardDidEnterACharacterNotification"

@interface PMCustomKeyboard : UIView <UIInputViewAudioFeedback>

@property (strong, nonatomic) IBOutlet UIImageView *keyboardBackground;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *characterKeys;

@property (nonatomic, assign) BOOL isShowing;


+ (PMCustomKeyboard*)shareInstance;


- (void)showInView:(UIView*)view;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)removeFromSuperview;
- (void)removeFromSuperview:(BOOL)animated;

@end
