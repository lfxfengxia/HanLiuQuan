//
//  FXAttentionTableViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXAttentionTableViewController.h"
#import "FXSecretMsegTableViewCell.h"
#import "FXOnePersonalTableViewController.h"
#import "FXSeekTableViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "FXUserModel.h"

@interface FXAttentionTableViewController ()
@property (nonatomic)BOOL mark;
@property (nonatomic ,strong)NSMutableArray *yuanKmici;
@end

@implementation FXAttentionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preview_icon_highlighted"] landscapeImagePhone:[UIImage imageNamed:@"preview_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(outButton)];
        self.navigationItem.leftBarButtonItem = button;
#pragma mark --- 搜索
        UIBarButtonItem *seek = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(WeekButton)];
        self.navigationItem.rightBarButtonItem = seek;
        //UIBarButtonItem *buttonDelete = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"私信列表-删除"] style:UIBarButtonItemStyleDone target:self action:@selector(deleteButton)];
        //self.navigationItem.rightBarButtonItem = buttonDelete;
#pragma mark -- 添加标题
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        titleLable.font = [UIFont boldSystemFontOfSize:17.0f];
        titleLable.text = @"点击与我的关注某某聊天";
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
#pragma mark -- 添加 Nib
    [self.tableView registerNib:[UINib nibWithNibName:@"FXSecretMsegTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXSecretMsegTableViewCell"];
#pragma mark -- 网络添加
    NSString *stringUrl = @"http://hallyu.sinaapp.com/hlq_api/get_message/";
    NSMutableDictionary *cid = [NSMutableDictionary dictionary];
    [cid setObject:@129 forKey:@"user_id"];
    [cid setObject:@2 forKey:@"type"];
    AFHTTPRequestOperationManager *magena = [AFHTTPRequestOperationManager manager];
    magena.requestSerializer = [AFJSONRequestSerializer serializer];
    [magena POST:stringUrl parameters:cid success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *arrarKeoar = [NSArray arrayWithArray:responseObject[@"data"]];
        NSMutableArray *mutableKeoar = [NSMutableArray array];
        for (NSDictionary *dic in arrarKeoar) {
            FXUserModel *model = [[FXUserModel alloc] initWithDictionary:dic];
            [mutableKeoar addObject:model];
        }
        _yuanKmici = [NSMutableArray arrayWithArray:mutableKeoar];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseObject);
    }];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)outButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)WeekButton
{
    FXSeekTableViewController *seek = [[FXSeekTableViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:seek animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _yuanKmici.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXSecretMsegTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXSecretMsegTableViewCell" forIndexPath:indexPath];
    cell.iconImage.layer.cornerRadius = 45/2;
    cell.iconImage.layer.masksToBounds = YES;
    [cell.name addTarget:self action:@selector(nextButtonView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kWidth - 30, 18, 20, 20);
    button.tag = indexPath.row;
    [button addTarget:self action:@selector(ButtonView:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"他人-导航-加好友-press@2x"] forState:UIControlStateNormal];
    [cell addSubview:button];
    [cell setSecretKimciNumb:_yuanKmici[indexPath.row]];
    return cell;
}
- (void)ButtonView:(UIButton *)button
{
    if (self.mark) {
        [button setImage:[UIImage imageNamed:@"他人-导航-加好友-press@2x"] forState:UIControlStateNormal];
        self.mark = NO;
    }else {
        [button setImage:[UIImage imageNamed:@"粉丝列表-相互@2x"] forState:UIControlStateNormal];
        self.mark = YES;
    }
}
- (void)nextButtonView
{
    FXOnePersonalTableViewController *onePersonal = [[FXOnePersonalTableViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:onePersonal animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXSecretMsegTableViewCell   *cell = [tableView dequeueReusableCellWithIdentifier:@"FXSecretMsegTableViewCell"];
   return  [cell cellSeceretKmiciHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
#pragma mark -- 出发下一个页面 已关闭
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FXOnePersonalTableViewController *onePersonal = [FXOnePersonalTableViewController alloc];
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController   pushViewController:onePersonal animated:YES];
////    self.hidesBottomBarWhenPushed = NO;
//}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
;
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
