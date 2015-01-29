//
//  FXDeleteTableViewController.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXDeleteTableViewController.h"
#import "FXPossessTableViewCell.h"
#import "Common.h"

@interface FXDeleteTableViewController ()
@property (nonatomic)BOOL mark;
@property (nonatomic ,strong)NSMutableArray *arrayKmici;

@property (nonatomic,strong) NSMutableArray *selectedArr;
@property (nonatomic,strong) NSMutableArray *secretMesg;

@end

@implementation FXDeleteTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preview_icon_highlighted"] landscapeImagePhone:[UIImage imageNamed:@"preview_icon@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(outButton)];
        self.navigationItem.leftBarButtonItem = button;
#pragma mark -- 添加标题
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        titleLable.font = [UIFont boldSystemFontOfSize:17.0f];
        titleLable.text = @"删除好友";
        titleLable.textColor = [UIColor blackColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLable;
#pragma mark -- 隐藏tabBar
        self.tabBarController.tabBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrayKmici = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"FXPossessTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXPossessTableViewCell"];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    NSArray *tmpArr = @[
                        @{@"name":@"侠",@"seek":@"呵呵。。。。",@"img":@"1.jpg"},
                        @{@"name":@"小庆",@"seek":@"哈哈。。。。",@"img":@"2.jpg"},
                        @{@"name":@"梁原",@"seek":@"嘿嘿。。。。",@"img":@"3.jpg"},
                        @{@"name":@"张溢",@"seek":@"呵呵。。。。",@"img":@"4.jpg"},
                        @{@"name":@"呵呵",@"seek":@"哈哈。。。。",@"img":@"5.jpg"},
                        @{@"name":@"嘿嘿",@"seek":@"嘿嘿。。。。",@"img":@"6.jpg"},
                        ];
    self.secretMesg = [NSMutableArray arrayWithArray:tmpArr];
}

#pragma mark -- 点击事件   未用
- (void)removebutton
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"返回" message:@"确认删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
#pragma mark - Table view data source
- (void)outButton
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.secretMesg.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXPossessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXPossessTableViewCell" forIndexPath:indexPath];
    cell.iconImage.layer.cornerRadius = 45/2;
    cell.iconImage.layer.masksToBounds = YES;
    UIButton *button  = [[UIButton alloc] init];
    button.frame = CGRectMake(kWidth - 30, 18, 20, 20 );
    button.tag = indexPath.row;
    [button setImage:[UIImage imageNamed:@"私信列表-未标记"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Button:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    NSDictionary *tmpDic = self.secretMesg[indexPath.row];
    [cell cellDataWithdictionary:tmpDic];
    return cell;
}
- (void)Button:(UIButton *)button
{
    if (self.mark) {
        [button setImage:[UIImage imageNamed:@"私信列表-未标记"] forState:UIControlStateNormal];
        self.mark = NO;
    }else{
        [button setImage:[UIImage imageNamed:@"私信列表-标记"] forState:UIControlStateNormal];
        self.mark = YES;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark --- 删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedArr == nil) {
        self.selectedArr = [NSMutableArray array];
    }
    [self.selectedArr addObject:indexPath];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(delete)];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedArr removeObject:indexPath];
}

//系统Delete触发事件 未用
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    [self.secretMesg removeObjectAtIndex:index];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - action

- (void)delete
{
    //数据源的删除
//    [self.secretMesg removeObjectsInArray:self.selectedArr];
    for (NSIndexPath *indexPath in self.selectedArr) {
        [self.secretMesg removeObjectAtIndex:indexPath.row];
    }
    //UI界面的删除
    [self.tableView deleteRowsAtIndexPaths:self.selectedArr withRowAnimation:UITableViewRowAnimationRight];
    [self.selectedArr removeAllObjects];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView reloadData];
}

@end
