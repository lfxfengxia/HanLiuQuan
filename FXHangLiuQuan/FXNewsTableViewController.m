//
//  FXNewsTableViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXNewsTableViewController.h"
#import "FXMainBodyTableViewCell.h"
#import "Common.h"
#import "FXCommentTableViewController.h"
#import "FXMessageModal.h"
#import "FXUserModel.h"
#import "FXSecretMesg.h"
#import "AFNetworking.h"
#import "FXCommentModal.h"
#import "FXDatabaseManager.h"
#import <ShareSDK/ShareSDK.h>

@interface FXNewsTableViewController ()

@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic ,strong) NSArray *KmiciArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FXNewsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXMainBodyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXMainBodyTableViewCell"];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbar.tintColor = [UIColor lightGrayColor];
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.allowsSelection = NO;
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = NO;
    _KmiciArray = @[@"发表-返回-press",@"内页-收藏",@"内页-评论",@"内页-分享"];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < _KmiciArray.count; i++) {
        if (i > 0 && i < 4) {
            [array addObject:spaceItem];
        }
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self creatButtonWith:[NSString stringWithFormat:@"%@",_KmiciArray[i]] andInteger:i+1]];
        [array addObject:item];
    }
    [self setToolbarItems:array];
}

- (UIButton *)creatButtonWith:(NSString *)imageName andInteger:(NSInteger)i
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidth/4, 30)];
    btn.tag = 1000 +i;
    btn.center = CGPointMake(self.navigationController.toolbar.center.x - (2-i + 0.5) *kWidth/4 , self.navigationController.toolbar.center.y);

    [btn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
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
    [UIView animateWithDuration:1.0 animations:^{
        
        label.text = text;
        label.alpha = 1;
        for (int i = 1; i < 5; i++) {
            UIButton *otherBtn = (UIButton *)[self.navigationController.toolbar viewWithTag:1000+i];
            if (otherBtn.tag != 1002) {
                otherBtn.enabled = NO;
            }
        }
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
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

- (void)setButtonState:(UIButton *)btn
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    label.center = self.view.center;
    
    if (btn.selected) {
        btn.selected = NO;
        [btn setImage:[UIImage imageNamed:self.nameArray[btn.tag - 1001]] forState:UIControlStateNormal];
        if (btn.tag == 1002) {
            [self animationLabel:label withText:@"取消收藏"];
        }
    }else{
        btn.selected = YES;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-press",self.nameArray[btn.tag - 1001]]] forState:UIControlStateSelected];
        for (int i = 1; i < 5; i++) {
            UIButton *otherBtn = (UIButton *)[self.navigationController.toolbar viewWithTag:1000 + i];
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

#pragma mark - Button action

- (void)actionBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1001:
            [self setButtonState:btn];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1002:
            [self setButtonState:btn];
            break;
        case 1003:
            [self setButtonState:btn];
            [self commentButton];
            break;
        case 1004:
            [self setButtonState:btn];
            [self shareButton];
            break;
        default:
            break;
    }
}

- (void)commentButton
{
    FXCommentTableViewController *commentTableView = [[FXCommentTableViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentTableView];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)shareButton
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        FXMainBodyTableViewCell *mainBodyCell = [tableView dequeueReusableCellWithIdentifier:@"FXMainBodyTableViewCell"];
        CGFloat sizeFloat = [mainBodyCell cellHeight:_modal];

        return sizeFloat;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        FXMainBodyTableViewCell *mainBodyCell = [tableView dequeueReusableCellWithIdentifier:@"FXMainBodyTableViewCell" forIndexPath:indexPath];
#pragma mark ---- 未知
        [mainBodyCell setMessagerBoay:_modal];
        mainBodyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mainBodyCell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"点赞"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"已经有xxx人喜欢这篇文章了";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
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
