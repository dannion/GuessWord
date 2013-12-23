//
//  GWHomeViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-17.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWHomeViewController.h"
#import "GWAccountStore.h"
#import "GWLevelViewController.h"
#import "GWLoginViewController.h"
#import "GWNetWorkingWrapper.h"
#import "UIViewController+Toast.h"
#import "CDVol+Interface.h"
#import "GWAppDelegate.h"

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

- (NSDictionary*)parseResponseData:(NSData*)jsonData
{
    NSDictionary* resultDic;
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil){
        if (![jsonObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Json数据错误");
            return nil;
        }
        
        resultDic = (NSDictionary*)jsonObject;
    }
    return resultDic;
    
}

- (void)handleResponseData:(NSDictionary*)responseDic
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];//将结果存入userDefaults中
    
    if (responseDic) {
        NSString* isBroadcasting = (NSString*)[responseDic objectForKey:@"broad"];
        if (isBroadcasting) {
            if ([isBroadcasting isEqualToString:@"NO"]) {//如果不是正在直播
                
                [userDefaults setBool:NO forKey:@"isBroadcasting"];
                [userDefaults synchronize];
                
                return;
            }
            if ([isBroadcasting isEqualToString:@"YES"]) {//正在直播,则直播按钮可点击，并记录下直播期号和开锁关卡
                
                self.liveGameBtn.enabled = YES;
                
                GWAppDelegate *appDelegate=(GWAppDelegate *)[[UIApplication sharedApplication]delegate];
                NSManagedObjectContext *context = appDelegate.managedObjectContext;

                NSDictionary* broadVolDic = [responseDic objectForKey:@"broad_vol"];
                CDVol* broadcastingVol = [CDVol cdVolWithVolDictionary:broadVolDic inManagedObjectContext:context];//CDVol提供方法，解析数据生成vol实例
             
                if (broadcastingVol) {
                    [userDefaults setBool:YES forKey:@"isBroadcasting"];
                    [userDefaults setObject:broadcastingVol forKey:@"broadcastingVol"];
                    [userDefaults synchronize];

                }
                
            }
        }
    }

}


- (void)refetchDataFromNetWork
{
    [GWNetWorkingWrapper getPath:@"broadcast.php" parameters:nil successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        //对返回值进行判断
        NSDictionary* responseDic = [self parseResponseData:responseObject];
        [self handleResponseData:responseDic];
        
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showToastWithDescription:error.localizedDescription];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"HomeToLogin"]){
    
    }
    if ([segue.identifier isEqualToString:@"HomeToBroadcastLevel"]){
        
        GWLevelViewController *destination = segue.destinationViewController;
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];//将结果存入userDefaults中

        destination.vol = [userDefaults objectForKey:@"broadcastingVol"];
        
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
    if ([[GWAccountStore shareStore] hasLogined]) {
        [self performSegueWithIdentifier:@"HomeToBroadcastLevel" sender:nil];
        
    }else{
        [self performSegueWithIdentifier:@"HomeToLogin" sender:nil];
    }
    
}


@end
