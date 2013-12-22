//
//  GWRegisterViewController.m
//  GuessWord
//
//  Created by Dannion on 13-12-20.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWRegisterViewController.h"
#import "GWNetWorkingWrapper.h"
#import "GWAccountStore.h"
#import "GWLevelViewController.h"
#import "UIViewController+Toast.h"

@interface GWRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)commitBtnPressed:(id)sender;
- (IBAction)loginBtnPressed:(id)sender;

@end

@implementation GWRegisterViewController

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
    self.passwordTextField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commitBtnPressed:(id)sender
{
    NSString* usename;
    NSString* mobileNum;
    NSString* password;
    if (self.usernameTextField) {
        if (self.usernameTextField.text.length>0) {
            usename = self.usernameTextField.text;
        }
    }
    if (self.passwordTextField) {
        if (self.passwordTextField.text.length>0) {
            password = self.passwordTextField.text;
        }
    }
    if (self.mobileTextField) {
        if (self.mobileTextField.text.length>0) {
            usename = self.mobileTextField.text;
        }
    }
    
    if (usename && password) {
        [self registerWithUsername:usename andMobileNumber:mobileNum andPassword:password];
    }else{
        [self showToastWithDescription:@"用户名或密码不能为空"];
    }

    
}

- (IBAction)loginBtnPressed:(id)sender
{
    [self popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RegisterToBroadcastLevel"]) {
        GWLevelViewController *destination = segue.destinationViewController;
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];//将结果存入userDefaults中
        destination.vol = [userDefaults objectForKey:@"broadcastingVol"];

    }
}

#pragma mark -
#pragma mark Internal Method

- (void)registerWithUsername:(NSString*)usename andMobileNumber:(NSString*)mobileNum andPassword:(NSString*)password
{
    //    示例：10.105.00.00/register?username=hh&password=123
    NSMutableDictionary* paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:mobileNum forKey:@"id"];
    [paraDic setObject:password forKey:@"pw"];
    [paraDic setObject:usename forKey:@"name"];
    
    [GWNetWorkingWrapper getPath:@"regist.php" parameters:paraDic successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([responseString isEqualToString:@"Successfully insert!"]) {//登陆成功
            
            [[GWAccountStore shareStore] saveToLocalCacheWithUsername:usename andPassword:password];
            [self performSegueWithIdentifier:@"RegisterToBroadcastLevel" sender:nil];
        }else{//登陆失败
            
            [self showToastWithDescription:responseString];
        }

    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showToastWithDescription:error.localizedDescription];
        
    }];
    
}



@end
