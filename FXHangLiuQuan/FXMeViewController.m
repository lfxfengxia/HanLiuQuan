//
//  FXMeViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXMeViewController.h"
#import "FXLoginViewController.h"
#import "FXRegisterViewController.h"
#import "TSPopoverController.h"
#import "FXMenuTableViewController.h"
#import "FXMeInfoViewController.h"
#import "FXSettingViewController.h"
#import "FXMainViewController.h"
#import "FXAppDelegate.h"
#import "FXIdeaViewController.h"
#import "FXAboutHanLiuQuanViewController.h"
#import "FXFansTableViewController.h"
#import "FXAttentionTableViewController.h"
#import "FXSecretMsegTableViewController.h"
#import "FXPersonalWriteTableViewCell.h"
#import "FXPersonalCommentTableViewCell.h"
#import "FXPersonalCollectionTableViewCell.h"
#import "FXContactViewController.h"
#import "FXCommentDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"
#import "FXUserModel.h"
#import "FXLoginUserInfo.h"
#import "Common.h"

#define kFXMeSectionHeader                  @"FXMeSectionHeader"
#define kFXOtherSectionHeader               @"FXOtherSectionHeader"
#define kFXPersonalWriteTableViewCell       @"FXPersonalWriteTableViewCell"
#define kFXPersonalCommentTableViewCell     @"FXPersonalCommentTableViewCell"
#define kFXPersonalCollectionTableViewCell  @"FXPersonalCollectionTableViewCell"

typedef enum{
    kWrite,
    kComment,
    kCollection
}cellType;


@interface FXMeViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIView *willShowView;
//not login property
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

//login propety
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UIButton *name;
@property (weak, nonatomic) IBOutlet UIImageView *sex;
@property (weak, nonatomic) IBOutlet UILabel *sign;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UILabel *attention;
@property (weak, nonatomic) IBOutlet UILabel *secretMseg;
@property (nonatomic, strong) NSString *addressAge;

@property (weak, nonatomic) IBOutlet UIButton *writeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;


@property (nonatomic, strong) UIImageView *shadowImgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TSPopoverController *popverCtrl;

@property (nonatomic, assign) cellType cellType;
@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, strong) UIView *sectionHeaderView;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation FXMeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"个人信息";
        UIImage *image = [[UIImage imageNamed:@"主导航-个人页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [[UIImage imageNamed:@"主导航-个人页-press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:image selectedImage:selectedImage];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.willShowView) {
        [self.willShowView removeFromSuperview];
    }
    
    if ([self.defaults boolForKey:kIsLogining]) {
        [self setLoginView];
    }else{
        [self setNotLoginView];
    }
    [self.view addSubview:self.willShowView];
}

- (void)setLoginView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/225.0 green:204/225.0 blue:112/225.0 alpha:1];
    self.navigationItem.titleView = [self setupLabel];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[self setupButton]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(modifyPersonalInfo)];
    if (self.userType == kOther) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    [self.view addSubview:self.shadowImgView];
    self.willShowView = self.tableView;
    [self.tableView registerNib:[UINib nibWithNibName:kFXPersonalWriteTableViewCell bundle:nil] forCellReuseIdentifier:kFXPersonalWriteTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:kFXPersonalCommentTableViewCell bundle:nil] forCellReuseIdentifier:kFXPersonalCommentTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:kFXPersonalCollectionTableViewCell bundle:nil] forCellReuseIdentifier:kFXPersonalCollectionTableViewCell];
    [self setUserInfo];
}

- (void)setUserInfo
{
    self.user = [[FXLoginUserInfo shareLoginUserInfo] searchLoginUserInfo];
    NSString *base64Str = self.user.icon_url;
    if (base64Str) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:data];
        [self.icon setBackgroundImage:image forState:UIControlStateNormal];
    }
    [self.name setTitle:self.user.nickName forState:UIControlStateNormal];
    NSString *gener = self.user.gender;
    if ([gener isEqualToString:@"女"]) {
        self.sex.image = [UIImage imageNamed:@"userinfo_gender_female"];
    }else{
        self.sex.image = [UIImage imageNamed:@"userinfo_gender_male"];
    }
    self.addressAge = [NSString stringWithFormat:@"%@  %@",self.user.address,self.user.age];
    self.sign.text = self.user.descriptions;
    self.fans.text = self.user.followers_count;
    self.attention.text = self.user.favourites_count;
}

