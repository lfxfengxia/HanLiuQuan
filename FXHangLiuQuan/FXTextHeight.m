//
//  QYTextHeight.m
//  OwnWeiboDemo
//
//  Created by qingyun on 14-12-12.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "FXTextHeight.h"

static UILabel *label;
@implementation FXTextHeight

+ (void)initialize
{
    if (self == [FXTextHeight class]) {
        NSInteger defaultWidth = [UIScreen mainScreen].bounds.size.width - 16;
        label = [[UILabel alloc] init];
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.numberOfLines = 0;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:defaultWidth];
        [label addConstraint:constraint];
    }
}

+ (CGFloat)textHeightWith:(NSString *)string fontSize:(NSInteger)fontSize withWidth:(CGFloat)width
{
    label.font = [UIFont systemFontOfSize:fontSize];
    NSArray *constraints;
    if (width != 0
        && label.bounds.size.width != width) {
        constraints = label.constraints;
        [label removeConstraints:label.constraints];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
        [label addConstraint:constraint];
    }
    label.text = string;
    CGSize size = [label systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (constraints) {
        [label removeConstraints:label.constraints];
        [label addConstraints:constraints];
    }
    return size.height;
}

//+ (CGSize)textHeightWith:(NSString *)string fontSize:(NSInteger)fontSize withWidth:(CGFloat)width
//{
//    
//}

@end
