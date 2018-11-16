//
//  NSString+URL.m
//
//  Created by Ben on 18/11/15.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString(URL)

// URL转义
- (NSString *)URLEncodedString
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8));
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
    return result;
}

// 对参数列表生成URL编码后字符串
+ (NSString *)makeQueryStringFromArgs:(NSDictionary *)args
{
    NSMutableString *formatString = nil;
    
    for (NSString *key in args) {
        if (formatString == nil) {
            formatString = [NSMutableString stringWithFormat:@"%@=%@", key, [[args valueForKey:key] URLEncodedString]];
        } else {
            [formatString appendFormat:@"&%@=%@", key, [[args valueForKey:key] URLEncodedString]];
        }
    }
    
    return [NSString stringWithString:formatString];
}

@end