- (void)setNotLoginView
{
    self.willShowView = [[NSBundle mainBundle] loadNibNamed:@"FXMeNotLoginViewController" owner:self options:nil][0];
    self.navigationController.navigationBarHidden = YES;
    self.loginBtn.layer.cornerRadius = 50;
    self.loginBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 50;
    self.registerBtn.layer.masksToBounds = YES;

}

#pragma mark - load data from server

- (void)loadDataFromServer
{
    NSString *urlStr = [kBaseUrl stringByAppendingString:@"/hlq_api/"];
    NSInteger userID = [self.defaults integerForKey:kHQL_id];
    NSDictionary *parameters = @{
                                 @"user_id":@(userID)
                                 };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response object : %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response string :%@",operation.responseString);
    }];
}

#pragma mark - property init

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        UIView *headerView;
        if (self.userType == kMe) {
            headerView = [[NSBundle mainBundle] loadNibNamed:@"FXMeLoginViewController" owner:self options:nil][0];
        }else{
            headerView = [[NSBundle mainBundle] loadNibNamed:@"FXOtherLoginViewController" owner:self options:nil][0];
        }
        
        self.icon.layer.cornerRadius = 45;
        self.icon.layer.masksToBounds = YES;
        _tableView.tableHeaderView = headerView;
        _tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)shadowImgView
{
    if (_shadowImgView == nil) {
        _shadowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -150, kWidth, 400)];
        _shadowImgView.image = [UIImage imageNamed:@"3.jpg"];
    }
    return _shadowImgView;
}

- (UIView *)bottomLine
{
    CGFloat lineWidth = 0;
    if (self.userType == kMe) {
        lineWidth = kWidth/2.0;
    }else{
        lineWidth = kWidth/3.0;
    }
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 42, lineWidth, 2)];
        _bottomLine.backgroundColor = [UIColor colorWithRed:28/225.0 green:201/225.0 blue:111/225.0 alpha:1];
    }
    return _bottomLine;
}

#pragma mark - add subviews

- (UIButton *)setupButton
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"菜单" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(menuShow:event:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UILabel *)setupLabel
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 30)];
    label.text = @"个人信息";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

#pragma mark - action
//not login action
- (IBAction)login:(id)sender {
    FXLoginViewController *loginVC = [[FXLoginViewController alloc]init];
    UINavigationController *loginNVC = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:loginNVC animated:YES completion:nil];
}

- (IBAction)register:(id)sender {
    FXRegisterViewController *registerVC = [[FXRegisterViewController alloc]init];
    UINavigationController *registerNVC = [[UINavigationController alloc]initWithRootViewController:registerVC];
    [self presentViewController:registerNVC animated:YES completion:nil];
}

- (IBAction)toogleColor:(UISwitch *)sender {
    
}

- (IBAction)toogleMseg:(UISwitch *)sender {
}

- (IBAction)clean:(id)sender {
    UILabel *cleanLabel = [self setupCleanLabel];
    [UIView animateWithDuration:2.0 animations:^{
        cleanLabel.alpha = 1.0;
        //清理数据库，清理缓存
    } completion:^(BOOL finished) {
        cleanLabel.text = @"清理完成";
       [UIView animateWithDuration:2.0 animations:^{
           cleanLabel.alpha = 0.0;
       } completion:^(BOOL finished) {
           [cleanLabel removeFromSuperview];
       }];
    }];
}

- (UILabel *)setupCleanLabel
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    label.center = self.view.center;
    label.layer.cornerRadius = 20;
    label.layer.masksToBounds = YES;
    label.text = @"正在清除";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor blackColor];
    label.alpha = 0;
    [self.view addSubview:label];
    return label;
}

- (IBAction)aboutHanLiuQuan:(id)sender {
    FXAboutHanLiuQuanViewController *aboutHLQVC = [[FXAboutHanLiuQuanViewController alloc]init];
    [self.navigationController pushViewController:aboutHLQVC animated:YES];
}

- (IBAction)score:(id)sender {
}

//login action
- (IBAction)showInfoAboutMe:(id)sender {
    FXMeInfoViewController *meInfoVC = [[FXMeInfoViewController alloc]init];
    [self.navigationController pushViewController:meInfoVC animated:YES];
}

- (void)menuShow:(UIButton *)sender event:(UIEvent *)event
{
    FXMenuTableViewController *menuVC = [[FXMenuTableViewController alloc]init];
    UINavigationController *menuNVC = [[UINavigationController alloc]initWithRootViewController:menuVC];
    menuVC.tableView.delegate = self;
    menuVC.tableView.backgroundColor = [UIColor blueColor];
    menuNVC.view.frame = CGRectMake(0, 0, 140, 140);
    self.popverCtrl = [[TSPopoverController alloc]initWithContentViewController:menuNVC];
    self.popverCtrl.popoverBaseColor = [UIColor greenColor];
    [self.popverCtrl showPopoverWithTouch:event];
}

