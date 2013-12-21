//
//  GWHomeViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWHomeViewController.h"
#import "GWAccountStore.h"
#import "GWGridViewController.h"
#import "GWLoginViewController.h"

@interface GWHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *liveGameBtn;
- (IBAction)liveGameBtnPressed:(id)sender;

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
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [self colorForBackground];
    self.liveGameBtn.enabled = NO;
    
    
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
//    if ([segue.identifier isEqualToString:@"HomeToGrid"]) {
//        GWGridViewController *destination = segue.destinationViewController;
//        if ([destination respondsToSelector:@selector(setUniqueID:)])
//        {
//            destination.volNumber = @101001;
//            destination.level = 0;
//        }
//    }
    if ([segue.identifier isEqualToString:@"HomeToLogin"]){
        GWLoginViewController *destination = segue.destinationViewController;
        //
    }
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark -
#pragma mark Image & Color Method

- (UIColor*)colorForBackground
{
    return [UIColor colorWithRed:234.0/256 green:234.0/256 blue:234.0/256 alpha:1.0];
}

#pragma mark -
#pragma mark Button Action

- (IBAction)liveGameBtnPressed:(id)sender
{
    if (0){//[[GWAccountStore shareStore] hasLogined]) {
        [self performSegueWithIdentifier:@"HomeToGrid" sender:nil];
        
    }else{
        [self performSegueWithIdentifier:@"HomeToLogin" sender:nil];
    }
    
}


@end
