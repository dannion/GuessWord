//
//  GWScoreViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-19.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWScoreViewController.h"
#import "GWScoreCell.h"

NSString *GWScoreViewCellIdentifier = @"GWScoreViewCellIdentifier";

@interface GWScoreViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *scoreTableView;

@end

@implementation GWScoreViewController

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
//    self.scoreTableView.delegate = self;
    self.view.backgroundColor = [UIColor colorWithRed:248.0/256 green:244.0/256 blue:241.0/256 alpha:1.0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    GWScoreCell* cell = [tableView dequeueReusableCellWithIdentifier:GWScoreViewCellIdentifier];
    
    if (!cell) {
        cell = [[GWScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GWScoreViewCellIdentifier];
    }
    
    cell.rankLabel.text = @"1";
    cell.nameLabel.text = @"Matlab";
    cell.scoreLabel.text = @"2222";
    
    return cell;
}


@end















