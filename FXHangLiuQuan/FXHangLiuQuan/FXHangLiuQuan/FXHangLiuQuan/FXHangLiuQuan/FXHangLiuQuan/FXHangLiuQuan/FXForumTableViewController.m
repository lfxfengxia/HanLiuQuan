//
//  FXMessageTableViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXForumTableViewController.h"
#import "FXSearchTableViewController.h"
#import "FXWriteViewController.h"
#import "Common.h"
#import "FXCommentCell.h"
#import "FXCommentDetailViewController.h"

@interface FXForumTableViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation FXForumTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UIImage *image = [[UIImage imageNamed:@"主导航-论坛"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [[UIImage imageNamed:@"主导航-论坛-press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:image selectedImage:selectedImage];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBar];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FXCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"commentCell"];
    [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(changeImage) userInfo:nil repeats:1];
}

#pragma mark - set navigationBar

- (void)setNavigationBar
{
    self.navigationItem.title = @"韩流圈";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/225.0 green:204/225.0 blue:112/225.0 alpha:1];
    UIButton *leftBtn = [self setupButtonWithImgName:@"navigationbar_compose" highlitedImgName:@"navigationbar_compose_highlighted" action:@selector(back)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIButton *rightBtn = [self setupButtonWithImgName:@"搜索" highlitedImgName:@"搜索-press" action:@selector(search)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

}

#pragma mark - setup button

- (UIButton *)setupButtonWithImgName:(NSString *)imgName highlitedImgName:(NSString *)highlitedName action:(SEL)selector
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlitedName] forState:UIControlStateHighlighted];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - action

- (void)back
{
    FXWriteViewController *writeVC = [[FXWriteViewController alloc]init];
    [self.navigationController pushViewController:writeVC animated:YES];
}

- (void)search
{
    FXSearchTableViewController *searchVC = [[FXSearchTableViewController alloc]init];
    UINavigationController *searchNVC = [[UINavigationController alloc]initWithRootViewController:searchVC];
    [self presentViewController:searchNVC animated:YES completion:nil];
}

- (void)changeImage
{
    CGPoint point = self.scrollView.contentOffset;
    if (point.x >= 5 * kWidth) {
        self.scrollView.contentOffset = CGPointMake(0, point.y);
    }else{
        self.scrollView.contentOffset = CGPointMake(point.x + kWidth, point.y);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 5;
    }else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
//    }
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,kWidth , kHeight/5)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(kWidth * 5, kHeight/5);
        [cell addSubview:self.scrollView];
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        return cell;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return .1f;
    }else{
        return 21;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 121.f;
    }else if (indexPath.section == 1){
        return 67.f;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        FXCommentDetailViewController *commentDetailVC = [[FXCommentDetailViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentDetailVC];
        commentDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentDetailVC animated:YES];
    }
}

#pragma mark - custom 
- (void)addImage:(NSArray *)imageName
{
    for (int i = 0; i < imageName.count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName[i]]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWidth- 15, 0, kWidth - 30, kHeight/5)];
        imageView.backgroundColor = [UIColor cyanColor];
        imageView.image = image;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * kWidth - 15, 100, kWidth - 30, 21)];
        label.backgroundColor = [UIColor blackColor];
        label.text = [NSString stringWithFormat:@"#%d秀出你喜欢的韩国文化#",i];
        [self.scrollView addSubview:imageView];
        [self.scrollView addSubview:label];
    }
}
@end
