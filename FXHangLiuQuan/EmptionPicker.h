//
//  EmptionPicker.h
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EmotionPickerDelegate

-(void)emotionPicker:(id)controller didSelectedEmotion:(NSString *)emtion;
-(void)emotionPickerCancelled;

@end
@interface EmptionPicker : UITableViewController

{
    UITableView *tableView;
    NSArray *dataSource;
    __weak id<EmotionPickerDelegate>delegate;
}
@property (weak, nonatomic) id<EmotionPickerDelegate>delegate;


@end
