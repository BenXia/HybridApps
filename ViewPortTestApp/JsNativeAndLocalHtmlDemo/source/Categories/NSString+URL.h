//
//  NSString+URL.h
//
//  Created by Ben on 18/11/15.
//  Copyright © 2016年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(URL)

// URL转义
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

// 对参数列表生成URL编码后字符串
+ (NSString *)makeQueryStringFromArgs:(NSDictionary *)args;

@end


