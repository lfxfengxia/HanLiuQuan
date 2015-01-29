//
//  FXOnePersonalTableViewController.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-6.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXOnePersonalTableViewController.h"
//#import "FXOnePersonalTableViewCell.h"
#import "Common.h"
#import "Message.h"
//#import "EmptionPicker.h"
#import <AVFoundation/AVFoundation.h>
#import "FXPersonalTableViewCell.h"

typedef enum {
    typedefIsMe = 1,
    typedefIsYou = 0
}typedefIs;


@interface FXOnePersonalTableViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,UIScrollViewDelegate,AVAudioPlayerDelegate>
{
    UIButton        *_timeButton;
    UIImageView     *_iconView;
    UIButton        *_contentButton;
    AVAudioRecorder *_recorder;
    AVAudioPlayer   *_player;
   
}
@property (nonatomic ,strong)UIView *shadowView;
@property (nonatomic ,strong)UITextField *field;
@property (nonatomic ,strong) NSMutableArray *mutableKmiciFrame;
@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic)CGRect toolBarFrame;
@property (nonatomic)BOOL isMe;
@property (nonatomic)CGSize seziKmici;
@property (nonatomic ,assign)typedefIs typedefIsis;
@property (nonatomic ,strong)UITableView *tab;

@property (nonatomic, strong)UIView *image;
@property (nonatomic, strong)UIImageView *sendImage;
@property (nonatomic, strong)NSNotification *notificaton;
@property (nonatomic ,strong)NSTimer *yuanTimer;
@property (nonatomic ,strong)AVCaptureDevice *device;
@property (nonatomic ,strong)AVCaptureDeviceInput *input;
@property (nonatomic ,strong)AVCaptureSession *session;
@property (nonatomic ,strong)AVCaptureMetadataOutput *output;
@property (nonatomic ,strong)UIImageView *imageyuan;

@property (nonatomic, strong) NSArray *tmpArry;
@property (nonatomic, strong) NSMutableArray *timeArray;

@end
//static NSInteger num = 0;

@implementation FXOnePersonalTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _mutableKmiciFrame = [NSMutableArray array];
    _timeArray = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXPersonalTableViewCellYou" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXPersonalTableViewCellYou"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FXPersonalTableViewCellMe" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXPersonalTableViewCellMe"];
    self.toolBarFrame = self.navigationController.toolbar.frame;
    //[self.tableView registerNib:[UINib nibWithNibName:@"FXOnePersonalTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FXOnePersonalTableViewCell"];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"私信列表-删除"]  landscapeImagePhone:[UIImage imageNamed:@"私信列表-菜单-删除-press"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    _image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"发表-录音被遮罩图（随音量变化改变图片高度）@2x"]];
    _image.frame = CGRectMake(110, -250, 100, 100);
    _image.backgroundColor = [UIColor brownColor];
    _image.layer.cornerRadius = 150/2;
    _image.layer.masksToBounds = YES;
    _image.alpha = 0.5f;
    _imageyuan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"发表-录音底图@2x"]];
    _imageyuan.frame = CGRectMake(25, 25, 50, 50);
    [_image addSubview:_imageyuan];
    [self.navigationController.toolbar addSubview:_image];
    _yuanTimer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(SHAOHUObutton) userInfo:nil repeats:YES];
    _image.hidden = YES;
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}
- (void)SHAOHUObutton
{
    _imageyuan.frame = CGRectOffset(_imageyuan.frame, 0, 15);
    if (_imageyuan.frame.origin.y >= _imageyuan.frame.size.height) {
        _imageyuan.frame = CGRectMake(25, -_imageyuan.frame.size.height/2 + 50, _imageyuan.frame.size.width, _imageyuan.frame.size.height);
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%d",self.navigationController.toolbarHidden);
    self.navigationController.toolbarHidden = NO;
    self.toolBarFrame = self.navigationController.toolbar.frame ;
    self.navigationController.toolbar.backgroundColor = [UIColor colorWithRed:225/225.0 green:215/225.0 blue:220/225.0 alpha:1];
    [self loadButton];
    [self.view addSubview:self.sendImage];
    [self GoReading];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeShadowView];
    for (UIView *subview in self.navigationController.toolbar.subviews) {
        [subview removeFromSuperview];
    }
    self.navigationController.toolbarHidden = YES;
    [_sendImage removeFromSuperview];
    [self outShaoMiao];
}

