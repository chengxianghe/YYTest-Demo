//
//  AFNetworkConfig.h
//  GMBRequest
//
//  Created by chengxianghe on 15/9/22.
//  Copyright © 2015年 CXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^BaseRequestSuccess)(id responseObject);
typedef void (^BaseRequestFailur)(NSError *error);

@interface AFNetworkConfig : NSObject

/**
 *  带缓存的 get 请求
 */
+(void)getCacheWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(BaseRequestSuccess)success failur:(BaseRequestFailur)failur;


/**
 *  普通的 post 请求
 */
+(void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(BaseRequestSuccess)success failur:(BaseRequestFailur)failur;


/**
 *  单独 上传图片
 *  imageData : 图片数据
 */
+(void)postWithImageData:(NSData *)imageData WithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(BaseRequestSuccess)success failur:(BaseRequestFailur)failur;


@end
