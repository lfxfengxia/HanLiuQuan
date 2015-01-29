//
//  FXHomeTableViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXHomeViewController.h"
#import "FXSearchTableViewController.h"
#import "FXCatalogTableViewController.h"
#import "Common.h"
#import "FXNewsTableViewCell.h"
#import "FXNewsTableViewController.h"
#import "FXCruxTableViewCell.h"
#import "AFNetworking.h"
#import "FXMessageModal.h"

@interface FXHomeViewController () <UISearchBarDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *shadowView;

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIView *searBarShadow;

@property (nonatomic,strong) NSArray *newsData;



@property (nonatomic, strong) UITableView *newsTableView;

@end

@implementation FXHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"韩流圈";
        UIImage *image = [[UIImage imageNamed:@"主导航-资讯"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selectedImage = [[UIImage imageNamed:@"主导航-资讯-press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:nil image:image selectedImage:selectedImage];
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor grayColor];
    [self setNavigationBar];
    [self setNewsTableView];
    
    NSString *nsString = @"http://hallyu.sinaapp.com/hlq_api/news/";
    NSMutableDictionary *dicKmici = [NSMutableDictionary dictionary];
    [dicKmici setObject:@129 forKey:@"sina_id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:nsString parameters:dicKmici success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        //NSArray *homeKmiciArray = [NSArray arrayWithArray:responseObject[@"data"]];
        NSArray *homeKmiciArray = responseObject[@"data"];
        NSMutableArray *mutableKmiciArray = [NSMutableArray array];
        for (NSDictionary *dicKmici in homeKmiciArray) {
            FXMessageModal *modal = [[FXMessageModal alloc]initWithData:dicKmici];
        [mutableKmiciArray addObject:modal];
        }
        _dataArr = [NSArray arrayWithArray:mutableKmiciArray];
        [self.newsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseObject);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbar.hidden = YES;
}

#pragma mark - property init

- (UIView *)shadowView
{
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 44)];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.6;
    }
    return _shadowView;
}
//未用
- (UIView *)searBarShadow
{
    if (_searBarShadow == nil) {
        _searBarShadow = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth - 40, 44)];
        _searBarShadow.backgroundColor = [UIColor colorWithRed:29/225.0 green:204/225.0 blue:112/225.0 alpha:1];
    }
    return _searBarShadow;
}

#pragma mark - set navigationBar

- (void)setNavigationBar
{
    self.navigationItem.title = @"韩流圈";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:29/225.0 green:204/225.0 blue:112/225.0 alpha:1];
    UIButton *leftBtn = [self setupButtonAsLeftItem];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIButton *rightBtn = [self setupButtonWithImageName:@"搜索" highlitedImgName:@"搜索-press" action:@selector(searchInfo:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

- (void)setNewsTableView
{
    _newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped];
    _newsTableView.delegate = self;
    _newsTableView.dataSource = self;
    [_newsTableView registerNib:[UINib nibWithNibName:@"FXCruxTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cruxCell"];
    [_newsTableView registerNib:[UINib nibWithNibName:@"FXNewsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"newsCell"];
    _newsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_newsTableView];
}

#pragma mark - setup subviews

- (UIButton *)setupButtonWithImageName:(NSString *)imageName highlitedImgName:(NSString *)highlitedImgName action:(SEL)selector
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 2, 30, 30)];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlitedImgName] forState:UIControlStateHighlighted];
    btn.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 0, 0);
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *)setupButtonAsLeftItem
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 2, 40, 40)];
    [btn addTarget:self action:@selector(synthesizeInfo:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"综合" forState:UIControlStateNormal];
    [btn setTitle:@"综合" forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.imageView = [self setupImageView];
    [btn addSubview:self.imageView];
    return btn;
}

- (UIImageView *)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 17, 12, 10)];
    imageView.image = [UIImage imageNamed:@"筛选箭头"];
    return imageView;
}

- (UIScrollView *)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 80)];
    scrollView.contentSize = CGSizeMake(kWidth * 2, 80);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self controlViewRectX:10 addToView:scrollView btnImgName:@"筛选类别-综合" highlitedImgName:@"筛选类别-综合-press" lableText:@"综合" btnAction:@selector(synthesize:)];
    [self controlViewRectX:60 addToView:scrollView btnImgName:@"筛选类别-影视" highlitedImgName:@"筛选类别-影视-press" lableText:@"影视" btnAction:@selector(video:)];
    [self controlViewRectX:110 addToView:scrollView btnImgName:@"筛选类别-音乐" highlitedImgName:@"筛选类别-音乐-press" lableText:@"音乐" btnAction:@selector(music:)];
    [self controlViewRectX:160 addToView:scrollView btnImgName:@"筛选类别-明星" highlitedImgName:@"筛选类别-明星-press" lableText:@"明星" btnAction:@selector(star:)];
    [self controlViewRectX:210 addToView:scrollView btnImgName:@"筛选类别-时尚" highlitedImgName:@"筛选类别-时尚-press" lableText:@"时尚" btnAction:@selector(fashion:)];
    [self controlViewRectX:260 addToView:scrollView btnImgName:@"筛选类别-文化" highlitedImgName:@"筛选类别-文化-press" lableText:@"文化" btnAction:@selector(culture:)];
    
    return scrollView;
}

