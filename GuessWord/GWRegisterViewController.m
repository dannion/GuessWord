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
#import "GWGridViewController.h"

@interface GWRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)commitBtnPressed:(id)sender;

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
    
    if (usename && password) {
        [self registerWithUsername:usename andPassword:password];
    }else{
        [self showToastWithDescription:@"用户名或密码不能为空"];
    }

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LoginToGrid"]) {
        GWGridViewController *destination = segue.destinationViewController;
        if ([destination respondsToSelector:@selector(setUniqueID:)])
        {
            destination.volNumber = @101001;
            destination.level = 0;
        }
    }
}

#pragma mark -
#pragma mark Internal Method

- (void)registerWithUsername:(NSString*)usename andPassword:(NSString*)password
{
    //    示例：10.105.00.00/register?username=hh&password=123
    NSMutableDictionary* paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:usename forKey:@"id"];
    [paraDic setObject:password forKey:@"pw"];
    [paraDic setObject:usename forKey:@"name"];
    
    [GWNetWorkingWrapper getPath:@"regist.php" parameters:paraDic successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSString* responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([responseString isEqualToString:@"Successfully insert!"]) {//登陆成功
            
            [[GWAccountStore shareStore] saveToLocalCacheWithUsername:usename andPassword:password];
            [self performSegueWithIdentifier:@"RegisterToGrid" sender:nil];
        }else{//登陆失败
            
            [self showToastWithDescription:responseString];
        }

    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self showToastWithDescription:error.localizedDescription];
        
    }];
    
}

- (void)showToastWithDescription:(NSString*)description
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor whiteColor];
    hud.labelTextColor = [UIColor blueColor];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = description;
    [hud hide:YES afterDelay:1.5];
}



@end
