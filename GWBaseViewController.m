//
//  GWBaseViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-16.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWBaseViewController.h"

@interface GWBaseViewController ()

@end

@implementation GWBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addDefaultBackBarItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addDefaultBackBarItem
{
    UIImage* image = [UIImage imageNamed:@"navigationbar_backbutton.png"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *barButtomItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    barButtomItem.accessibilityLabel = @"返回";
    self.navigationItem.leftBarButtonItem = barButtomItem;

}














@end
