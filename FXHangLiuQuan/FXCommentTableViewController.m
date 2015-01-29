//
//  FXCommentTableViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15-1-9.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXCommentTableViewController.h"
#import "FXCommentTableViewCell.h"
#import "Common.h"
#import "AFNetworking.h"
#import "FXCommentModal.h"
#import "FXMessageModal.h"



@interface FXCommentTableViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *commentText;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic, strong) FXMessageModal *message;
@property (nonatomic ,strong)NSMutableArray *muatbleArrayKmici;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation FXCommentTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"评论";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FXCommentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"commentCell"];
    NSMutableDictionary *kimciDic = [NSMutableDictionary dictionary];
    [kimciDic setObject:@1  forKey:@"message_id"];
  //  [kimciDic setObject:@129 forKey:@"user_id"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXCommentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXCommentTableViewCell"];
    
    NSString *URLString = @"http://hallyu.sinaapp.com/hlq_api/comment/";
//    NSMutableDictionary *dicKmici = [NSMutableDictionary dictionary];
//    [dicKmici setObject:@129 forKey:@"sina_id"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@1 forKey:@"message_id"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *Array = [NSArray arrayWithArray:responseObject[@"data"]];
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (NSDictionary *dic in Array) {
            FXCommentModal *modal = [[FXCommentModal alloc] initWithData:dic];
            [mutableArr addObject:modal];
        }
        _dataArr = [NSArray arrayWithArray:mutableArr];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseObject);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
    
    _commentText = [[UITextField alloc] initWithFrame:CGRectMake(50, 4, 220, 36)];
    _commentText.clearButtonMode = UITextFieldViewModeAlways;
    _commentText.borderStyle = UITextBorderStyleLine;
    _commentText.delegate = self;
    [self.navigationController.toolbar addSubview:_commentText];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [_backButton setImage:[UIImage imageNamed:@"发表-返回-press"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"发表-返回-press"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth - 50, 0, 50, 44)];
    [_rightButton setTitle:@"发表" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.navigationController.toolbar addSubview:_backButton];
    [self.navigationController.toolbar addSubview:_rightButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
    [_commentText removeFromSuperview];
    [_backButton removeFromSuperview];
    [_rightButton removeFromSuperview];
}

#pragma mark - button action

- (void)backAction
{
    [_commentText resignFirstResponder];
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fasongAction
{
    
}

#pragma mark - textFeild delagate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.navigationController.toolbar.frame = CGRectMake(0, 308, 320, 45);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_commentText resignFirstResponder];
    self.navigationController.toolbar.frame = CGRectMake(0, 523, 320, 45);
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 100;
    FXCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXCommentTableViewCell"];
    return [cell cellHeight:_dataArr[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"FXCommentTableViewCell" forIndexPath:indexPath];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    commentCell.headImage.layer.cornerRadius = 35/2;
    [commentCell setMessager:_dataArr[indexPath.row]];
    commentCell.headImage.layer.cornerRadius = 80/2;
    commentCell.headImage.layer.masksToBounds = YES;
    
    return commentCell;
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