#pragma mark -- 开始扫描
- (void)GoReading
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    _session = session;
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (_input) {
        [_session addInput:_input];
        
    }else{
        NSLog(@"%@",error);
        return;
    }
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_session addOutput:_output];
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [_output setMetadataObjectsDelegate:self queue:queue];
    NSArray *types = [_output availableMetadataObjectTypes];
    [_output setMetadataObjectTypes:types];
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [layer setFrame:self.view.layer.bounds];
    [_session startRunning];
    
}
#pragma mark --- 结束扫描
- (void)outShaoMiao
{
    [_session stopRunning];
}
#pragma mark - property init

- (UIImageView *)sendImage
{
    if (_sendImage == nil) {
        _sendImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _sendImage.center = self.view.center;
    }
    return _sendImage;
}

- (void)loadButton
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"preview_icon_highlighted"] landscapeImagePhone:[UIImage imageNamed:@"preview_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = button;
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *outButton =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"发表-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(keyboardDismiss)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"发表-添加菜单键"] landscapeImagePhone:[UIImage imageNamed:@"发表-添加菜单键-press"] style:UIBarButtonItemStyleDone target:self action:@selector(addButton)];
    addButton.width = 485.1111111;
//    self.toolbarItems = @[outButton,addButton];
    [self setToolbarItems:@[outButton,addButton]];
#pragma mark --添加textField
    _field = [[UITextField alloc] initWithFrame:CGRectMake(50, 8, 220, 30)];
    _field.borderStyle = UITextBorderStyleRoundedRect;
    _field.delegate = self;
    _field.clearsOnBeginEditing = YES;
    [self.navigationController.toolbar addSubview:_field];
#pragma mark -- 添加标题
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLable.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLable.text = @"与某某聊天";
    titleLable.textColor = [UIColor blackColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLable;
    [self keyboard];
}

- (void)addButton
{
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.shadowView.backgroundColor = [UIColor grayColor];
    NSArray *arrayButton = @[@"发表-添加菜单-表情@2x",@"发表-添加菜单-图片@2x",@"发表-添加菜单-语音@2x",@"发表-缩略图-删除-press@2x"];
    NSArray *heghlightButton = @[@"发表-添加菜单-表情-press@2x",@"发表-添加菜单-语音-press@2x",@"发表-添加菜单-图片-press@2x",@"发表-缩略图-删除@2x"];
    for (int i = 0; i < arrayButton.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(25 +(i * 80), 0, 30, 30)];
        if (i == 3) {
            [button addTarget:self action:@selector(removeShadowView) forControlEvents:UIControlEventTouchUpInside];
        }else if(i == 2){
            [button addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 1){
            [button addTarget:self action:@selector(Picture) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 0){
            [button addTarget:self action:@selector(Expression) forControlEvents:UIControlEventTouchUpInside];
        }
        UIImageView *inamge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arrayButton[i]] highlightedImage:[UIImage imageNamed:heghlightButton[i]]];
        inamge.frame = CGRectMake(0, 10, 30, 30);
        [button addSubview:inamge];
        [self.shadowView addSubview:button];
        [self.navigationController.toolbar addSubview:self.shadowView];
    }
}
- (void)keyboard
{
#pragma mark -- 键盘触发事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    _messageField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
//    _messageField.leftViewMode = UITextFieldViewModeAlways;
//    _messageField.delegate = self;
    [self chat];
}
#pragma mark -- 键盘监听事件

