//
//  FXCommentDetailViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXCommentDetailViewController.h"
#import "FXCommentDetailCell.h"
#import "Common.h"
#import "FXOneRowCell.h"
#import <ShareSDK/ShareSDK.h>
#import <AVFoundation/AVFoundation.h>
#import "FXNetworking.h"
#import "FXCommentModal.h"
#import "UIImageView+WebCache.h"
#import "FXMessageModal.h"
#import "FXDatabaseManager.h"

@interface FXCommentDetailViewController () <UITableViewDataSource,UITableViewDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,AVAudioRecorderDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic) CGRect toobarFrame;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) UIImageView *backImageV;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIButton *backI;

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) UIView *menuShadowView;
@property (nonatomic, strong) UIView *scV;

@property (nonatomic, strong) UILabel *animationLabel;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) NSMutableArray *commentArray;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) NSTimer *tiemrLu;
@property (nonatomic, strong) FXCommentDetailCell *loadCell;

@property (nonatomic ,strong)UISwipeGestureRecognizer *sweipeLife;
@property (nonatomic ,strong)UISwipeGestureRecognizer *sweipeRigth;
@property (nonatomic ,strong) UIButton *button;
@property (nonatomic ,strong)UIButton *buttonlift;
@property (nonatomic)BOOL mark;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation FXCommentDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self audioLong];
//    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
//    self.tableView.allowsSelection = NO;
    self.imagesArray = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.allowsSelection = NO;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 25, 25)];
    btn.layer.cornerRadius = 25/2;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(backBBS) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgV = [[UIImageView alloc] init];
    [imgV sd_setImageWithURL:[NSURL URLWithString:self.commentModal.imgae]];
    [btn setImage:imgV.image forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(41, 8, 119*2, 44)];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = self.commentModal.author;
    self.navigationItem.titleView = label1;
    
    _btn1 = [self setupButtonWith:@"发表-返回down" selectedImgName:@"发表-返回up-white"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn1];
    [_btn1 addTarget:self action:@selector(menuShow:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXCommentDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"commentDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXOneRowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"oneRowCell"];
    self.loadCell = [self.tableView dequeueReusableCellWithIdentifier:@"commentDetailCell"];
    [self.loadCell.buttonlift addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.tf.delegate = self;
}

- (void)backBBS
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.toobarFrame = self.navigationController.toolbar.frame;
    self.navigationController.toolbar.tintColor = [UIColor lightGrayColor];
    _nameArray = @[@"发表-返回",@"内页-收藏",@"内页-评论",@"内页-分享"];
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"发表-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(backPreview)];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"内页-收藏"] style:UIBarButtonItemStyleDone target:self action:@selector(likeText)];
//    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"内页-评论"] style:UIBarButtonItemStyleDone target:self action:@selector(commentText)];
//    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"内页-分享"] style:UIBarButtonItemStyleDone target:self action:@selector(shareText)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    NSArray *array = @[item1,spaceItem,item2,spaceItem,item3,spaceItem,item4];
//    [self setToolbarItems:array];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < _nameArray.count; i++) {
        if (i > 0 && i < 4) {
            [array addObject:spaceItem];
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self creatButtonWith:[NSString stringWithFormat:@"%@",_nameArray[i]] andInteger:i+1 and:[NSString stringWithFormat:@"%@-press",_nameArray[i]]]];
        [array addObject:item];
    }
    [self setToolbarItems:array];
    NSArray *dataArr = [FXDatabaseManager selectSecretMesgByUserID:@(self.messageID)];
    if (dataArr.count != 0) {
        [self.commentArray addObjectsFromArray:dataArr];
    }else{
        [self loadDataFromServer];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
    [self.shadowView removeFromSuperview];
    [self.tf resignFirstResponder];
}

#pragma mark - load data from server

