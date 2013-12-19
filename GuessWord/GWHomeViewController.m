//
//  GWHomeViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWHomeViewController.h"

@interface GWHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *liveGameBtn;

@end

@implementation GWHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [self colorForBackground];
    //self.liveGameBtn.enabled = NO;
    
    
    [self loadData];//访问网络，更新vol数据，用以确定是否直播，用来确定直播按钮是否可点击
    
}

#pragma mark -
#pragma mark LoadData
- (void)loadData
{
    //从网络取
    [self refetchDataFromNetWork];
    
}

- (void)refetchDataFromLocalCache
{
    
}

- (void)refetchDataFromNetWork
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -
#pragma mark Image & Color Method

- (UIColor*)colorForBackground
{
    return [UIColor colorWithRed:234.0/256 green:234.0/256 blue:234.0/256 alpha:1.0];
}

@end
