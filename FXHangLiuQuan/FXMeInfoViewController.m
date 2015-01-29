//
//  FXMeInfoViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/5.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXMeInfoViewController.h"
#import "FXMeInfoEditViewController.h"
#import "FXFansTableViewController.h"
#import "FXAttentionTableViewController.h"
#import "FXSecretMsegTableViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "FXDatabaseManager.h"
#import "FXLoginUserInfo.h"
#import "FXUserModel.h"
#import "Common.h"

#define kFXmeInfoTableHeader        @"FXMeInfoTableHeader"

typedef enum{
    kSex,
    kBirthday,
    kAddressInfo
}dataType;

@interface FXMeInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *detailArray;
@property (nonatomic, strong) UIButton *cellImgBtn;

@property (weak, nonatomic) IBOutlet UIButton *iconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *backGrdImgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *gener;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *sign;
@property (weak, nonatomic) IBOutlet UILabel *age;

@property (nonatomic, strong) NSString *birthday;

@property (nonatomic, strong) NSDictionary *addressDic;
@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *sexData;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *pickerShadowView;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) dataType dataType;

@property (nonatomic, strong) UILabel *animationLabel;

@end

static NSInteger firstSectionRow = 0;
static NSInteger secondSectionRow = 0;

@implementation FXMeInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"个人信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor  = [UIColor whiteColor];
    UIButton *leftBtn = [self setupButtonWithImgName:@"返回" hightedName:@"返回-press"];
    [leftBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [self setupButtonWithImgName:@"userinfo_me_relationship_indicator_tick" hightedName:@"userinfo_me_relationship_indicator_tick_unfollow"];
    [rightBtn addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.tableView.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:kFXmeInfoTableHeader owner:self options:nil][0];
    if (self.user) {
        [self setUserInfo];
    }
    self.iconImgView.layer.cornerRadius = 54;
    self.iconImgView.layer.masksToBounds = YES;
    
    self.sexData = @[@"男",@"女"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    self.addressDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.provinces = [NSArray arrayWithArray:[self.addressDic allKeys]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeName:) name:@"changeName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSign:) name:@"changeSign" object:nil];
    
}


#pragma mark - user infomation

- (void)setUserInfo
{
    NSString *base64Str = self.user.icon_url;
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:data];
    [self.iconImgView setImage:image forState:UIControlStateNormal];
    self.name.text  = self.user.nickName;
    NSString *generStr = self.user.gender;
    if ([generStr isEqualToString:@"女"]) {
        self.gener.image = [UIImage imageNamed:@"userinfo_gender_female"];
    }else{
        self.gener.image = [UIImage imageNamed:@"userinfo_gender_male"];
    }
    self.address.text = self.user.address;
    self.sign.text = self.user.descriptions;
    self.age.text = self.user.age;
    self.birthday = [[NSUserDefaults standardUserDefaults] stringForKey:kMeBirthday];
}

- (void)saveUserInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger userID = [defaults integerForKey:kHQL_id];
    [defaults setObject:self.birthday forKey:kMeBirthday];
    UIImage *image = [self.iconImgView imageForState:UIControlStateNormal];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn];
    NSString *urlStr = [kBaseUrl stringByAppendingString:@"/hlq_api/profile/"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@(userID) forKey:@"uid"];
    [parameters setObject:self.sexData[1] forKey:@"gener"];
    if (self.name.text) {
        [parameters setObject:self.name.text forKey:@"nickname"];
    }
    if (self.age.text) {
        [parameters setObject:self.age.text forKey:@"age"];
    }
    
    if (self.address.text) {
        [parameters setObject:self.address.text forKey:@"address"];
    }
    if (self.sign.text) {
        [parameters setObject:self.sign.text forKey:@"description"];
    }
    if (imageStr) {
        [parameters setObject:imageStr forKey:@"icon_image"];
    }
    if (self.user.gender) {
        [parameters setObject:self.user.gender forKey:kGender];
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"===response object :%@",responseObject);
        if (responseObject[@"success"]) {
            [FXDatabaseManager saveLoginUserInfoWithDictionary:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response string :%@ ---error :%@",operation.responseString,error);
    }];
}

#pragma mark - property init

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = @[
                       @[@"头像",@"背景图"],
                       @[@"名字",@"性别",@"生日",@"地址",@"个人签名"]
                       ];
    }
    return _dataArray;
}

