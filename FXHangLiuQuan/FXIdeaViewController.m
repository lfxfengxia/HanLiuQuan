//
//  FXIdeaViewController.m
//  FXHangLiuQuan
//
//  Created by qingyun on 15/1/5.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "FXIdeaViewController.h"

@interface FXIdeaViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emilTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FXIdeaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
}

- (IBAction)send:(id)sender {
}

@end
