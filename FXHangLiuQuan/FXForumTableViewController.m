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
#import "FXMeInfoViewController.h"
#import "FXNetworking.h"
#import "FXMessageModal.h"
#import "FXDatabaseManager.h"
#import "FXMeViewController.h"

@interface FXForumTableViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) FXCommentCell *loadCell;

@property (nonatomic) BOOL markKmici;

@property (nonatomic, strong) NSTimer *imageTimer;
@property (nonatomic, strong)  NSMutableArray *imageArray;

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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setNavigationBar];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FXCommentCellOther" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentCellOther"];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"FXCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"commentCell"];
   self.imageTimer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(changeImage) userInfo:nil repeats:1];
    self.loadCell = [self.tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *array = [FXDatabaseManager selectMessageFromLocal];
    if (array.count != 0) {
        if (self.arrayData == nil) {
            self.arrayData = [NSMutableArray array];
        }
        [self.arrayData addObjectsFromArray:array];
    }else{
        [self loadDataFromServer];
    }
}
#pragma mark - set navigationBar

- (void)setNavigationBar
{
    self.navigationItem.title = @"韩流圈";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/225.0 green:204/225.0 blue:112/225.0 alpha:1];
    UIButton *leftBtn = [self setupButtonWithImgName:@"toolbar_compose" highlitedImgName:@"navigationbar_compose_highlighted" action:@selector(write)];
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

- (void)write
{
    FXWriteViewController *writeVC = [[FXWriteViewController alloc]init];
    writeVC.hidesBottomBarWhenPushed = YES;
    writeVC.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:writeVC animated:YES];
    writeVC.hidesBottomBarWhenPushed = NO;
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
    if (point.x == (_imageArray.count- 1) * kWidth) {
        self.scrollView.contentOffset = CGPointMake(2 *320, 0);
    }else{
        self.scrollView.contentOffset = CGPointMake(point.x + kWidth, point.y);
    }
//    if (point.x >= (_imageArray.count- 1) * kWidth) {
//        self.scrollView.contentOffset = CGPointMake(0, point.y);
//    }else{
//        self.scrollView.contentOffset = CGPointMake(point.x + kWidth, point.y);
//    }
}

- (void)intoUserInfo
{
    FXMeViewController *meVC = [[FXMeViewController alloc]init];
    meVC.userType = kOther;
    [self.navigationController pushViewController:meVC animated:YES];
}

