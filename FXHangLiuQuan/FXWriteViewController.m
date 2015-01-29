//
//  FXWriteViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/5.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXWriteViewController.h"
#import "Common.h"
#import "FXNetworking.h"
#import <AVFoundation/AVFoundation.h>

@interface FXWriteViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AVAudioRecorderDelegate,UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextV;
@property (nonatomic, strong) UIScrollView *scrollV;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic) CGRect toolbarRect;
@property (nonatomic, strong) UIBarButtonItem *reightItem;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIButton *backI;
@property (nonatomic, strong) UIImageView *backImageV;
@property (nonatomic, strong) NSTimer *recorderTimer;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIView *backViewRecorder;
@end

@implementation FXWriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"编辑帖子";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToobarFrame:) name:UIKeyboardDidShowNotification object:nil];
    UIButton *leftBtn = [self setupBackButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.reightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem = self.reightItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.toolbarRect = CGRectMake(0, 524, 320, 44);
    
}

- (void)changeToobarFrame:(NSNotification *)notification
{
    CGRect rect = self.navigationController.toolbar.frame;
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (!CGRectEqualToRect(self.navigationController.toolbar.frame, CGRectMake(0, 308, 320, 44))) {
        self.navigationController.toolbar.frame = CGRectOffset(rect, 0, -keyboardFrame.size.height);
    }
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self creatScrollViewAndImage];
}
- (void)creatScrollViewAndImage
{
    self.navigationController.toolbarHidden = NO;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(285, 8, 54/2, 54/2)];
    [btn setImage:[UIImage imageNamed:@"发表-添加菜单键"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addPhotoAndRecoder:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = btn;
    [self.navigationController.toolbar addSubview:self.scrollV];
    [self.navigationController.toolbar addSubview:self.addBtn];
    self.backV= [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth - 40, 44)];
    if (!self.scrollV) {
        self.scrollV = [[UIScrollView alloc ] initWithFrame:self.backV.bounds];
    }
    //    scrollV.backgroundColor = [UIColor blackColor];
    _scrollV.delegate = self;
    _scrollV.contentSize = CGSizeMake(400, 40);
    for (int i =0; i<_imageArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i * 38 + 8, 8, 30, 30)];
        imageV.image = _imageArray[i];
        [_scrollV addSubview:imageV];
    }
    [self.navigationController.toolbar addSubview:self.scrollV];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
    [self.addBtn removeFromSuperview];
    [self.scrollV removeFromSuperview];
    [self.backV removeFromSuperview];
}

#pragma mark - property init

- (void)addButtonsToBackV
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    btn1 = [[UIButton alloc] initWithFrame:CGRectMake(81/2, 8, 54/2,54/2 )];
    [btn1 setImage:[UIImage imageNamed:@"发表-添加菜单-表情"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"发表-添加菜单-表情-press"] forState:UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(showExpression) forControlEvents:UIControlEventTouchUpInside];
    btn2 = [[UIButton alloc] initWithFrame:CGRectMake(81/2 + 179/2, 8, 54/2,54/2 )];
    [btn2 setImage:[UIImage imageNamed:@"发表-添加菜单-图片"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"发表-添加菜单-图片-press"] forState:UIControlStateHighlighted];
    [btn2 addTarget:self action:@selector(showImagePicker) forControlEvents:UIControlEventTouchUpInside];
    btn3 = [[UIButton alloc] initWithFrame:CGRectMake(81/2 + 179, 8, 54/2,54/2 )];
    [btn3 setImage:[UIImage imageNamed:@"发表-添加菜单-语音"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"发表-添加菜单-语音-press"] forState:UIControlStateHighlighted];
    [btn3 addTarget:self action:@selector(recorderAudio) forControlEvents:UIControlEventTouchUpInside];
    [self.backV addSubview:btn1];
    [self.backV addSubview:btn2];
    [self.backV addSubview:btn3];
}

- (void)showExpression
{
    
}

- (void)showImagePicker
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
    imagePicker.delegate = self;
}

- (void)recorderAudio
{
    
    [self.titleTextField resignFirstResponder];
    if (![self.titleTextField.text isEqualToString:@""]) {
        [self cancleButton];
    }else{
        [self textFieldAlerdView];
    }
    [self.contentTextV resignFirstResponder];
}