- (void)loadDataFromServer
{
    NSDictionary *parameter = @{
                                @"bbs_id":@(self.messageID)
                                };
    NSString *urlStr = [kBaseUrl stringByAppendingString:@"/hlq_api/posts/"];
    [FXNetworking sendHTTPFormatIsPost:YES andParameters:parameter andUrlString:urlStr request:NO notifationName:@"getCommentInfo"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCommentData:) name:@"getCommentInfo" object:nil];
}

#pragma mark - property init

- (UIView *)shadowView
{
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        _shadowView.backgroundColor = [UIColor colorWithRed:224/225.0 green:224/225.0 blue:224/225.0 alpha:1];
    }
    return _shadowView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView =  [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIView *)menuShadowView
{
    if (_menuShadowView == nil) {
        _menuShadowView = [[UIView alloc]initWithFrame:self.view.bounds];
        _menuShadowView.backgroundColor = [UIColor blackColor];
        _menuShadowView.alpha = 0.6;
        [self addSubviewsToMenuView];
    }
    return _menuShadowView;
}

- (UILabel *)animationLabel
{
    if (_animationLabel == nil) {
        _animationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, kWidth, 40)];
        _animationLabel.center = self.view.center;
        _animationLabel.textColor = [UIColor redColor];
        _animationLabel.text = @"正在刷新";
        _animationLabel.backgroundColor = [UIColor colorWithRed:212/225.0 green:200/225.0 blue:152/225.0 alpha:1];
        _animationLabel.textAlignment = NSTextAlignmentCenter;
        _animationLabel.textColor = [UIColor whiteColor];
    }
    return _animationLabel;
}

#pragma mark - coustom view

- (void)addImgViewToView:(UIView *)view
{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.imgView.center = CGPointMake(self.view.center.x, view.frame.size.height/2.0);
    self.imgView.image = [UIImage imageNamed:@"内页-刷新"];
    [view addSubview:self.imgView];
}

- (void)addSubviewsToMenuView
{
    CGFloat width = 30;
    CGFloat margin = 20;
    [self setupMenuItemsWithImgName:@"内页-菜单-只看楼主" hightedImgName:@"内页-菜单-只看楼主-press" shadowViewX:50 labelText:@"只看楼主" btnAction:@selector(onlyScanHost)];
    [self setupMenuItemsWithImgName:@"内页-菜单-倒叙" hightedImgName:@"内页-菜单-倒叙-press" shadowViewX:50 + width + margin labelText:@"倒序查看" btnAction:@selector(downScanInfo)];
    [self setupMenuItemsWithImgName:@"内页-菜单-举报" hightedImgName:@"内页-菜单-举报-press" shadowViewX:50 + 2*(width + margin) labelText:@"举报" btnAction:@selector(report)];
    [self setupMenuItemsWithImgName:@"内页-菜单-最赞回复" hightedImgName:@"内页-菜单-最赞回复-press" shadowViewX:50 + 3*(width + margin) labelText:@"最赞回复" btnAction:@selector(replay)];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, kWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:52/225.0 green:235/225.0 blue:123/225.0 alpha:1];
    [self.menuShadowView addSubview:lineView];
}

- (void)setupMenuItemsWithImgName:(NSString *)imgName hightedImgName:(NSString *)hightedName shadowViewX:(CGFloat)x labelText:(NSString *)text btnAction:(SEL)selector
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x, 80, 40, 50)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightedName] forState:UIControlStateHighlighted];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 40, 10)];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    [view addSubview:label];
    [view addSubview:btn];
    [self.menuShadowView addSubview:view];
}

- (UIButton *)setupButtonWith:(NSString *)imageName selectedImgName:(NSString *)selectedName
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    return btn;
}

#pragma mark - menu action

- (void)onlyScanHost
{
    [self.menuShadowView removeFromSuperview];
    self.btn1.selected = NO;
    [self.commentArray addObjectsFromArray:[FXDatabaseManager selectCommentFromLocalBy:@(self.messageID)]];
    [self.tableView reloadData];
    //书刷新tableView
}

