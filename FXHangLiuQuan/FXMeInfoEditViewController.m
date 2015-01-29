//
//  FXMeInfoEditViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/10.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXMeInfoEditViewController.h"


@interface FXMeInfoEditViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation FXMeInfoEditViewController

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.textView.delegate = self;
    if (self.editType == kEditName) {
        self.promptLabel.text = @"起个名字吧...";
    }else{
        self.promptLabel.text = @"你的个人签名是...";
    }
    [self.view addSubview:self.promptLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - property init

- (UILabel *)promptLabel
{
    if (_promptLabel == nil) {
        _promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.textView.frame.origin.y, 200, 40)];
        _promptLabel.textColor = [UIColor lightGrayColor];
        _promptLabel.font = [UIFont systemFontOfSize:15];
    }
    return _promptLabel;
}

#pragma mark - text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.promptLabel removeFromSuperview];
    self.promptLabel = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [self.textView addSubview:self.promptLabel];
    }
    if (self.editType == kEditName) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeName" object:self.textView.text];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSign" object:self.textView.text];
    }
}

#pragma mark - view delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

@end