- (NSMutableArray *)detailArray
{
    if (_detailArray == nil) {
        _detailArray = [NSMutableArray array];
        [_detailArray addObject:self.name.text];
        NSString *sex;
        if (self.gener.image == [UIImage imageNamed:@"userinfo_gender_male"]) {
            sex = @"男";
        }else{
            sex = @"女";
        }
        [_detailArray addObject:sex];
        if (self.birthday == nil) {
            self.birthday = @"xxx";
        }
        [_detailArray addObject:self.birthday];
        [_detailArray addObject:self.address.text];
        [_detailArray addObject:self.sign.text];
    }
    return _detailArray;
}

- (UIView *)pickerShadowView
{
    if (_pickerShadowView == nil) {
        _pickerShadowView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, 340)];
        _pickerShadowView.backgroundColor = [UIColor colorWithRed:212/225.0 green:212/225.0 blue:212/225.0 alpha:1];
        [_pickerShadowView addSubview:self.label];
        [_pickerShadowView addSubview:[self setupButton]];
        [self.view addSubview:_pickerShadowView];
        if (secondSectionRow == 2) {
            [_pickerShadowView addSubview:self.datePicker];
        }else{
            [_pickerShadowView addSubview:self.pickerView];
        }
    }
    return _pickerShadowView;
}

- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kWidth, 40)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, kWidth, 300)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(updateDate:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth - 60, 40)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"";
        _label.font = [UIFont systemFontOfSize:15];
        _label.backgroundColor = [UIColor whiteColor];
        _label.textColor = [UIColor brownColor];
    }
    return _label;
}

- (UIButton *)setupButton
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth - 60, 0, 60, 40)];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(removeShadow) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UILabel *)animationLabel
{
    if (_animationLabel == nil) {
        _animationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        _animationLabel.center = self.view.center;
        _animationLabel.text = @"保存成功";
        _animationLabel.backgroundColor = [UIColor blackColor];
        _animationLabel.alpha = 0.0;
        _animationLabel.textAlignment = NSTextAlignmentCenter;
        _animationLabel.textColor = [UIColor whiteColor];
        _animationLabel.layer.cornerRadius = 5;
        _animationLabel.layer.masksToBounds = YES;
    }
    return _animationLabel;
}

#pragma mark - custom method

- (UIButton *)setUpIconBtnWithWidth:(CGFloat)width
{
    UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth - 20, 2, width, 40)];
    [iconBtn setImage:[UIImage imageNamed:@"114x114"] forState:UIControlStateNormal];
    return iconBtn;
}

- (UIButton *)setupButtonWithImgName:(NSString *)imgName hightedName:(NSString *)hightedName
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightedName] forState:UIControlStateHighlighted];
    return btn;
}

- (void)removeViewClass:(Class)aclass FromParentView:(UIView *)supeview
{
    for (UIView *subview in supeview.subviews) {
        if ([subview isKindOfClass:aclass]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)animationView:(UIView *)view toHeight:(CGFloat)height
{
    [UIView animateWithDuration:1.0 animations:^{
        view.frame = CGRectOffset(view.frame, 0, height);
    }];
}

#pragma mark - action

- (void)changeName:(NSNotification *)notification
{
    self.name.text = notification.object;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = self.name.text;
}

- (void)changeSign:(NSNotification *)notification
{
    self.sign.text = notification.object;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = self.sign.text;
}

- (void)updateDate:(UIDatePicker *)datePicker
{
    NSString *formateStr = @"yyyy-MM-dd";
    NSDateFormatter *dateFormater = [[NSDateFormatter  alloc]init];
    dateFormater.dateFormat = formateStr;
    NSString *dateStr = [dateFormater stringFromDate:datePicker.date];
    self.label.text = [NSString stringWithFormat:@"%@",dateStr];
    self.birthday = self.label.text;
}

- (void)removeShadow
{
    [self animationView:self.pickerShadowView toHeight:340];
    if (self.pickerShadowView) {
        [self.pickerShadowView removeFromSuperview];
        self.pickerShadowView = nil;
        self.datePicker = nil;
        self.pickerView = nil;
    }
    NSIndexPath *indexPath;
    NSInteger index = 0;
    if (self.dataType == kSex) {
        index = 1;
        indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }else if(self.dataType == kBirthday){
        index = 2;
        indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    }else{
        index = 3;
        indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
    }
    [self.detailArray replaceObjectAtIndex:index withObject:self.label.text];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    self.tableView.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:kFXmeInfoTableHeader owner:self options:nil][0];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveInfo:(id)sender {
    [self.view addSubview:self.animationLabel];
    [UIView animateWithDuration:1.5 animations:^{
        self.animationLabel.alpha = 1;
        [self saveUserInfo];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.animationLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.animationLabel removeFromSuperview];
            self.animationLabel = nil;
        }];
    }];
}

