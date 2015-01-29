//
//  MessageStyleManager.h
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface MessageStyleManager : NSObject


{
    NSURL		*baseURL;
	NSString	*headerHTML;
	NSString	*footerHTML;
	NSString	*baseHTML;
	NSString	*contentHTML;
	NSString	*contentInHTML;
	NSString	*nextContentInHTML;
	NSString	*contextInHTML;
	NSString	*nextContextInHTML;
	NSString	*contentOutHTML;
	NSString	*nextContentOutHTML;
	NSString	*contextOutHTML;
	NSString	*nextContextOutHTML;
	NSString	*statusHTML;
	NSString	*fileTransferHTML;
	NSString	*topicHTML;
    NSDictionary *emotions;
    
}
@property(nonatomic,strong)NSDictionary *emotions;
@property(nonatomic,strong)NSURL *baseURL;
@property(nonatomic,strong)NSString	*baseHTML;
+ (MessageStyleManager*)sharedInstance;
- (void)loadTemplate;
//- (NSString *)appendScriptForMessage:(Message *)content;
- (NSString *)scriptForChangingVariant:(NSString *)variant;
- (NSArray *)availableVariants;


@end
