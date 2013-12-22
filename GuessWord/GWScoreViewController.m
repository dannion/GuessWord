//
//  GWScoreViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-19.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWScoreViewController.h"
#import "GWScoreCell.h"
#import "GWNetWorkingWrapper.h"
#import "GWAccountStore.h"
#import "UIViewController+Toast.h"

NSString *GWScoreViewCellIdentifier = @"GWScoreViewCellIdentifier";

@interface GWScoreViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* rankArray;
}
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userrank;
@property (weak, nonatomic) IBOutlet UILabel *userscore;

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
    self.view.backgroundColor = [UIColor colorWithRed:248.0/256 green:244.0/256 blue:241.0/256 alpha:1.0];
    
    self.scoreTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.userscore.hidden = YES;
    
    [self loadData];
}

- (void)loadData
{
    //逻辑：访问网络获取新数据，如果有新数据，展现新数据。
    
    //从网络取
    [self refetchDataFromNetWork];
    
}



- (void)refetchDataFromNetWork
{
    if (self.volNumber) {//如果有volNumber，则展示的是volNumber期的排名
        
        [self refetchRankDataFromNetwork];
        
    }else{//否则展示的是闯关模式的排名
        
        [self refetchOfflineRankDataFromNetWork];
        
    }
}


- (void)refetchRankDataFromNetwork
{
    NSMutableDictionary* paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.volNumber forKey:@"vol"];
    
    GWAccount* account = [[GWAccountStore shareStore] currentAccount];
    if (account) {
        [paraDic setObject:account.username forKey:@"user"];
    }
    
    [GWNetWorkingWrapper getPath:@"rank.php" parameters:paraDic successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dict = [self parseResponseData:responseObject];

        [self handleResponseData:dict];
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showToastWithDescription:error.localizedDescription];
    }];
    
}

- (void)refetchOfflineRankDataFromNetWork
{
    NSMutableDictionary* paraDic = [NSMutableDictionary dictionary];
    
    GWAccount* account = [[GWAccountStore shareStore] currentAccount];
    if (account) {
        [paraDic setObject:account.username forKey:@"user"];
    }
    
    
    [GWNetWorkingWrapper getPath:@"offlinerank.php" parameters:paraDic successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dict = [self parseResponseData:responseObject];
        
        [self handleResponseData:dict];
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showToastWithDescription:error.localizedDescription];
    }];
}

- (NSDictionary*)parseResponseData:(NSData*)jsonData
{
    NSDictionary* resultDic;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil){

        if ([jsonObject isKindOfClass:[NSArray class]]) {
            //目前错误的接口返回数据是将所需的字典存在一个数组中，故做以下处理，当以后接口数据正常后，可将该条件判断语句删除
            NSArray* tempArray = (NSArray*)jsonObject;
            resultDic = (NSDictionary*)[tempArray lastObject];
        }else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            resultDic = (NSDictionary*)jsonObject;
        }else{
            NSLog(@"Json数据错误");
            return nil;
        }
        
    }
    return resultDic;
    
}

- (void)handleResponseData:(NSDictionary*)responseDic
{
    rankArray = [responseDic objectForKey:@"top"];
    [self.scoreTableView reloadData];
   
    if ([[GWAccountStore shareStore] hasLogined]) {
        self.username.text = [GWAccountStore shareStore].currentAccount.username;
        
         NSNumber* rank = [responseDic objectForKey:@"rank"];
        if (rank) {
            self.userrank.text = [NSString stringWithFormat:@"第%d名", [rank intValue]];
        }
    }
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
    if (rankArray) {
        return rankArray.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    GWScoreCell* cell = [tableView dequeueReusableCellWithIdentifier:GWScoreViewCellIdentifier];
    
    if (!cell) {
        cell = [[GWScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GWScoreViewCellIdentifier];
    }
    
    NSDictionary* rankInfo = [rankArray objectAtIndex:indexPath.row];
    NSString* username = (NSString*)[rankInfo objectForKey:@"ID"];
    NSNumber* score = (NSNumber*)[rankInfo objectForKey:@"SCORE"];
    
    //后续这些字段都是从服务器获取。
    int rank = indexPath.row + 1;
    if (rank == 1) {
        cell.crownImageView.hidden = NO;
    }else{
        cell.crownImageView.hidden = YES;
    }
    cell.rankLabel.text = [NSString stringWithFormat:@"%d", rank];
    cell.nameLabel.text = username;
    cell.scoreLabel.text = [NSString stringWithFormat:@"%@", score];
    
    cell.userInteractionEnabled = NO;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line_icon.png"]];
//    imageView.frame = CGRectMake(0, 0, 200, 2);
//    return imageView;
//}

@end















