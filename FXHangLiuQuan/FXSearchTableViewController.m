//
//  FXSearchTableViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/5.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXSearchTableViewController.h"
#import "Common.h"

@interface FXSearchTableViewController ()

@property (nonatomic,strong) UITextField *textField;

@end

@implementation FXSearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBar];
}

#pragma mark - set navigation bar

- (void)setNavigationBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/225.0 green:204/225.0 blue:112/225.0 alpha:1];
    [self setupBackBtn];
    [self setupTextField];
    [self setupCancelBtn];
}

#pragma mark - add subviews

- (void)setupBackBtn
{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回_press"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:backBtn];
}

- (void)setupTextField
{
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(45, 10, kWidth - 55, 30)];
    self.textField.borderStyle = UITextBorderStyleLine;
    self.textField.placeholder = @"请输入搜索关键词";
    [self.navigationController.navigationBar addSubview:self.textField];
}

- (void)setupCancelBtn
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth - 45, 11, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"搜索-删除"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"搜索-删除-press"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(textFieldLostFirstResign) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btn];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma mark - action

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldLostFirstResign
{
    [self.textField resignFirstResponder];
}

@end