- (void)downScanInfo
{
    [self.menuShadowView removeFromSuperview];
    self.btn1.selected = NO;
//    NSArray *array = [FXDatabaseManager selectCommentFromLocalBy:@(self.messageID)];
    //书刷新tableView
}

- (void)report
{
    [self.menuShadowView removeFromSuperview];
    self.btn1.selected = NO;
    //书刷新tableView
}

- (void)replay
{
    [self.menuShadowView removeFromSuperview];
    self.btn1.selected = NO;
    //书刷新tableView
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.commentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        FXCommentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentDetailCell" forIndexPath:indexPath];
        [cell cellDataWithCommentModal:self.commentArray[indexPath.row]];
//        [cell.buttonlift addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.imageBtn.layer.cornerRadius = 35/2;
        cell.imageBtn.layer.masksToBounds = YES;
        self.loadCell = cell;
        return cell;
    }else{
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        UIView *backgroundView = [self cellAddView];
//        [cell addSubview:backgroundView];
        FXOneRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneRowCell"];
        [cell.imageBtn addTarget:self action:@selector(luyin) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundV.layer.cornerRadius = 20;
        cell.backgroundV.layer.masksToBounds = YES;
        
        [cell setDataWithModal:self.commentModal];
        if (!_imageArray) {
            _imageArray = [NSMutableArray array];
        }
        for (int i = 0 ; i<= 10; i++) {
            [_imageArray addObject:[NSString stringWithFormat:@"%d.jpg",i]];
        }
        cell.imageScrollView.contentSize = CGSizeMake(_imageArray.count * (kWidth - 30) , 0);
        cell.imageScrollView.delegate = self;
        [self addImage:_imageArray andWith:cell.imageScrollView];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 42)];
        backgroundView.backgroundColor = [UIColor grayColor];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(291, 8, 21, 21)];
        [btn setImage:[UIImage imageNamed:@"内页-点赞-press"] forState:UIControlStateNormal];
#pragma markk ----btn
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 100, 21)];
        label.text = @"你的好友";
        label.textColor = [UIColor lightGrayColor];
        [backgroundView addSubview:btn];
        [backgroundView addSubview:label];
        return backgroundView;
    }else{
        return nil;
    }
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view;
//    if (section == 1) {
//        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
//        UIImage *image = [UIImage imageNamed:@"内页-刷新"];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.frame = CGRectMake(196/2, 8, 35, 35);
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(196/2+10 +35, 20, 80, 11)];
//        label.text = @"上拉刷新哦~";
//        label.font = [UIFont fontWithName:nil size:14];
//        label.backgroundColor = [UIColor redColor];
//        [view addSubview:imageView];
//        [view addSubview:label];
//    }
//    return (section == 1) ? view : nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FXOneRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneRowCell"];
        return [cell calculateCellHeight:self.commentModal];
    }else{
        FXCommentModal *comment = self.commentArray[indexPath.row];
        FXCommentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentDetailCell"];
        return [cell calculateCellHeight:comment];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 42.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 4) {
        NSLog(@"%@",NSStringFromCGRect(cell.frame));
        self.animationLabel.frame = CGRectMake(0, cell.frame.origin.y + cell.frame.size.height, kWidth, 44);
        [self.tableView addSubview:self.animationLabel];
        [self addImgViewToView:self.animationLabel];
        CGFloat labelHeight = self.animationLabel.frame.size.height + 44;
        [UIView animateWithDuration:2.0 animations:^{
            self.animationLabel.frame = CGRectOffset(self.animationLabel.frame, 0, - labelHeight);
        } completion:^(BOOL finished) {
            self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, M_PI);
            self.animationLabel.text = @"刷新完成";
            [UIView animateWithDuration:2.0 animations:^{
                self.animationLabel.frame = CGRectOffset(self.animationLabel.frame, 0, labelHeight);
            } completion:^(BOOL finished) {
                self.imgView.transform = CGAffineTransformIdentity;
                [self.animationLabel removeFromSuperview];
                self.animationLabel = nil;
            }];
        }];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if (section == 1) {
        [self.view addSubview:self.animationLabel];
        [self addImgViewToView:self.animationLabel];
        CGFloat labelHeight = self.animationLabel.frame.size.height + 44;
        [UIView animateWithDuration:2.0 animations:^{
            self.animationLabel.frame = CGRectOffset(self.animationLabel.frame, 0, - labelHeight);
        } completion:^(BOOL finished) {
            self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, M_PI);
            self.animationLabel.text = @"刷新完成";
            [UIView animateWithDuration:2.0 animations:^{
                self.animationLabel.frame = CGRectOffset(self.animationLabel.frame, 0, labelHeight);
            } completion:^(BOOL finished) {
                self.imgView.transform = CGAffineTransformIdentity;
                [self.animationLabel removeFromSuperview];
                self.animationLabel = nil;
            }];
        }];

    }
}