- (void)modifyPersonalInfo
{
    FXMeInfoViewController *meInfoVC = [[FXMeInfoViewController alloc]init];
    meInfoVC.hidesBottomBarWhenPushed = YES;
    meInfoVC.user = self.user;
    [self.navigationController pushViewController:meInfoVC animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//粉丝
- (IBAction)fans:(id)sender {
    FXFansTableViewController *fansVC = [[FXFansTableViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fansVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//关注
- (IBAction)attention:(id)sender {
    FXAttentionTableViewController *attentionVC =  [[FXAttentionTableViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:attentionVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

//私信箱
- (IBAction)secretMseg:(id)sender {
    FXSecretMsegTableViewController *secretVC = [[FXSecretMsegTableViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:secretVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//联系他（她）
- (IBAction)contactHe:(id)sender {
    FXContactViewController *contactVC = [[FXContactViewController alloc]init];
    [self.navigationController pushViewController:contactVC animated:YES];
}

//发帖
- (IBAction)writeMseg:(UIButton *)sender {
    sender.selected = YES;
    [self bottomLineAnimationBySender:sender];
    self.commentBtn.selected = NO;
    self.collectionBtn.selected = NO;
    self.cellType = kWrite;
    [self.tableView reloadData];
}
//评论
- (IBAction)comment:(UIButton *)sender {
    sender.selected = YES;
    [self bottomLineAnimationBySender:sender];
    self.writeBtn.selected = NO;
    self.collectionBtn.selected = NO;
    self.cellType = kComment;
    [self.tableView reloadData];
}
//收藏
- (IBAction)collection:(UIButton *)sender {
    sender.selected = YES;
    [self bottomLineAnimationBySender:sender];
    self.writeBtn.selected = NO;
    self.commentBtn.selected = NO;
    self.cellType = kCollection;
    [self.tableView reloadData];
}

- (void)bottomLineAnimationBySender:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomLine.center = CGPointMake(sender.center.x, 43);
    }];
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.cellType == kWrite) {
        cell = [tableView dequeueReusableCellWithIdentifier:kFXPersonalWriteTableViewCell forIndexPath:indexPath];
    }else if(self.cellType == kComment){
        cell = [tableView dequeueReusableCellWithIdentifier:kFXPersonalCommentTableViewCell forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:kFXPersonalCollectionTableViewCell forIndexPath:indexPath];
    }

    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView != self.tableView) {
        return 1;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView != tableView) {
        return 44;
    }

    CGFloat cellHeight = 0;
    if (self.cellType == kWrite) {
        FXPersonalWriteTableViewCell *cell = [[FXPersonalWriteTableViewCell alloc]init];
        cellHeight = [cell heightForWriteCell];
    }else if(self.cellType == kComment){
        FXPersonalCommentTableViewCell *cell = [[FXPersonalCommentTableViewCell alloc]init];
        cellHeight = [cell heightForCommentCell];
    }else{
        FXPersonalCollectionTableViewCell *cell = [[FXPersonalCollectionTableViewCell alloc]init];
        cellHeight = [cell heightForCollectionCell];
    }

    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tableView != tableView) {
        return nil;
    }
    
    if (!self.sectionHeaderView) {
        if (self.userType == kMe) {
            self.sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:kFXMeSectionHeader owner:self options:nil][0];
        }else{
            self.sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:kFXOtherSectionHeader owner:self options:nil][0];
        }
        [self.sectionHeaderView addSubview:self.bottomLine];
    }
    return self.sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.tableView) {
        if (indexPath.row == 0) {
            FXMeInfoViewController *meInfoVC = [[FXMeInfoViewController alloc]init];
            meInfoVC.user = self.user;
            [self.navigationController pushViewController:meInfoVC animated:YES];
        }else if(indexPath.row == 1){
            [self setupAlertView];
        }else{
            FXSettingViewController *setVC = [[FXSettingViewController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
        [self.popverCtrl dismissPopoverAnimatd:YES];
    }else{
        FXCommentDetailViewController *detailVC = [[FXCommentDetailViewController alloc]init];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        detailVC.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - alert view

- (void)setupAlertView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"退出登录，将查看不到您的有关信息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

#pragma mark - action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:NO forKey:kIsLogining];
        if (self.willShowView) {
            [self.willShowView removeFromSuperview];
        }
        [self setNotLoginView];
        [self.view addSubview:self.willShowView];
    }else{
        //[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

@end
