//
//  FXRegisterViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXRegisterViewController.h"
#import "FXInputMasViewController.h"
#import "FXLoginViewController.h"
#import "Common.h"
#import <SMS_SDK/SMS_SDK.h>

@interface FXRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *masBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSMutableArray *areaArray;
@property (nonatomic, strong) NSString *codeStr;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation FXRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.masBtn.layer.cornerRadius = 3;
    self.masBtn.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = YES;
    self.codeStr = @"86";
}

#pragma mark - property init

- (UIAlertView *)alertView{
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"号码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
    return _alertView;
}

- (NSMutableArray *)areaArray
{
    if (_areaArray == nil) {
        _areaArray = [NSMutableArray array];
        [SMS_SDK getZone:^(enum SMS_ResponseState state, NSArray *zonesArray) {
            [_areaArray addObjectsFromArray:zonesArray];
        }];
    }
    return _areaArray;
}


#pragma mark - view delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

#pragma mark - action

- (IBAction)sendMas:(id)sender {
    int compareResult = 0;
    for (int i=0; i<self.areaArray.count; i++) {
        NSDictionary* dict1=[self.areaArray objectAtIndex:i];
        NSString* code1=[dict1 valueForKey:@"zone"];
        if ([code1 isEqualToString:self.codeStr]) {
            compareResult=1;
            NSString* rule1=[dict1 valueForKey:@"rule"];
            NSPredicate* pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
            BOOL isMatch=[pred evaluateWithObject:self.textField.text];
            if (!isMatch) {
                //手机号码不正确
                [self.alertView show];
                return;
            }
            break;
        }
    }
    
    if (!compareResult) {
        if (self.textField.text.length!=11) {
            //手机号码不正确
            [self.alertView show];
            return;
        }
    }
    
    NSString* str=[NSString stringWithFormat:@"%@:%@ %@",@"将要发送验证码到",self.codeStr,self.textField.text];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"确定发送", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    [alert show];
    
}


- (IBAction)login:(id)sender {
    FXLoginViewController *loginVC = [[FXLoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView != self.alertView) {
        if (buttonIndex == 1) {
            [SMS_SDK getVerifyCodeByPhoneNumber:self.textField.text AndZone:self.codeStr result:^(enum SMS_GetVerifyCodeResponseState state) {
                if (state == 1) {
                    NSLog(@"发送成功:%u",state);
                    FXInputMasViewController *inputVC = [[FXInputMasViewController alloc]init];
                    [self.navigationController pushViewController:inputVC animated:YES];
                    [inputVC setValue:self.textField.text forKey:@"phoneNum"];
                }else{
                    self.alertView.message = @"发送失败";
                    [self.alertView show];
                }
            }];
        }
    }
}

@end
