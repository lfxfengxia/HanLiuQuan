//
//  FXSecretMsegTableViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXSecretMsegTableViewController.h"
#import "TSActionSheet.h"
#import "FXPossessTableViewCell.h"
#import "FXDeleteTableViewController.h"
#import "FXReadTableViewController.h"
#import "FXOnePersonalTableViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "FXUserModel.h"
@interface FXSecretMsegTableViewController ()
@property (nonatomic ,strong)UIView *shadowView;
@property(nonatomic,getter=isSelected) BOOL selected;
@property (nonatomic) BOOL isFirst;
@property (nonatomic,strong) UIView *viewAlpha;
@property (nonatomic)BOOL mark;
@property (nonatomic ,strong) NSMutableArray *kmiciArray;
@end

@implementation FXSecretMsegTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preview_icon_highlighted"] landscapeImagePhone:[UIImage imageNamed:@"preview_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(outButton)];
        self.navigationItem.leftBarButtonItem = button;
        UIBarButtonItem *buttonOne = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"私信列表-菜单-press"] style:UIBarButtonItemStyleDone target:self action:@selector(ESMButtonOne:)];
        _isFirst = YES;

        self.navigationItem.rightBarButtonItem = buttonOne;
#pragma mark -- 添加标题
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        titleLable.font = [UIFont boldSystemFontOfSize:17.0f];
        titleLable.text = @"私信箱";
        titleLable.textColor = [UIColor blackColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = titleLable;
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *buttonToolBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"他人-导航-私信"] style:UIBarButtonItemStyleDone target:self action:@selector(nextBarButton)];
    buttonToolBar.width = 300;
    self.toolbarItems = @[buttonToolBar];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXPossessTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXPossessTableViewCell"];
#pragma mark -- 网络请求
    NSString *urlKaoer = @"http://hallyu.sinaapp.com/hlq_api/get_message/";
    NSMutableDictionary *array = [NSMutableDictionary dictionary];
    [array setObject:@129 forKey:@"user_id"];
    [array setObject:@2 forKey:@"type"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlKaoer parameters:array success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *secret = [NSArray arrayWithArray:responseObject[@"z"]];
        NSMutableArray *secretArray = [NSMutableArray array];
        for (NSDictionary *dic in secret) {
            FXUserModel *userModel = [[FXUserModel alloc] initWithDictionary:dic];
            [secretArray addObject:userModel];
        }
        _kmiciArray = [NSMutableArray arrayWithArray:secretArray];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseObject);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -- property init
//- (UIView *)shadowView
//{
//    if (_shadowView == nil) {
//        _shadowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        _shadowView.backgroundColor = [UIColor blackColor];
//        _shadowView.alpha = 0.6;
//        [self.view addSubview:_shadowView];
//    }
//    return _shadowView;
//}


#pragma mark - Table view data source
- (void)nextBarButton
{
    FXOnePersonalTableViewController *onePersonal = [[FXOnePersonalTableViewController   alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:onePersonal animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)outButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)ESMButtonOne:(UIBarButtonItem *)tap
{
    UIView *xianView;
    if (_isFirst == YES) {
        _isFirst = NO;
        _viewAlpha = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _viewAlpha.backgroundColor = [UIColor blackColor];
        _viewAlpha.alpha = 0.8;
        [self.view addSubview:_viewAlpha];
#pragma mark -- 加线
        xianView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 1)];
        xianView.backgroundColor = [UIColor redColor];
        [_viewAlpha addSubview:xianView];
#pragma mark -- 图标
        NSArray *buttonDelete = @[@"私信列表-菜单-删除-press@2x",@"私信列表-菜单-标记已读-press@2x"];
#pragma mark -- 字体
        NSArray *lableDelete = @[@"删除", @"已读"];
        for (int i = 0; i < buttonDelete.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(130+ (50 * i), 15, 30, 50);
            if (i == 0) {
               [button addTarget:self action:@selector(sendList) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [button addTarget:self action:@selector(sendListOne) forControlEvents:UIControlEventTouchUpInside];
            }
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            imgView.image = [UIImage imageNamed:buttonDelete[i]];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 30, 20)];
            label.text = lableDelete[i];
            label.font = [UIFont fontWithName:nil size:11];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            [button addSubview:label];
            [button addSubview:imgView];
            [_viewAlpha addSubview:button];

        }

    }else if (_isFirst == NO){
            [_viewAlpha removeFromSuperview];
        _isFirst = YES;
    }
    
}
- (void)DeleteButton:(UIButton *)tap
{
    
}
#pragma mark -- 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _kmiciArray.count;
}
#pragma mark -- 点击事件
- (void)sendList
{
    FXDeleteTableViewController *delete = [[FXDeleteTableViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:delete animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)sendListOne
{
    FXReadTableViewController   *read = [[FXReadTableViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:read animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXPossessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXPossessTableViewCell" forIndexPath:indexPath];
    cell.iconImage.layer.cornerRadius = 45/2;
    cell.iconImage.layer.masksToBounds = YES;
    UIButton *button  = [[UIButton alloc] init];
    button.frame = CGRectMake(kWidth - 30, 18, 20, 20 );
    button.tag = indexPath.row;
    [button setImage:[UIImage imageNamed:@"关注列表-取消关注@2x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Button:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    [cell setSecretKimciNumb:_kmiciArray[indexPath.row]];
    return cell;
}
- (void)Button:(UIButton *)button
{
    if (self.mark) {
        [button setImage:[UIImage imageNamed:@"粉丝列表-关注@2x"] forState:UIControlStateNormal];
        self.mark = NO;
    }else{
        [button setImage:[UIImage imageNamed:@"关注列表-取消关注@2x"] forState:UIControlStateNormal];
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
    FXPossessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXPossessTableViewCell"];
    return  [cell cellSeceretKmiciHeight];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
