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
    
    cell.label.text = @"123321";
    cell.imageView.image = [UIImage imageNamed:@"1.jpeg"];
    
    return cell;
}


@end















