//
//  GWSettingViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-22.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWSettingViewController.h"
#import "GWAccountStore.h"

@interface GWSettingViewController ()

- (IBAction)signoutBtnPressed:(id)sender;

@end

@implementation GWSettingViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signoutBtnPressed:(id)sender
{
    [[GWAccountStore shareStore] signOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
