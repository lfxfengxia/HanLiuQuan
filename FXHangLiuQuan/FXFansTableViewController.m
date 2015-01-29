//
//  FXFansTableViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXFansTableViewController.h"
#import "FXFansTableViewCell.h"
#import "FXOnePersonalTableViewController.h"
#import "Common.h"
#import "FXMessageModal.h"
#import "FXUserModel.h"
#import "FXCommentModal.h"
#import "FXSecretMesg.h"
#import "AFNetworking.h"

@interface FXFansTableViewController ()
@property (nonatomic ,strong)NSMutableArray *FXkmici;
@property (nonatomic)BOOL mark;
@end

@implementation FXFansTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preview_icon_highlighted"] landscapeImagePhone:[UIImage imageNamed:@"preview_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(outButton)];
        self.navigationItem.leftBarButtonItem = button;
        UIBarButtonItem *rigthBarButtton = [[UIBarButtonItem alloc] initWithTitle:@"我的关注列表" style:UIBarButtonItemStyleDone target:self action:@selector(likeButton)];
        self.navigationItem.rightBarButtonItem = rigthBarButtton;
#pragma mark -- 添加标题
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        titleLable.font = [UIFont boldSystemFontOfSize:17.0f];
        titleLable.text = @"我的粉丝";
        titleLable.textColor = [UIColor blackColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLable;
        }
    return self;
}
#pragma mark -- 隐藏tabBar
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXFansTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXFansTableViewCell"];
    NSString *urllString = @"http://hallyu.sinaapp.com/hlq_api/follower/";
    NSMutableDictionary *FansKmici = [NSMutableDictionary   dictionary];
    [FansKmici setObject:@129 forKey:@"user_id"];
    [FansKmici setObject:@1 forKey:@"type"];
    AFHTTPRequestOperationManager *merge = [AFHTTPRequestOperationManager manager];
    merge.requestSerializer = [AFJSONRequestSerializer serializer];
    [merge POST:urllString parameters:FansKmici success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *kmiciA = [NSArray  arrayWithArray:responseObject[@"data"]];
        NSMutableArray *mutAKmici = [NSMutableArray array];
        for (NSMutableDictionary *fansMuKmici in kmiciA) {
            FXUserModel *userKmici = [[FXUserModel alloc] initWithDictionary:fansMuKmici];
            [mutAKmici addObject:userKmici];
        }
        _FXkmici = [NSMutableArray arrayWithArray:mutAKmici];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseObject);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source
- (void)outButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- likeButton   添加粉丝列表
- (void)likeButton
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _FXkmici.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXFansTableViewCell" forIndexPath:indexPath];
    cell.IconImage.layer.cornerRadius = 45/2;
    cell.IconImage.layer.masksToBounds = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kWidth - 30, 18, 20, 20);
    button.tag = indexPath.row;
    [button setImage:[UIImage imageNamed:@"关注列表-取消关注-press@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    [cell setFansKmiciNumb:_FXkmici[indexPath.row]];
    return cell;
}
- (void)button:(UIButton *)button
{
    if (self.mark) {
        [button setImage:[UIImage imageNamed:@"关注列表-取消关注-press@2x"] forState:UIControlStateNormal];
        self.mark = NO;
    }else{
        [button setImage:[UIImage imageNamed:@"粉丝列表-关注@2x"] forState:UIControlStateNormal];
        self.mark = YES;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXFansTableViewCell"];
    return [cell cellFansKmiciHeight];
}

@end
