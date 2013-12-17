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
	// Do any additional setup after loading the view.
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
    [self performSegueWithIdentifier:@"LoginToGrid" sender:nil];
}
@end