- (void)liftViewCell
{
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(kWidth -70 -20 - 10, 30, 30, 30);
    [_button setImage:[UIImage imageNamed:@"内页-点赞@2x"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(likeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.loadCell addSubview:_button];
    _buttonlift = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonlift.tag = 1005;
    _buttonlift.frame = CGRectMake(kWidth - 40 - 10 , 30, 30, 30);
    [_buttonlift setImage:[UIImage imageNamed:@"内页-评论-评论@2x"] forState:UIControlStateNormal];
    [self.loadCell addSubview:_buttonlift];
}
- (void)outLiftViewCell
{
    if (_button != nil) {
        [_buttonlift setImage:[UIImage imageNamed:@"内页-评论-评论@2x"] forState:UIControlStateNormal];
        _button.frame = CGRectMake(0, 0, 0, 0);
        
    }else{
        [_button removeFromSuperview];
        _button = nil;
        
    }
    if(_buttonlift){
        [_buttonlift removeFromSuperview];
        _buttonlift = nil;
    }
}

- (void)likeButton:(UIButton *)button
{
    if (_mark) {
        [_button setImage:[UIImage imageNamed:@"内页-点赞@2x"] forState:UIControlStateNormal];
        _mark = NO;
    }else{
        
        [_button setImage:[UIImage imageNamed:@"内页-点赞-press@2x"] forState:UIControlStateNormal];
        _mark = YES;
    }
}

#pragma mark - custom
//- (UIView *)addIamgeAndTitle:(CGRect)rect
//{
//    UIView *view;
//    view = [[UIView alloc] initWithFrame:CGRectMake(8, rect.origin.y + rect.size.height, 304, 44)];
//    view.backgroundColor = [UIColor blackColor];
//    
//    UIImage *image = [UIImage imageNamed:@"内页-刷新"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.frame = CGRectMake(196/2, 8, 35, 35);
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(196/2+10 +35, 20, 80, 11)];
//    label.text = @"上拉刷新哦~";
//    label.font = [UIFont fontWithName:nil size:14];
//    label.backgroundColor = [UIColor redColor];
//    [view addSubview:imageView];
//    [view addSubview:label];
//    _scV = view;
//    return _scV;
//}

- (void)addImage:(NSArray *)imageName andWith:(UIScrollView *)scrollView
{
    {
        for (int i = 0; i < imageName.count; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName[i]]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50 + i*(kWidth - 80), 0, kWidth - 100, 156)];
            imageView.backgroundColor = [UIColor cyanColor];
            imageView.image = image;
            [self.imagesArray addObject:imageView];
            [scrollView addSubview:imageView];
        }
    }
    [self setupShadowViewWithRectX:0];
    [self setupShadowViewWithRectX:kWidth - 30];
}

