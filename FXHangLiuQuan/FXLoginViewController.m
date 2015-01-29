//
//  FXAboutMeTableViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXLoginViewController.h"
#import "FXRegisterViewController.h"
#import "FXQQLoginViewController.h"
#import "FXSinaLoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "FXMainViewController.h"
#import "FXAppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "Common.h"


@interface FXLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *textBackgrdView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *paswdTextField;


@end

@implementation FXLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view = [[NSBundle mainBundle]loadNibNamed:@"FXLoginViewController" owner:self options:nil][0];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.textBackgrdView.layer.cornerRadius = 3;
    self.textBackgrdView.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - action

- (IBAction)registerAccount:(id)sender {
    FXRegisterViewController *registerVc = [[FXRegisterViewController alloc]init];
    [self presentViewController:registerVc animated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    NSString *urlStr = [kBaseUrl stringByAppendingString:@"/hlq_api/login/"];
    NSDictionary *parameters = @{
                                 @"phone":self.phoneTextField.text,
                                 @"passcode":self.paswdTextField.text
                                 };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response object : %@",responseObject);
        [self changeUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response string :%@",operation.responseString);
    }];
    
}

- (void)changeUI
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:kIsLogining];
    [defaults synchronize];
    
    FXAppDelegate *appDelegate = (FXAppDelegate *)[[UIApplication sharedApplication] delegate];
    FXMainViewController *mainVC = (FXMainViewController *)appDelegate.window.rootViewController;
    [mainVC dismissViewControllerAnimated:YES completion:nil];
    mainVC.selectedIndex = 2;
}

- (IBAction)qqLogin:(id)sender {
    FXQQLoginViewController *qqLoginVC = [[FXQQLoginViewController alloc]init];
    [self.navigationController pushViewController:qqLoginVC animated:YES];
}

- (IBAction)sinaLogin:(id)sender {
    FXSinaLoginViewController *sinaLoginVC = [[FXSinaLoginViewController alloc]init];
    [self.navigationController pushViewController:sinaLoginVC animated:YES];
}

#pragma mark - view delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *subview in self.textBackgrdView.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subview;
            if ([textField isFirstResponder]) {
                [textField resignFirstResponder];
            }
        }
    }
}

@end
