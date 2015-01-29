//
//  FXRegsterInfoViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXRegsterInfoViewController.h"
#import "FXMeInfoViewController.h"
#import "FXAppDelegate.h"
#import "FXMainViewController.h"
#import "Common.h"
#import "FXLoginViewController.h"
#import "ChineseToPinyin.h"
#import "FXNetworking.h"

@interface FXRegsterInfoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passwd;
@property (weak, nonatomic) IBOutlet UITextField *againPasswd;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation FXRegsterInfoViewController

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
    self.phoneNum.text = self.phoneNumStr;
}

#pragma mark - action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)login:(id)sender {
    FXLoginViewController *loginVC = [[FXLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)registers:(id)sender {
    NSString *urlStr = [kBaseUrl stringByAppendingString:@"/hlq_api/register/"];
    NSDictionary *parameter = @{@"phone": _phoneNum.text,
                                @"passcode": _passwd.text,
                                @"nickname": _userName.text};
    [FXNetworking sendHTTPFormatIsPost:YES andParameters:parameter andUrlString:urlStr request:YES notifationName:@"userInfo"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUseInfo:) name:@"userInfo" object:nil];
    [self setupButtonRect:CGRectMake(30, kHeight - 200, kWidth - 60, 30) withTitle:@". 注册成功，点击完善个人信息" action:@selector(editPersonalInfo)];
    [self setupButtonRect:CGRectMake(30, kHeight - 150, 90, 30) withTitle:@". 继续浏览" action:@selector(gotoScan)];
}

- (void)setUseInfo:(NSNotification *)noti
{
    NSLog(@"userInfo%@",noti.object);
}

- (void)editPersonalInfo
{
    FXMeInfoViewController *meInfoVC = [[FXMeInfoViewController alloc]init];
    [self.navigationController pushViewController:meInfoVC animated:YES];
}

- (void)gotoScan
{
    FXAppDelegate *appDelegate = (FXAppDelegate *)[[UIApplication sharedApplication] delegate];
    FXMainViewController *mainVC = (FXMainViewController *)appDelegate.window.rootViewController;
    [mainVC dismissViewControllerAnimated:YES completion:nil];
    mainVC.selectedIndex = 0;
}

- (void)setupButtonRect:(CGRect)rect withTitle:(NSString *)title action:(SEL)btnSelector
{
    UIButton *btn = [[UIButton alloc]initWithFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:btnSelector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)createAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"警告" message:message delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确定",nil];
    [alertV show];
}
#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{

    switch (textField.tag) {
        case 1001:
        {
            NSString *regEx = @"^[a-zA-Z0-9]{6,20}$";
            NSString *string = [ChineseToPinyin pinyinFromChiniseString:textField.text];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regEx];
            if (![predicate evaluateWithObject:string]) {
                self.registerBtn.enabled = NO;
                [self createAlertViewWithMessage:@"您输入的名字不符合规则"];
            }else{
                self.registerBtn.enabled = YES;
            }
        }
            break;
        case 1002:
        {
            NSString *regEx = @"^[a-zA-Z0-9]{6,30}$";
            NSString *string = [ChineseToPinyin pinyinFromChiniseString:textField.text];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regEx];
            if (![predicate evaluateWithObject:string]) {
                self.registerBtn.enabled = NO;
                [self createAlertViewWithMessage:@"您输入的密码不符合规则"];
            }else{
                self.registerBtn.enabled = YES;
            }
        }
            break;
        case 1003:
        {
            UITextField *tf = (UITextField *)[self.view viewWithTag:1002];
            if (![tf.text isEqualToString:textField.text]) {
                self.registerBtn.enabled = NO;
                [self createAlertViewWithMessage:@"您两次输入的密码不同"];
            }else{
                self.registerBtn.enabled = YES;
            }
        }
            break;
        default:
            break;
    }
}
@end