- (void)setupShadowViewWithRectX:(CGFloat)x
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    CGFloat y = cell.frame.origin.y + 65;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x, y, 30, 135)];
    view.backgroundColor = [UIColor colorWithRed:217/225.0 green:216/225.0 blue:209/225.0 alpha:0.5];
    [self.tableView addSubview:view];
}


#if 0
- (UIView *)cellAddView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 289)];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 304, 21)];
    titleL.text = @"BTOB:将在日本举行单独演唱会";
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(8, 37, 304, 21)];
    timeL.font = [UIFont fontWithName:nil size:14];
    NSString *timeData = @"2小时前";
    NSInteger like =  1;
    NSInteger comment = 2;
    NSInteger skim = 1000;
    NSInteger collect = 20;
    timeL.text = [NSString stringWithFormat:@"%@  %ld浏览  %ld赞  %ld评论  %ld收藏",timeData,(long)skim,(long)like,(long)comment,(long)collect];
    [backgroundView addSubview:titleL];
    [backgroundView addSubview:timeL];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 66, 240, 156)];
    self.scrollView.pagingEnabled = YES;
    [backgroundView addSubview:self.scrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 230, 80, 30)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, 234, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"发表-添加菜单-语音"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tiaozhuandaolunyinyemian) forControlEvents:UIControlEventTouchUpInside];
    [label addSubview:btn];
    [backgroundView addSubview:label];
    
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(8, 268, 304, 21)];
    contentL.numberOfLines = 0;
    contentL.text = @"我家爱豆据我所知被四叶草“攻击”的最严重。如果有谁的爱豆是被";
    contentL.font = [UIFont fontWithName:nil size:15.f];
    [backgroundView addSubview:contentL];
    return backgroundView;
}
#endif

- (UIButton *)creatButtonWith:(NSString *)imageName andInteger:(NSInteger)i and:(NSString *)heLightName;
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidth/4, 30)];
    btn.tag = 1000 +i;
    [btn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [btn setImage:image forState:UIControlStateNormal];
    UIImage *imageN = [[UIImage imageNamed:heLightName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [btn setImage:imageN forState:UIControlStateHighlighted];
    
    
    return btn;
}

- (void)setButtonState:(UIButton *)btn
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    label.center = self.view.center;

    if (btn.selected) {
        btn.selected = NO;
//        [_bottomV removeFromSuperview];
        [btn setImage:[UIImage imageNamed:self.nameArray[btn.tag- 1001]] forState:UIControlStateNormal];
        if (btn.tag == 1002) {
            [self animationLabel:label withText:@"取消收藏"];
        }

    }else{
//        [self addViewInVC];
        btn.selected = YES;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-press",self.nameArray[btn.tag - 1001]]] forState:UIControlStateSelected];
        for (int i =1; i < 5; i++) {
            UIButton *otherBtn = (UIButton *)[self.navigationController.toolbar viewWithTag:1000+i];
            if (btn.tag != otherBtn.tag) {
                if (otherBtn.tag != 1002) {
                    otherBtn.selected = NO;
                }
            }
        }
        if (btn.tag == 1002) {
            [self animationLabel:label withText:@"收藏"];
        }
    }
}

- (void)animationLabel:(UILabel *)label withText:(NSString *)text
{
    label.backgroundColor = [UIColor blackColor];
    label.alpha = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 20;
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];
    [UIView animateWithDuration:2.0 animations:^{
        
        label.text = text;
        label.alpha = 1;
        for (int i =1; i < 5; i++) {
            UIButton *otherBtn = (UIButton *)[self.navigationController.toolbar viewWithTag:1000+i];
            if (otherBtn.tag != 1002) {
                otherBtn.enabled = NO;
            }
        }

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
            for (int i =1; i < 5; i++) {
                UIButton *otherBtn = (UIButton *)[self.navigationController.toolbar viewWithTag:1000+i];
                otherBtn.enabled = YES;
            }
        }];
        
    }];
}

