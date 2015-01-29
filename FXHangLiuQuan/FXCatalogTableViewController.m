//
//  FXCatalogTableViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/5.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXCatalogTableViewController.h"
#import "Common.h"
#import "FXNewsTableViewCell.h"
#import "FXNewsTableViewController.h"

@interface FXCatalogTableViewController ()

@end

@implementation FXCatalogTableViewController

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
    UIButton *backBtn = [self setupBackButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *titleBtn = [self setupTitleButton];
    self.navigationItem.titleView = titleBtn;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FXNewsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"newsCell"];
}

#pragma mark - add subviews

- (UIButton *)setupTitleButton
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    btn.center = CGPointMake(kWidth/2, 60);
    [btn setTitle:self.catalogName forState:UIControlStateNormal];
    return btn;
}

- (UIButton *)setupBackButton
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 40, 60, 40)];
    [btn setImage:[UIImage imageNamed:@"preview_icon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"preview_icon_highlighted"] forState:UIControlStateHighlighted];
    [btn setTitle:self.catalogName forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - action

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    // Configure the cell...
    FXNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXNewsTableViewController *newsView = [[FXNewsTableViewController alloc] init];
    newsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsView animated:YES];
}

@end
