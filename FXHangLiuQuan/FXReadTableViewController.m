//
//  FXReadTableViewController.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXReadTableViewController.h"
#import "FXPossessTableViewCell.h"
#import "Common.h"
#import "TSPopover/TSActionSheet.h"
#import "AFNetworking/AFNetworking.h"
#import "FXSecretMesg.h"

@interface FXReadTableViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic)BOOL mark;
@property (nonatomic ,strong)NSMutableArray *yuanArray;
@end

@implementation FXReadTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preview_icon_highlighted"] landscapeImagePhone:[UIImage imageNamed:@"preview_icon@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(outButton)];
        self.navigationItem.leftBarButtonItem = button;
        UIBarButtonItem *buttonDelete = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"私信列表-删除"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteButton)];
        self.navigationItem.rightBarButtonItem = buttonDelete;
#pragma mark -- 添加标题
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        titleLable.font = [UIFont boldSystemFontOfSize:17.0f];
        titleLable.text = @"标记内容列表";
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
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"私信列表-菜单-标记已读-press"] landscapeImagePhone:[UIImage imageNamed:@"私信列表-删除"] style:UIBarButtonItemStyleDone target:self action:@selector(showActionSheet:forEvent:)];
    self.navigationItem.rightBarButtonItem = barButton;
    [self.tableView registerNib:[UINib nibWithNibName:@"FXPossessTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXPossessTableViewCell"];
#pragma mark -- 网络请求
    NSString *stringURL = @"http://hallyu.sinaapp.com/hlq_api/read_message/";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@129 forKey:@"user_id"];
    [dic setObject:@11 forKey:@"linkmans_id"];
    //[dic setObject:@1 forKey:@"success"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:stringURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = [NSArray arrayWithArray:responseObject[@"data"]];
        NSMutableArray *arrayMutableKmici = [NSMutableArray array];
        for (NSDictionary * kmiciDic in array) {
            FXSecretMesg *mesg = [[FXSecretMesg alloc] initWithData:kmiciDic];
            [arrayMutableKmici addObject:mesg];
        }
        _yuanArray = [NSMutableArray arrayWithArray:arrayMutableKmici];
        [self.tableView reloadData];
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"+++++%@...............",operation.responseString);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -- 未用
-(void) showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"bbbbbbb"];
    
    [actionSheet destructiveButtonWithTitle:@"查看标记" block:^{
    }];
    [actionSheet addButtonWithTitle:@"删除标记" block:^{
    }];
    [actionSheet addButtonWithTitle:@"取消标记" block:^{
    }];
    actionSheet.cornerRadius = -100;
    [actionSheet showWithTouch:event];
}

#pragma mark - Table view data source
- (void)outButton
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)deleteButton
{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _yuanArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXPossessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXPossessTableViewCell" forIndexPath:indexPath];
    cell.imageView.layer.cornerRadius = 45/2;
    cell.imageView.layer.masksToBounds = YES;
    UIButton *button  = [[UIButton alloc] init];
    button.frame = CGRectMake(kWidth - 30, 18, 20, 20 );
    button.tag = indexPath.row;
    [button setImage:[UIImage imageNamed:@"私信列表-未标记"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Button:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    //[cell MessageKimciHeight:_yuanArray[indexPath.row]];
    [cell setMessageKmiciNunb:_yuanArray[indexPath.row]];
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
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXPossessTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"FXPossessTableViewCell"];
   return [cell cellMessageKimciHeight];
}
#pragma mark --alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s",__func__);
}
@end