- (void)addViewInToolBar
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"内页-返回"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"内页-返回-press"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(backCommentView) forControlEvents:UIControlEventTouchUpInside];
    _tf = [[UITextField alloc] initWithFrame:CGRectMake(41, 0, 200, 40)];
    _tf.delegate = self;
    _tf.placeholder = [NSString stringWithFormat:@"评论%@:",self.commentModal.author];
    [self.shadowView addSubview:btn];
    [self.shadowView addSubview:_tf];
    [self.navigationController.toolbar addSubview:self.shadowView];
}

//- (void)showKeyBoard:(NSNotification *)notification
//{
//    self.navigationController.toolbar.frame = self.toobarFrame;
//    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    self.navigationController.toolbar.frame = CGRectOffset(self.navigationController.toolbar.frame, 0, -frame.size.height);
//}
/*
//- (void)addViewInVC
//{
//    _bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.view.frame.size.height - self.toobarFrame.size.height)];
//    _bottomV.backgroundColor = [UIColor grayColor];
//    _bottomV.alpha = 0.6;
//    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _bottomV.frame.size.height - 82, kWidth, 82)];
//    NSArray *array = @[@"复制",@"朋友圈",@"微博",@"微信",@"QQ"];
//    [self addimage:array and:scrollV];
//    [_bottomV addSubview:scrollV];
//    [self.view addSubview:_bottomV];
//}

//- (void)addimage:(NSArray *)nameArray and:(UIScrollView *)scrollV
//{
//    for (int i = 0; i < nameArray.count; i++) {
//        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"内页-分享-%@",nameArray[i]]];
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*57 +15, 20, 32, 32)];
//        btn.tag = 2000+i;
//        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(23 + i*57, 57, 32, 10)];
//        label.font = [UIFont fontWithName:nil size:10];
//        label.text = [NSString stringWithFormat:@"%@",nameArray[i]];
//        label.textColor = [UIColor whiteColor];
//        [btn setImage:img forState:UIControlStateNormal];
//        [scrollV addSubview:label];
//        [scrollV addSubview:btn];
//    }
//}
*/
- (void)addShareObject
{
    id<ISSContent> publishContent = [ShareSDK content:@"宋慧乔女神啊。。。。。十分爱你。。。大爱" defaultContent:nil image:nil title:@"韩流圈" url:nil description:nil mediaType:SSPublishContentMediaTypeText];
    id<ISSContainer> container = [ShareSDK container];
    [ShareSDK showShareActionSheet:container shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alert show];
        }else if (state == SSResponseStateFail){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                            message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];

        }
    }];
}

- (void)audioLong
{
    UInt32 enableLevelMeter = true;
    AudioQueueRef audioQueue ;
    AudioQueueSetProperty(audioQueue, kAudioQueueProperty_EnableLevelMetering, &enableLevelMeter, sizeof(UInt32));
    AudioQueueLevelMeterState levelMeter;
    UInt32 levelMeterSize = sizeof(AudioQueueLevelMeterState);
    AudioQueueGetProperty(audioQueue, kAudioQueueProperty_CurrentLevelMeterDB, &levelMeter, &levelMeterSize);
    double volume = levelMeter.mAveragePower;
    double vol = levelMeter.mPeakPower;
    NSLog(@"%lf,%lf",volume,vol);
}
#pragma mark - action ----------------

- (void)commentInfo:(UIButton *)sender
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"内页-返回"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"内页-返回-press"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(backCommentView) forControlEvents:UIControlEventTouchUpInside];
    _tf = [[UITextField alloc] initWithFrame:CGRectMake(41, 0, 200, 40)];
    _tf.delegate = self;
    _tf.placeholder = [NSString stringWithFormat:@"评论%@:",self.commentModal.author];
    [self.shadowView addSubview:btn];
    [self.shadowView addSubview:_tf];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardDidShowNotification object:nil];
    self.navigationController.toolbar.frame = self.toobarFrame;
    [self.navigationController.toolbar addSubview:self.shadowView];
}
- (void)showKeyBoard:(NSNotification *)notification
{
    self.navigationController.toolbar.frame = self.toobarFrame;
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.navigationController.toolbar.frame = CGRectOffset(self.navigationController.toolbar.frame, 0, -frame.size.height);
}

