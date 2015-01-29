//
//  FXContactViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/8.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXContactViewController.h"
#import "LCVoice.h"
#import "LCVoiceHud.h"
#import "Common.h"

@interface FXContactViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *reciverName;
@property (weak, nonatomic) IBOutlet UITextView *emilContent;

@property (nonatomic, strong) UIView *imgShowView;
@property (nonatomic, strong) UIView *audioShadowView;

@property (nonatomic, strong) LCVoice *voice;

@end

@implementation FXContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"发私信";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.emilContent.clearsOnInsertion = YES;
}

#pragma mark - property init

- (LCVoice *)vioce
{
    if (_voice == nil) {
        _voice = [[LCVoice alloc]init];
    }
    return _voice;
}

- (UIView *)imgShowView
{
    CGFloat textHeight = self.emilContent.frame.size.height - 30;
    if (_imgShowView == nil) {
        _imgShowView = [[UIView alloc]initWithFrame:CGRectMake(0, textHeight, self.emilContent.frame.size.width, 30)];
    }
    return _imgShowView;
}

- (UIView *)audioShadowView
{
    if (_audioShadowView == nil) {
        _audioShadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _audioShadowView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_bg_ip5"]];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 100)];
        btn.center = _audioShadowView.center;
        [btn setImage:[UIImage imageNamed:@"发表-录音底图"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(beginRecording) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(endRecording) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(cancelRecording) forControlEvents:UIControlEventTouchUpOutside];
        [self setupLabelAddToView:btn];
        [_audioShadowView addSubview:btn];
    }
    return _audioShadowView;
}

#pragma mark - view delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.emilContent isFirstResponder]) {
        [self.emilContent resignFirstResponder];
    }
}

#pragma mark - custom method

- (void)setupLabelAddToView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
    label.center = view.center;
    label.numberOfLines = 2;
    label.text = @"按住开始录音";
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    NSLog(@"label frame %@",NSStringFromCGRect(label.frame));
}

#pragma mark - action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)expression:(id)sender {
}

- (IBAction)picture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)audio:(UIButton *)sender {
    if ([self.emilContent isFirstResponder]) {
        [self.emilContent resignFirstResponder];
    }
    [self.view addSubview:self.audioShadowView];
}

- (void)beginRecording
{
    [self.voice startRecordWithPath:[NSString stringWithFormat:@"%@/Documents/MySound.audio",NSHomeDirectory()]];
}

- (void)cancelRecording
{
    [self.voice cancelled];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消了" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    [self.audioShadowView removeFromSuperview];
    self.audioShadowView = nil;
}

- (void)endRecording
{
    [self.voice stopRecordWithCompletionBlock:^{
        if (self.voice.recordTime > 0.0f) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"\nrecord finish ! \npath:%@ \nduration:%f",self.voice.recordPath,self.voice.recordTime] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.audioShadowView removeFromSuperview];
        self.audioShadowView = nil;
    }];
}

- (IBAction)sendMesg:(id)sender {
    
    NSString *urlStr = [kBaseUrl stringByAppendingString:@"/baseURL + hlq_api/send_message/"];

}

#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.imgShowView) {
        [self.imgShowView removeFromSuperview];
    }
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.image = image;
    [self.imgShowView addSubview:imageView];
}

@end
