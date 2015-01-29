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
@interface FXCommentDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation FXCommentDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [btn setImage:[UIImage imageNamed:@"发表-返回down"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(downMenu) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXCommentDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"commentDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXOneRowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"oneRowCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.tintColor = [UIColor lightGrayColor];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"发表-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(backPreview)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"内页-收藏"] style:UIBarButtonItemStyleDone target:self action:@selector(likeText)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"内页-评论"] style:UIBarButtonItemStyleDone target:self action:@selector(commentText)];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"内页-分享"] style:UIBarButtonItemStyleDone target:self action:@selector(shareText)];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *array = @[item1,spaceItem,item2,spaceItem,item3,spaceItem,item4];
    [self setToolbarItems:array];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
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
        return 5;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        FXCommentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentDetailCell" forIndexPath:indexPath];
        
        
        return cell;
    }else{
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        UIView *backgroundView = [self cellAddView];
//        [cell addSubview:backgroundView];
        FXOneRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneRowCell"];
        cell.backgroundV.layer.cornerRadius = 20;
        cell.backgroundV.layer.masksToBounds = YES;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 42)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(291, 8, 21, 21)];
        [btn setImage:[UIImage imageNamed:@"内页-点赞-press"] forState:UIControlStateNormal];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 40, 21)];
        label.text = @"你的好友";
        label.textColor = [UIColor lightGrayColor];
        [backgroundView addSubview:btn];
        [backgroundView addSubview:label];
        return backgroundView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 289;
    }else{
        return 100;
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

#pragma mark - custom
- (void)addImage:(NSArray *)imageName
{
    {
        for (int i = 0; i < imageName.count; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName[i]]];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWidth- 15, 0, kWidth - 30, 156)];
            imageView.backgroundColor = [UIColor cyanColor];
            imageView.image = image;
            [self.scrollView addSubview:imageView];
        }
    }
}

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

#pragma mark - action
- (void)tiaozhuandaolunyinyemian
{
    
}

- (void)downMenu
{
    
}

- (void)backPreview
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)likeText
{
    
}

- (void)commentText
{
    
}

- (void)shareText
{
    
}

@end
