//
//  FXSeekTableViewController.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXSeekTableViewController.h"
#import "FXPossessTableViewCell.h"

@interface FXSeekTableViewController ()<UISearchBarDelegate>
@property (nonatomic ,strong)UISearchBar *bar;
@end

@implementation FXSeekTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //self.tabBarController.tabBar.hidden = YES;
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preview_icon_highlighted"] landscapeImagePhone:[UIImage imageNamed:@"preview_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(outButton)];
        self.navigationItem.leftBarButtonItem = button;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXPossessTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXPossessTableViewCell"];
    [self loadData];
}
- (void)loadData
{
    _bar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, 0, 290, 44)];
    _bar.delegate  = self;
    _bar.showsBookmarkButton = YES;
    self.navigationController.navigationBarHidden = NO;
    _bar.placeholder = @"大家都在搜";

    [self.navigationController.navigationBar addSubview:_bar];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
#pragma mark -- 隐藏UISearchBar
    [_bar removeFromSuperview];
}

- (void)outButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 代理
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXPossessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXPossessTableViewCell" forIndexPath:indexPath];
    cell.iconImage.layer.cornerRadius = 45/2;
    cell.iconImage.layer.masksToBounds = YES;
    return cell;
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
    return 70;
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