- (void)getImage:(id)sender {
    UIImagePickerController *pickercontroler = [[UIImagePickerController alloc]init];
    pickercontroler.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickercontroler.delegate = self;
    [self presentViewController:pickercontroler animated:YES completion:nil];
}

- (IBAction)fans:(id)sender {
    FXFansTableViewController *fansVC = [[FXFansTableViewController alloc]init];
    [self.navigationController pushViewController:fansVC animated:YES];
}

- (IBAction)attention:(id)sender {
    FXAttentionTableViewController *attentionVC = [[FXAttentionTableViewController alloc]init];
    [self.navigationController pushViewController:attentionVC animated:YES];
}

- (IBAction)secretMesg:(id)sender {
    FXSecretMsegTableViewController *secretVC = [[FXSecretMsegTableViewController alloc]init];
    [self.navigationController pushViewController:secretVC animated:YES];
}


#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (firstSectionRow) {
        self.backGrdImgView.image = image;
    }else{
        [self.iconImgView setImage:image forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContainImgCell"];
        if (indexPath.row == 0) {
            [self removeViewClass:[UIImageView class] FromParentView:cell.contentView];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth - 70, 2, 40, 40)];
            imageView.image = [self.iconImgView backgroundImageForState:UIControlStateNormal];
            [cell.contentView addSubview:imageView];
        }else{
            [self removeViewClass:[UIImageView class] FromParentView:cell.contentView];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth - 90, 2, 60, 40)];
            imageView.image = self.backGrdImgView.image;
            [cell.contentView addSubview:imageView];

        }
    }else{
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detailInfoCell"];
        cell.detailTextLabel.text = self.detailArray[indexPath.row];
        
    }
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
        label.text = @"个人信息";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor colorWithRed:212/225.0 green:212/225.0 blue:212/225.0 alpha:1];
        return label;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 44;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self getImage:nil];
        firstSectionRow = indexPath.row;
    }else{
        FXMeInfoEditViewController *editVC = [[FXMeInfoEditViewController alloc]init];
        secondSectionRow = indexPath.row;
        switch (indexPath.row) {
            case 0:
            {
                editVC.editType = kEditName;
                editVC.navigationItem.title = @"修改昵称";
                [self.navigationController pushViewController:editVC animated:YES];
            }
                break;
            case 1:
            {
                [self animationView:self.pickerShadowView toHeight:-340];
                self.dataType = kSex;
            }
                break;
            case 2:
                [self animationView:self.pickerShadowView toHeight:-340];
                self.dataType = kBirthday;
                break;
            case 3:
            {
                [self animationView:self.pickerShadowView toHeight:-340];
                self.dataType = kAddressInfo;
            }
                break;
            case 4:
            {
                editVC.editType = kEditSign;
                editVC.navigationItem.title = @"修改个人签名";
                [self.navigationController pushViewController:editVC animated:YES];
            }
            default:
                break;
        }
    }
    [self.pickerView reloadAllComponents];
}

#pragma mark - picker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.dataType == kSex) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.dataType == kSex) {
        return self.sexData.count;
    }
    if (self.dataType == kAddressInfo && component == 0) {
        return self.provinces.count;
    }else{
        NSInteger selectedComponent = [pickerView selectedRowInComponent:0];
        NSString *key = self.provinces[selectedComponent];
        NSArray *cities = self.addressDic[key];
        return cities.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.dataType == kSex) {
        NSString *text = self.sexData[row];
        self.label.text = text;
        if ([text isEqualToString:@"女"]) {
            self.gener.image = [UIImage imageNamed:@"userinfo_gender_female"];
        }else{
            self.gener.image = [UIImage imageNamed:@"userinfo_gender_male"];
        }
        self.user.gender = text;
        return text;
    }
    NSString *provinceName;
    NSString *cityName;
    if (self.dataType == kAddressInfo && component == 0) {
        provinceName = self.provinces[row];
        cityName = self.addressDic[provinceName];
        self.label.text = [NSString stringWithFormat:@"%@  %@",provinceName,cityName];
        self.address.text = self.label.text;
        return provinceName;
    }else{
        NSInteger firSelectRow = [pickerView selectedRowInComponent:0];
        provinceName = self.provinces[firSelectRow];
        NSString *key = self.provinces[firSelectRow];
        NSArray *cities = self.addressDic[key];
        cityName = cities[row];
        self.label.text = [NSString stringWithFormat:@"%@  %@",provinceName,cityName];
        self.address.text = self.label.text;
        return cityName;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.dataType == kAddressInfo) {
        if (component == 0) {
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
        }
    }
}

@end