- (void)setCommentData:(NSNotification *)notification
{
    NSArray *tmpArray = [NSMutableArray arrayWithArray:notification.object];
    [FXDatabaseManager saveCommentToLocalWithArray:tmpArray];
    if (self.commentArray == nil) {
        self.commentArray = [NSMutableArray arrayWithCapacity:tmpArray.count];
    }
    FXCommentModal *comment;
    for (NSDictionary *dic in tmpArray) {
        comment = [[FXCommentModal alloc]initWithData:dic];
        [self.commentArray addObject:comment];
    }
    [self.tableView reloadData];
}

//- (void)btnAction:(id)sender
//{
//    UIButton *btn = (UIButton *)sender;
//    switch (btn.tag) {
//        case 2004:
//            
//            break;
//            
//        default:
//            break;
//    }
//}
- (void)startLuyin:(UIButton *)sender
{
//    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
//    NSError *error = nil;
//    AVCaptureDeviceInput *inputDev = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
//    if (inputDev) {
//        [captureSession addInput:inputDev];
//    }else{
//        NSLog(@"%@",error);
//        return;
//    }
//    AVCaptureAudioDataOutput *outputDev = [[AVCaptureAudioDataOutput alloc] init];
//    [captureSession addOutput:outputDev];
//    dispatch_queue_t queue = dispatch_queue_create("my", NULL);
//    [outputDev setSampleBufferDelegate:self queue:queue];
//    NSDictionary *dict = [outputDev recommendedAudioSettingsForAssetWriterWithOutputFileType:AVFileTypeCoreAudioFormat];
    self.backI.enabled = NO;
    AVAudioSession *session = [[AVAudioSession alloc] init];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setActive:YES error:&error];
    /**
     *  录音设置
     */
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //录音格式
    [dict setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //录音采样率
    [dict setObject:@(8000) forKey:AVSampleRateKey];
    //录音通道
    [dict setValue:@(1) forKey:AVNumberOfChannelsKey];
    //是否适应浮点采样
    [dict setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //录音路径
    NSURL *recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 5000.0, @"caf"]]];
    NSLog(@"%@",recordedTmpFile);
    //创建录音对象
    self.recorder = [[AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:dict error:&error];
    //设置代理
    _recorder.delegate = self;
    //检测声波
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    if (![self.recorder isRecording]){
            [_recorder record];
    }
    self.tiemrLu = [NSTimer scheduledTimerWithTimeInterval:.2f target:self selector:@selector(changeBackImageFrame) userInfo:nil repeats:YES];

}

- (void)luyin
{
    
    self.navigationController.toolbarHidden = YES;
    CGRect frame = self.view.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor grayColor];
    self.backV = view;
    [self.view addSubview:self.backV];
    view.alpha = .6;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 70, 25, 25)];
    btn.backgroundColor = [UIColor redColor];
    [btn setImage:[UIImage imageNamed:@"发表-返回"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *imgView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,234/2, 316/2)];
    imgView.center = self.view.center;
    [imgView setImage:[UIImage imageNamed:@"发表-录音底图"] forState:UIControlStateNormal];
    self.backI = imgView;
    [self.backI addTarget:self action:@selector(startLuyin:) forControlEvents:UIControlEventTouchUpInside];
    self.backImageV = [[UIImageView alloc] initWithFrame:imgView.frame];
    
    _backImageV.center = CGPointMake(imgView.center.x, imgView.center.y + imgView.frame.size.height);
    [_backImageV setImage:[UIImage imageNamed:@"发表-录音被遮罩图（随音量变化改变图片高度）"]];
