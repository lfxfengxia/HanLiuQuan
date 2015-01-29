//
//  FXSinaLoginViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXSinaLoginViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "FXAppDelegate.h"
#import "FXMainViewController.h"
#import "AFNetworking/AFHTTPRequestOperationManager.h"
#import "FXLoginUserInfo.h"
#import "FXUserModel.h"
#import "FXDatabaseManager.h"
#import "Common.h"

@interface FXSinaLoginViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) NSInteger sina_id;

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation FXSinaLoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"preview_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    //清除cookie
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in storage.cookies) {
        [storage deleteCookie:cookie];
    }
    
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&response_type=code&redirect_uri=%@",kAppKey,kRedirectURI]];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:25/225.0 green:214/225.0 blue:93/225.0 alpha:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"preview_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
}

#pragma mark - webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *requestStr = request.URL.absoluteString;
    if ([requestStr hasPrefix:kRedirectURI]) {
        NSRange range = [requestStr rangeOfString:@"code="];
        NSString *code = [requestStr substringFromIndex:range.location + range.length];
        NSString *requestUrlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        NSDictionary *paramters = @{
                                    @"client_id":kAppKey,
                                    @"client_secret":kAppSecret,
                                    @"grant_type":@"authorization_code",
                                    @"redirect_uri":kRedirectURI,
                                    @"code":code
                                    };
        [manager POST:requestUrlStr parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response object======= : %@",responseObject);
            self.sina_id = [responseObject[@"uid"] integerValue];
            [self.defaults setInteger:self.sina_id forKey:kSina_id];
            [self.defaults setBool:YES forKey:kIsLogining];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self getUerInfo];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error : %@",error);
            [self cancel];
        }];
        //不显示回调页面
        return NO;
    }
    return YES;
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//}

#pragma mark - getUserInfo

- (void)getUerInfo
{
    NSString *urlStr = [kBaseUrl stringByAppendingString:@"/hlq_api/weibo_login/"];
    NSDictionary *parameters = @{
                                @"sina_id":@(self.sina_id)
                                 };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response object : %@",responseObject);
        [FXDatabaseManager saveLoginUserInfoWithDictionary:responseObject[@"data"]];
        FXUserModel *user = [[FXUserModel alloc]initWithDictionary:responseObject[@"data"]];
        [[FXLoginUserInfo shareLoginUserInfo] saveLoginUserInfoWithUser:user];
        [self.defaults setInteger:user.user_id forKey:kHQL_id];
        [self gotoPersonalPage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"responseString :%@",operation.responseString);
    }];
}

#pragma mark - action

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoPersonalPage
{
    FXAppDelegate *appDelegate = (FXAppDelegate *)[[UIApplication sharedApplication] delegate];
    FXMainViewController *mainVC = (FXMainViewController *)appDelegate.window.rootViewController;
    [mainVC dismissViewControllerAnimated:YES completion:nil];
    mainVC.selectedIndex = 2;
}

@end
