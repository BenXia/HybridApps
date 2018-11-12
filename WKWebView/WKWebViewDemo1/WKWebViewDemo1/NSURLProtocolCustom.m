//
//  NSURLProtocolCustom.m
//  WKWebViewDemo1
//
//  Created by JackLee on 2018/2/27.
//  Copyright © 2018年 JackLee. All rights reserved.
//

#import "NSURLProtocolCustom.h"
#import "NSString+MD5.h"
#import <JKSandBoxManager/JKSandBoxManager.h>
#import <AFNetworking/AFNetworking.h>

@interface NSURLProtocolCustom ()

@property (nonatomic, strong) AFURLSessionManager *manager;

@end

static NSString* const FilteredKey = @"FilteredKey";

@implementation NSURLProtocolCustom
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *extension = request.URL.pathExtension;
    BOOL isSource = [[self resourceTypes] indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [extension compare:obj options:NSCaseInsensitiveSearch] == NSOrderedSame;
    }] != NSNotFound;
    return [NSURLProtocol propertyForKey:FilteredKey inRequest:request] == nil && isSource;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [super.request mutableCopy];
    //标记该请求已经处理
    [NSURLProtocol setProperty:@YES forKey:FilteredKey inRequest:mutableReqeust];
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[super.request.URL.absoluteString MD5Hash],super.request.URL.pathExtension];

    NSString *gameId = [[NSUserDefaults standardUserDefaults] stringForKey:@"GameId"];
    NSString *nameSpace = [NSString stringWithFormat:@"GameId%@",gameId];
    NSString *fileDir =[JKSandBoxManager createCacheFilePathWithFolderName:nameSpace];
    NSString *filePath =[fileDir stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    NSLog(@"targetpath %@",filePath);

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) { //文件不存在，去下载
        [self downloadResourcesWithRequest:[mutableReqeust copy]];
        return;
    }
    //加载本地资源
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    [self sendResponseWithData:data mimeType:[self getMimeTypeWithFilePath:filePath]];
}

- (void)stopLoading
{
    
}

- (void)sendResponseWithData:(NSData *)data mimeType:(nullable NSString *)mimeType
{
    // 这里需要用到MIMEType
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:super.request.URL
                                                        MIMEType:mimeType
                                           expectedContentLength:-1
                                                textEncodingName:nil];

    //硬编码 开始嵌入本地资源到web中
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}

/**
 * manager的懒加载
 */
- (AFURLSessionManager *)manager {
    if (!_manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 1. 创建会话管理者
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _manager;
}

////下载资源文件
- (void)downloadResourcesWithRequest:(NSURLRequest *)request{

    NSString *fileName = [NSString stringWithFormat:@"%@.%@",[super.request.URL.absoluteString MD5Hash],super.request.URL.pathExtension];

    NSString *gameId = [[NSUserDefaults standardUserDefaults] stringForKey:@"GameId"];
    NSString *nameSpace = [NSString stringWithFormat:@"GameId%@",gameId];
    NSString *fileDir =[JKSandBoxManager createCacheFilePathWithFolderName:nameSpace];
    NSString *targetFilePath =[fileDir stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];

    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        // 下载进度

    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
       NSURL *path =  [NSURL fileURLWithPath:JKSandBoxPathTemp];
        return [path URLByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [JKSandBoxManager moveFileFrom:filePath.path to:targetFilePath];
        NSLog(@"targetpath %@",targetFilePath);
        NSData *data = [NSData dataWithContentsOfFile:targetFilePath];
        [self sendResponseWithData:data mimeType:[self getMimeTypeWithFilePath:targetFilePath]];
    }];

    // 4. 开启下载任务
    [downloadTask resume];

}

- (NSString *)getMimeTypeWithFilePath:(NSString *)filePath{
    CFStringRef pathExtension = (__bridge_retained CFStringRef)[filePath pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    CFRelease(pathExtension);
    
    //The UTI can be converted to a mime type:
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    if (type != NULL)
        CFRelease(type);
    
    return mimeType;
}

+ (NSArray *)resourceTypes{
    return @[@"png", @"jpeg", @"gif", @"jpg",@"jpg",@"json", @"js", @"css",@"mp3",@"fnt"];
}


@end