//    [self.backImageV addTarget:self action:@selector(startLuyin:) forControlEvents:UIControlEventTouchUpInside];
    self.backImageV.frame = CGRectMake(0, 158, 117, 158);
    [self.backI addSubview:self.backImageV];
    self.backI.clipsToBounds = YES;
    [view addSubview:btn];
    [view addSubview:imgView];
}

- (void)removeView
{
    [self.tiemrLu invalidate];
    [_recorder stop];
    [self.backV removeFromSuperview];
    self.navigationController.toolbarHidden = NO;
}

- (void)changeBackImageFrame
{
    [self.recorder updateMeters];
    CGFloat power = [self.recorder averagePowerForChannel:0];
    NSLog(@">>>>>>>%f",power);
//    CGFloat height = (1.0/160.0)*(power+160);
//    self.backI.layer.contents = (__bridge id)(self.backI.image.CGImage);
    self.backImageV.transform = CGAffineTransformMakeTranslation(0, -power-80);
    if (self.backImageV.frame.origin.y < 0) {
//        self.backImageV.frame = CGRectMake(0, 158, 117, 158);
        self.backImageV.transform = CGAffineTransformIdentity;
    }

}

- (void)backCommentView
{
    [_tf resignFirstResponder];
    self.navigationController.toolbar.frame = self.toobarFrame;
    if (self.shadowView) {
        [self.shadowView removeFromSuperview];
        self.shadowView = nil;
    }
}

- (void)actionBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1001:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1002:
        {
            [self setButtonState:btn];
        }
            break;
       // case 1005:
        case 1003:
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardDidShowNotification object:nil];
            [self addViewInToolBar];
        }
            break;
        case 1004:
        {
//            [self setButtonState:btn];
            [self addShareObject];
        }
            break;
            
        default:
            break;
    }
}

- (void)menuShow:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected = NO;
        self.navigationController.toolbarHidden = NO;
        if (self.shadowView) {
            [self.menuShadowView removeFromSuperview];
        }
    }else{
        sender.selected = YES;
        self.navigationController.toolbarHidden = YES;
        [self.view addSubview:self.menuShadowView];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    int i = scrollView.contentOffset.x /160 ;
//    scrollView.contentOffset = CGPointMake( i * 240, 0);
    CGFloat tmpOffsetX = scrollView.contentOffset.x +kWidth /2.0;
    for (UIImageView *imageView in self.imagesArray) {
        CGFloat x1 = imageView.frame.origin.x;
        CGFloat x2 = imageView.frame.origin.x + imageView.frame.size.width;
        if (x1 <= tmpOffsetX && x2 > tmpOffsetX) {
            scrollView.contentOffset = CGPointMake(x1 - 50, 0);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
//        int i = 0;
//         i = scrollView.contentOffset.x /160;
//        scrollView.contentOffset = CGPointMake( i * 240, 0);
        CGFloat tmpOffsetX = scrollView.contentOffset.x + kWidth/2.0;
        for (UIImageView *imageView in self.imagesArray) {
            CGFloat x1 = imageView.frame.origin.x;
            CGFloat x2 = imageView.frame.origin.x + imageView.frame.size.width;
            if (x1 <= tmpOffsetX && x2 > tmpOffsetX) {
                scrollView.contentOffset = CGPointMake(x1 - 50, 0);
            }
        }

    }
}

#pragma mark - audio delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }else{
        NSString *urlStr = [kBaseUrl stringByAppendingString:@"/hlq_api/addcomment/"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        long userID = [userDefaults integerForKey:kHQL_id];
        NSDictionary *parameter = @{@"userid": @(userID),
                                    @"messageid": @(self.messageID),
                                    @"message": textField.text};
        [FXNetworking sendHTTPFormatIsPost:YES andParameters:parameter andUrlString:urlStr request:NO notifationName:@"sendComment"];
        [_tf resignFirstResponder];
        return YES;
    }
}
@end