- (void)cancleButton
{
    self.navigationController.toolbarHidden = YES;
    CGRect frame = self.view.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor grayColor];
    self.backViewRecorder = view;
    [self.view addSubview:self.backViewRecorder];
    view.alpha = .6;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 70, 25, 25)];
    btn.backgroundColor = [UIColor redColor];
    [btn setImage:[UIImage imageNamed:@"发表-返回"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *imgView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,234/2, 316/2)];
    imgView.center = self.view.center;
    [imgView setImage:[UIImage imageNamed:@"发表-录音底图"] forState:UIControlStateNormal];
    self.backI = imgView;
    [self.backI addTarget:self action:@selector(startRecorder:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)startRecorder:(UIButton *)btn
{
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
    self.recorderTimer = [NSTimer scheduledTimerWithTimeInterval:.2f target:self selector:@selector(changeBackImageFrame) userInfo:nil repeats:YES];

}

- (void)changeBackImageFrame
{
    [self.recorder updateMeters];
    CGFloat power = [self.recorder averagePowerForChannel:0];
    self.backImageV.transform = CGAffineTransformTranslate(self.backImageV.transform, 0, -power-80);
    if (self.backImageV.frame.origin.y < 0) {
        self.backImageV.transform = CGAffineTransformIdentity;
    }
}

- (void)removeView
{
    [self.recorderTimer invalidate];
    [_recorder stop];
    [self.backViewRecorder removeFromSuperview];
    self.navigationController.toolbarHidden = NO;
}

- (void)addPhotoAndRecoder:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected = NO;
        btn.transform = CGAffineTransformIdentity;
        [btn setImage:[UIImage imageNamed:@"发表-添加菜单键"] forState:UIControlStateNormal];
        [self.backV removeFromSuperview];
        [self.navigationController.toolbar addSubview:self.scrollV];
    }else{
        btn.selected = YES;
        btn.transform = CGAffineTransformMakeRotation(M_PI_2/2);
        [btn setImage:[UIImage imageNamed:@"发表-添加菜单键-press"] forState:UIControlStateNormal];
        [self.scrollV removeFromSuperview];
        [self addButtonsToBackV];
        [self.navigationController.toolbar addSubview:self.backV];
    }
}
#pragma mark - add subviews

- (UIButton *)setupBackButton
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 60, 40)];
    [btn setImage:[UIImage imageNamed:@"发表-返回"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"发表-返回-press"] forState:UIControlStateHighlighted];
//    [btn setTitle:@"发帖" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


#pragma mark - action

- (void)send
{
    NSString *urlStr = [kBaseUrl stringByAppendingString:@"/hlq_api/addthread/"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults stringForKey:kHQL_id];
    NSDictionary *dict = @{@"userid": userId,
                                @"title": self.titleTextField.text,
                                @"content": self.contentTextV.text};
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (_imageArray) {
        NSData *data = UIImageJPEGRepresentation(_imageArray[0], 0.5);
        NSString *imageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [parameter setValue:imageStr forKey:@"image"];
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2215421823139.caf" ofType:nil];
    NSData *soundData = [NSData dataWithContentsOfFile:filePath];
    NSString *soundStr = [soundData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (soundStr) {
        [parameter setValue:soundStr forKey:@"sound"];
    }
    [FXNetworking sendHTTPFormatIsPost:YES andParameters:parameter andUrlString:urlStr request:NO notifationName:@"sendText"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendSuccess:) name:@"sendText" object:nil];
}

- (void)sendSuccess:(NSNotification *)noti
{
    NSDictionary *dict = noti.object;
    if (dict[@"success"]) {
        [self createAlertView:@"提示" andMessage:@"发送成功"];
    }else{
        [self createAlertView:@"提示" andMessage:@"发送失败"];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createAlertView:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
    [alertV show];
}

#pragma mark -
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.backV removeFromSuperview];
    self.navigationController.toolbar.frame = self.toolbarRect;
}

- (void)textFieldAlerdView
{
    if ([self.titleTextField.text isEqualToString:@""]) {
        self.reightItem.enabled = NO;
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请加入标题" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil];
        alertV.tag = 10001;
        [alertV show];
    }else{
        self.reightItem.enabled = YES;
    }
}

#pragma mark - imagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!self.imageArray) {
        self.imageArray = [NSMutableArray array];
    }
    [self.imageArray addObject:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - alertView  delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001 && buttonIndex == 0) {
        return;
    }else{
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.titleTextField resignFirstResponder];
    if (![self.titleTextField.text isEqualToString:@""]) {
        [self cancleButton];
    }else{
        [self textFieldAlerdView];
    }

}
@end
