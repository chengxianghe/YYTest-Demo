//
//  AFNetworkConfig.m
//  GMBRequest
//
//  Created by chengxianghe on 15/9/22.
//  Copyright © 2015年 CXH. All rights reserved.
//

#import "AFNetworkConfig.h"
#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworkReachabilityManager.h>
#import "AFNetworkHelper.h"

@implementation AFNetworkConfig

+ (NSDictionary *)baseDict {
    /*
     http://lunchsoft.com/weibofun/weibo_list.php?apiver=10901&category=weibo_jokes&page=0&page_size=30&max_timestamp=-1&latest_viewed_ts=1453096440
     */
    
    NSDictionary *dict = @{
                           @"sysver" : @"9.2",
                           @"udid" : @"11E2E755-7BB6-4BD7-9501-13BCC880C7E3",
                           @"buildver" : @"1090203",
                           @"appver" : @"1.9.2",
                           @"platform" : @"iphone",
                           };
    
    return dict;
}

+(void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(BaseRequestSuccess)success failur:(BaseRequestFailur)failur
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self baseDict]];
    if (parameters) {
        [dict setValuesForKeysWithDictionary:parameters];
    }
    
    
    // 1.创建POST请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 开启网络指示器
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // 这里要设置格式
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.发送请求
    [mgr POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failur) {
            failur(error);
        }
    }];    
}

+(void)getCacheWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(BaseRequestSuccess)success failur:(BaseRequestFailur)failur
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self baseDict]];
    if (parameters) {
        [dict setValuesForKeysWithDictionary:parameters];
    }
    
    // 1.创建GET请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 开启网络指示器
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [AFHTTPRequestSerializer serializer].timeoutInterval = 30;

    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 判断网络连接
//    int status = [self reachabilityConnectionNetWork];
    
    
    NSString *urlString = [AFNetworkHelper urlStringWithOriginUrlString:url appendParameters:dict];
    NSLog(@"get:%@", urlString);
    
    [mgr GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failur) {
            failur(error);
        }
    }];

}

+(int)reachabilityConnectionNetWork
{
    
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"];
    

    return [mgr networkReachabilityStatus];
}

//1.上传图片：
+(void)postWithImageData:(NSData *)imageData WithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(BaseRequestSuccess)success failur:(BaseRequestFailur)failur{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    
    [mgr POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"imageData" fileName:[self MD5HexDigest:imageData] mimeType:@"image/jpeg"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failur) {
            failur(error);
        }
    }];
    
}

typedef uint32_t CC_LONG;       /* 32 bit unsigned integer */

#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */
extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)
__OSX_AVAILABLE_STARTING(__MAC_10_4, __IPHONE_2_0);

+(NSString *)MD5HexDigest:(NSData *)input
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(input.bytes, (uint32_t)input.length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    return ret;
}


@end
