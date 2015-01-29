//
//  MessageStyleManager.m
//  FXHangLiuQuan
//
//  Created by Yuan on 15-1-12.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "MessageStyleManager.h"
#define APPEND_MESSAGE					@"appendMessage(\"%@\");"
static MessageStyleManager* sharedInstance = nil;

@implementation MessageStyleManager
@synthesize baseHTML,baseURL,emotions;
- (NSDictionary *)emotions
{
    static NSDictionary *dic;
    if (dic) {
        NSString *pinsta = [[NSBundle mainBundle] pathForResource:@"messages" ofType:@"plist"];
        dic = [[NSDictionary alloc] initWithContentsOfFile:pinsta];
    }
    return dic;
}
- (NSMutableArray *)emotionKeysFrom:(NSString *)message
{
    NSMutableArray *array =[NSMutableArray new];
    NSScanner *scanner = [NSScanner scannerWithString:message];
    [scanner scanUpToString:@"你好" intoString:nil];
    while (![scanner isAtEnd]) {
        NSString *stri = nil;
        [scanner scanUpToString:@"你好" intoString:nil];
        if ([scanner scanUpToString:@"你好" intoString:&stri]) {
            [array addObject:stri];
        }
        [scanner scanUpToString:@"你好" intoString:nil];
    }
    return array;
}
- (void)loadTemplate
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *pathTwo = [[NSBundle mainBundle] pathForResource:@"Template" ofType:@"html"];
    NSString *htmYuan = [NSString stringWithContentsOfFile:pathTwo encoding:NSUTF8StringEncoding error:nil];
    baseURL = [NSURL fileURLWithPath:path];
    baseHTML = [NSString stringWithFormat:htmYuan,						//Template
                [[NSBundle mainBundle] bundlePath],					//Base path
                @"@import url( \"Renkoo/Styles/main.css\" );",		//Import main.css for new enough styles
                @"Renkoo/Variants/Green on Red Alternating.css",	//Variant path
                @"",
                (@"")];
    NSString *contentOut = [[NSBundle mainBundle] pathForResource:@"Content" ofType:@"html" inDirectory:@"Renkoo/Outgoing"];
    contentOutHTML =  [NSString stringWithContentsOfFile:contentOut encoding:NSUTF8StringEncoding error:nil];
    NSString * contentInHTMLpath =  [[NSBundle mainBundle] pathForResource:@"Content" ofType:@"html" inDirectory:@"Renkoo/Incoming"];
    contentInHTML =  [NSString stringWithContentsOfFile:contentInHTMLpath encoding:NSUTF8StringEncoding error:nil];
}
- (NSString *)pathForVariant:(NSString *)variant
{
    return [NSString stringWithFormat:@"Renkoo/Variants/%@.css",variant];
    
}
- (NSString *)scriptForChangingVariant:(NSString *)variant
{
	return [NSString stringWithFormat:@"setStylesheet(\"mainStyle\",\"%@\");",[self pathForVariant:variant]];
}
 - (NSArray *)availableVariants
{
    NSMutableArray *availableVariants = [NSMutableArray array];
    for (NSString *pay in [[NSBundle mainBundle] pathsForResourcesOfType:@"css" inDirectory:@"Renkoo/Variants"]) {
        [availableVariants addObject:[[pay lastPathComponent] stringByDeletingPathExtension]];
    }
    return availableVariants;
}
- (NSString *)_escapeStringForPassingToScript:(NSString *)inString
{
	inString =[inString stringByReplacingOccurrencesOfString:@"\\"
                                                  withString:@"\\\\"];
    
	inString= [inString stringByReplacingOccurrencesOfString:@"\""
                                                  withString:@"\\\""
               ];
    
	inString =[inString stringByReplacingOccurrencesOfString:@"\n"
                                                  withString:@""
               ];
    
	inString = [inString stringByReplacingOccurrencesOfString:@"\r"
                                                   withString:@"<br>"
                ];
    
	return inString;
}
//- (NSString *)appendScriptForMessage:(Message *)content
//{
//    NSString *newHTML = nil;
//    if (!content.isOut) {
//        newHTML = [contentInHTML copy];
//        newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%messageClasses%" withString:@"incoming message"];
//        newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%userIconPath%"  withString:@"关注列表-取消关注@2x"];
//    }else{
//        newHTML = [contentOutHTML copy];
//        newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%messageClasses%" withString:@"outgoing message"];
//        newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%userIconPath%" withString:@"私信列表-删除@2x"];
//    }
//    newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%sender%" withString:content.sender];
//    newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%time%" withString:content.timeStamp];
//    for (NSString *emo in [self emotionKeysFrom:content.content]) {
//        if ([self.emotions valueForKey:emo]) {
//            content.content = [content.content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[%@]",emo] withString:[NSString stringWithFormat:@"<img src=\"%@\" , width = 25, height = 25>",[self.emotions valueForKey:emo]]];
//        }
//    }
//    newHTML = [newHTML stringByReplacingOccurrencesOfString:@"%message%" withString:content.content];
//    return [NSString stringWithFormat:@"appendMessage(\"%@\")",[self _escapeStringForPassingToScript:newHTML]];
//}
+ (MessageStyleManager *)sharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[MessageStyleManager alloc] init];
        
    }
    return sharedInstance;
}
@end