- (void)intoCommentView
{
    FXCommentDetailViewController *commentVC = [[FXCommentDetailViewController alloc] init];
    commentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
    commentVC.hidesBottomBarWhenPushed = NO;
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
        return _arrayData.count - 20;
    }else {
        return 5;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,kWidth , kHeight/5 +21)];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(kWidth * (_imageArray.count - 1), kHeight/5 + 21);
        self.scrollView.contentOffset =  CGPointMake(320, 0);
        if (!_imageArray) {
            _imageArray = [NSMutableArray array];
        }
        for (int i = 0 ; i<= 12; i++) {
            if (i == 0) {
                [_imageArray addObject:[NSString stringWithFormat:@"11.jpg"]];
            }else{
                [_imageArray addObject:[NSString stringWithFormat:@"%d.jpg",i-1]];
            }
        }
        [_imageArray addObject:[NSString stringWithFormat:@"0.jpg"]];
        [self addImage:_imageArray];
        [cell addSubview:self.scrollView];
        return cell;
    }else if (indexPath.section == 1){
        FXCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        cell.imageBtn.layer.cornerRadius = 15;
        cell.imageBtn.layer.masksToBounds = YES;
#pragma mark -- 添加收藏按钮
        UIButton *buttonKmici = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonKmici.frame = CGRectMake(300, 8, 12, 12);
        [buttonKmici setImage:[UIImage imageNamed:@"帖子-列表-收藏@2x"] forState:UIControlStateNormal];
        buttonKmici.tag = 10001;
        [buttonKmici addTarget:self action:@selector(kmiciButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:buttonKmici];
        [self setCellAction:cell];
        [cell setDataWithModal:_arrayData[indexPath.row]];
        return cell;
    }else {
        FXCommentCell *celll = [tableView dequeueReusableCellWithIdentifier:@"CommentCellOther"];
        UIButton *KmiciKaroa;
        UIButton *kmiciKaroaLabel;
        if (celll == nil) {
#pragma mark -------------
            celll = [[FXCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCellOther"];
        }
        KmiciKaroa = [UIButton  buttonWithType:UIButtonTypeCustom];
        KmiciKaroa.frame = CGRectMake(300, 10, 12, 12);
        [KmiciKaroa setImage:[UIImage imageNamed:@"帖子-列表-收藏@2x"] forState:UIControlStateNormal];
        [KmiciKaroa addTarget:self action:@selector(kmiciButton:) forControlEvents:UIControlEventTouchUpInside];
        [celll addSubview:KmiciKaroa];
        kmiciKaroaLabel = [[UIButton alloc] initWithFrame:CGRectMake(262, 10, 30, 12)];
        kmiciKaroaLabel.titleLabel.font = [UIFont systemFontOfSize:12];
        [kmiciKaroaLabel setTitle:@"回帖" forState:UIControlStateNormal];
        [kmiciKaroaLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [celll addSubview:kmiciKaroaLabel];
        [celll setDataKmici:_arrayData[indexPath.row]];
        return celll;
    }
}
- (void)kmiciButton:(UIButton *)button
{
    if (_markKmici) {
        [button setImage:[UIImage imageNamed:@"帖子-列表-收藏-press@2x"] forState:UIControlStateNormal];
        _markKmici = NO;
    }else{
        [button setImage:[UIImage imageNamed:@"帖子-列表-收藏@2x"] forState:UIControlStateNormal];
         _markKmici = YES;
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
        return kHeight/5 + 21;
    }else if (indexPath.section == 1){
        return 67.f;
    }else{
        return 35;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        FXCommentDetailViewController *commentDetailVC = [[FXCommentDetailViewController alloc] init];
        commentDetailVC.hidesBottomBarWhenPushed = YES;
        FXMessageModal *modal = self.arrayData[indexPath.row];
        commentDetailVC.commentModal = modal;
        commentDetailVC.messageID = modal.message_id;
        [self.navigationController pushViewController:commentDetailVC animated:YES];
    }
    if (indexPath.section == 2) {
        FXCommentDetailViewController *commm = [[FXCommentDetailViewController alloc] init];
        commm.hidesBottomBarWhenPushed = YES;
        FXMessageModal *modalCell = self.arrayData[indexPath.row];
        commm.commentModal = modalCell;
        commm.messageID = modalCell.message_id;
        [self.navigationController pushViewController:commm animated:YES];
        commm.hidesBottomBarWhenPushed = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
#pragma mark - custom 
- (void)addImage:(NSArray *)imageName
{
    for (int i = 0; i < imageName.count; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName[i]]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWidth, 0, kWidth, kHeight/5)];
        imageView.backgroundColor = [UIColor cyanColor];
        imageView.image = image;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * kWidth + 15, kHeight/5 , kWidth - 30, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == imageName.count - 1) {
            label.text = @"#1秀出你喜欢的韩国文化#";
        }else if(i == 0){
            label.text = @"#12秀出你喜欢的韩国文化#";
        }else{
            label.text = [NSString stringWithFormat:@"#%d秀出你喜欢的韩国文化#",i];
        }
        [self.scrollView addSubview:imageView];
        [self.scrollView addSubview:label];
    }
}

- (void)setCellAction:(FXCommentCell *)cell
{
    [cell.imageBtn addTarget:self action:@selector(intoUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [cell.nameBtn addTarget:self action:@selector(intoUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentBtn addTarget:self action:@selector(intoCommentView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadDataFromServer
{
    NSString *urlString = [kBaseUrl stringByAppendingString:@"/hlq_api/thread/"];
    NSDictionary *parameter = @{@"since_id": @56,
                                @"refresh": @1,
                                @"refresh_hot": @1};
    [FXNetworking sendHTTPFormatIsPost:YES andParameters:parameter andUrlString:urlString request:YES notifationName:@"backMessage"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDataWithMessage:) name:@"backMessage" object:nil];
}

- (void)setDataWithMessage:(NSNotification *)noti
{
    NSArray *array = noti.object;
    [FXDatabaseManager saveMessageToLocalWithArray:array];
    FXMessageModal *modal;
    for (NSDictionary *dict in array) {
        if (!_arrayData) {
            _arrayData = [NSMutableArray array];
        }
        modal = [[FXMessageModal alloc] initWithData:dict];
        [_arrayData addObject:modal];
    }
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
       // UITableViewController *cov =
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.imageTimer invalidate];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (![scrollView isKindOfClass:[UITableView class]]) {
        if (scrollView.contentOffset.x/kWidth == _imageArray.count - 1) {
            scrollView.contentOffset = CGPointMake(kWidth, 0);
        }
        if (scrollView.contentOffset.x < 160) {
            scrollView.contentOffset = CGPointMake(kWidth * (_imageArray.count - 2), 0);
        }
        self.imageTimer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(changeImage) userInfo:nil repeats:1];
    }
}
@end