- (void)controlViewRectX:(CGFloat)x addToView:(UIView *)view btnImgName:(NSString *)imageName highlitedImgName:(NSString *)highlitedName lableText:(NSString *)text btnAction:(SEL)selector
{
    UIView *subview = [[UIView alloc]initWithFrame:CGRectMake(x, 10, 40, 50)];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlitedName] forState:UIControlStateHighlighted];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 30, 15)];
    label.font = [UIFont systemFontOfSize:13];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [subview addSubview:label];
    [subview addSubview:btn];
    [view addSubview:subview];
}

//未用
- (void)setupSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(30, 0, kWidth - 30, 44)];
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.searBarShadow addSubview:searchBar];
}
//未用
- (void)setupBackBtn
{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 6, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回_press"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.searBarShadow addSubview:backBtn];
}
//未用
#pragma mark - searchBar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
}

#pragma mark - action

- (void)synthesizeInfo:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected = NO;
        self.imageView.image = [UIImage imageNamed:@"筛选箭头"];
        
        if (self.shadowView) {
            [self.shadowView removeFromSuperview];
            self.shadowView = nil;
        }
        
    }else{
        sender.selected = YES;
        self.imageView.image = [UIImage imageNamed:@"筛选箭头up"];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 75, kWidth, 1)];
        view.backgroundColor = [UIColor greenColor];
        [self.shadowView addSubview:[self setupScrollView]];
        [self.shadowView addSubview:view];
        [self.view addSubview:self.shadowView];

    }
}

- (void)pushViewControllerDeliverValueBySender:(UIButton *)sender
{
    FXCatalogTableViewController *catalogVC = [[FXCatalogTableViewController alloc]init];
    
    [self.navigationController pushViewController:catalogVC animated:YES];
    NSString *btnTitle = [sender titleForState:UIControlStateNormal];
    catalogVC.catalogName = btnTitle;
}

- (void)synthesize:(UIButton *)sender
{
    if (self.shadowView) {
        [self.shadowView removeFromSuperview];
    }
    self.imageView.image = [UIImage imageNamed:@"筛选箭头"];
}

- (void)video:(UIButton *)sender
{
    [self pushViewControllerDeliverValueBySender:sender];
}

- (void)music:(UIButton *)sender
{
    [self pushViewControllerDeliverValueBySender:sender];
}

- (void)star:(UIButton *)sender
{
    [self pushViewControllerDeliverValueBySender:sender];
}

- (void)fashion:(UIButton *)sender
{
    [self pushViewControllerDeliverValueBySender:sender];
}

- (void)culture:(UIButton *)sender
{
    [self pushViewControllerDeliverValueBySender:sender];
}

- (void)searchInfo:(UIButton *)sender
{
    FXSearchTableViewController *searchVC = [[FXSearchTableViewController alloc]init];
    UINavigationController *searchNVC = [[UINavigationController alloc]initWithRootViewController:searchVC];
    [self presentViewController:searchNVC animated:YES completion:nil];
}
//未用
- (void)dismiss
{
    if (self.searBarShadow) {
        [self.searBarShadow removeFromSuperview];
        self.searBarShadow = nil;
    }
    if (self.shadowView) {
        [self.shadowView removeFromSuperview];
        self.shadowView = nil;
    }
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 180;
    } else {
        return 135;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return _dataArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        FXCruxTableViewCell *cruxCell = [tableView dequeueReusableCellWithIdentifier:@"cruxCell" forIndexPath:indexPath];
        [cruxCell setMessagerBoay:_dataArr[indexPath.row]];
        return cruxCell;
    } else {
        FXNewsTableViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
        [newsCell setMessagerBoay:_dataArr[indexPath.row]];
        return newsCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        FXNewsTableViewController *newsView = [[FXNewsTableViewController alloc] init];
        newsView.modal = _dataArr[indexPath.row];
        newsView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsView animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        newsView.modal = _dataArr[indexPath.row];
    }
}
@end