- (void)keyboardWillChangeFrame:(NSNotification *)tap
{
    self.navigationController.toolbar.frame = self.toolBarFrame;
//设置弹出后的键盘尺寸
    CGRect keyboardFrame = [tap.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
////键盘弹出的耗时事件
//    CGFloat duration = [tap.userInfo[UIKeyboardAnimationCurveUserInfoKey] floatValue];
//键盘变化时view的移位  上下移动
    CGFloat transFormY = kHeight - keyboardFrame.origin.y;
   [UIView animateWithDuration:.01 animations:^{
        self.navigationController.toolbar.frame = CGRectOffset(self.navigationController.toolbar.frame, 0, -transFormY);
   }];
    
}
#pragma mark - 缩回键盘
//- (void)keyBoardWillHide:(NSNotification *)info
//{
//    [UIView animateWithDuration:[info.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] animations:^{
//
//    }];
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
// 1.缩回键盘
    [self.view endEditing:YES];
}
#pragma mark -- 写聊天界面
- (void)chat
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
}
#pragma mark -- 文本代理框方法

#pragma mark -- 未走
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_field isFirstResponder]) {
        [_field resignFirstResponder];
    }
    [self.tableView resignFirstResponder];
}
#pragma mark -- 点击事件
- (void)keyboardDismiss
{
    [self.field resignFirstResponder];
    self.navigationController.toolbar.frame = self.toolBarFrame;
}

#pragma mark - 返回

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 显示图片
- (void)Picture
{
    UIImagePickerController *imagePicker = [[UIImagePickerController  alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark -- 删除
- (void)removeShadowView
{
    [self.shadowView removeFromSuperview];
}
#pragma mark --- 语音Click
- (void)Click
{
    if (_image.hidden == YES) {
        _image.hidden = NO;
    }else{

        _image.hidden = YES;
    }
}
#pragma mark -- 表情
- (void)Expression
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    self.navigationController.toolbarHidden = NO;
        //[bar removeFromSuperview];
//    EmptionPicker *pic = [[EmptionPicker alloc] init];
//    [self.navigationController   pushViewController:pic animated:YES];
}
#pragma mark -- 表情代理
//- (void)sendTextAction:(NSString *)inputText
//{
//    NSLog(@"sendTextAction%@",inputText);
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mutableKmiciFrame.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_typedefIsis == typedefIsYou) {
        FXPersonalTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"FXPersonalTableViewCellMe" forIndexPath:indexPath];
        cell.findYou.text = _mutableKmiciFrame[indexPath.row];
        cell.dataTimeYou.text = _timeArray[indexPath.row];
        cell.iconImageYou.layer.cornerRadius = 40/2;
        cell.iconImageYou.layer.masksToBounds = YES;
        return cell;
    }else{
        FXPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXPersonalTableViewCellYou" forIndexPath:indexPath];
        cell.iconImageMe.layer.cornerRadius = 40/2;
        cell.iconImageMe.layer.masksToBounds = YES;
        cell.findMe.text = _mutableKmiciFrame[indexPath.row];
        cell.dataTimeME = _mutableKmiciFrame[indexPath.row];

        return cell;
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
//    if (_typedefIsis == typedefIsYou) {
//        FXPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXPersonalTableViewCellMe"];
//        return [cell cellHeightWithLabelStr:_field.text];
//    }else{
//        FXPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FXPersonalTableViewCellYou"];
//        return [cell cellHeightWithLabelStr:_field.text];
//    }
    return 100;
}
#pragma mark --- daili   imagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.sendImage.image = image;
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark ---
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
//    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
//        return NO;
//    }
//    return YES;
//}
#pragma mark -- 扫描代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"%@",connection);
    [self performSelectorOnMainThread:@selector(outButton) withObject:nil waitUntilDone:YES];
}
- (void)outButton
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.navigationController.toolbar.frame = _toolBarFrame;
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString *formatterStr = @"HH:mm:ss";
    [dateFormatter setDateFormat:formatterStr];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    [_timeArray addObject:dateStr];
    _field.placeholder = @"请输入......";
    [_mutableKmiciFrame  addObject:textField.text];
    [self.tableView reloadData];
    return YES;
}
#pragma mark -- 录音代理
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [[UIDevice currentDevice]setProximityMonitoringEnabled:NO];
    [_player stop];
    _player=nil;
}
//开始录音
//结束录音

@end
