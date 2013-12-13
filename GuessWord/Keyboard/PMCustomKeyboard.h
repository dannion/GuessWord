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

#define kChar @[ @"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"Z", @"X", @"C", @"V", @"B", @"N", @"M" ]

#define kCustomKeyboardWillShowNotification @"CustomKeyboardWillShowNotification"
#define kCustomKeyboardWillHideNotification @"CustomKeyboardWillHideNotification"
#define kCustomKeyboardDidEnterACharacterNotification @"CustomKeyboardDidEnterACharacterNotification"

@interface PMCustomKeyboard : UIView <UIInputViewAudioFeedback>

@property (strong, nonatomic) IBOutlet UIImageView *keyboardBackground;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *characterKeys;

@property (nonatomic, assign) BOOL isShowing;


+ (PMCustomKeyboard*)shareInstance;


- (void)showInView:(UIView*)view;
- (void)removeFromSuperview;

@end
