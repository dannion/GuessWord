//
//  GWLoginViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWLoginViewController.h"
#import "GWGridViewController.h"

@interface GWLoginViewController ()

- (IBAction)pressLoginBtn:(id)sender;
- (IBAction)pressGuessLoginBtn:(id)sender;

@end

@implementation GWLoginViewController

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
    [self addViewBackgroundView];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [self colorForBackground];
}

- (void)addViewBackgroundView
{
    UIView* backgroundAllView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundAllView.backgroundColor = [self colorForBackground];
    [self.view addSubview:backgroundAllView];
    [self.view sendSubviewToBack:backgroundAllView];
    
    UIButton* backgroundButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundButton.isAccessibilityElement = NO;
    backgroundButton.backgroundColor = [UIColor clearColor];
    [backgroundButton addTarget:self action:@selector(tapRequest) forControlEvents:UIControlEventTouchUpInside];
    [backgroundAllView addSubview:backgroundButton];
}

- (void)tapRequest
{
    for (UIView* aView in self.view.subviews) {
        [aView resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LoginToGrid"]) {
        GWGridViewController *destination = segue.destinationViewController;
        if ([destination respondsToSelector:@selector(setUniqueID:)])
        {
            destination.uniqueID = @10002;
            destination.volNumber = @1;
            destination.level = 0;
        }
    }
}


- (IBAction)pressLoginBtn:(id)sender
{
    [self performSegueWithIdentifier:@"LoginToGrid" sender:sender];
}

- (IBAction)pressGuessLoginBtn:(id)sender
{
    [self performSegueWithIdentifier:@"LoginToGrid" sender:sender];
}

#pragma mark -
#pragma mark Image & Color Method

- (UIColor*)colorForBackground
{
    return [UIColor colorWithRed:234.0/256 green:234.0/256 blue:234.0/256 alpha:1.0];
}

@end
