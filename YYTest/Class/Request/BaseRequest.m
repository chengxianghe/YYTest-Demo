//
//  BaseRequest.m
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest

- (RequestType)requestType {
    return RequestTypeGet;
}

- (NSDictionary *)requestParameters {
    return nil;
}

- (NSString *)requestUrl {
    return nil;
}

- (void)cancelRequest {
    
}

- (void)requestWithSuccess:(BaseRequestSuccess)success failur:(BaseRequestFailur)failur {
    
    if ([self requestType] == RequestTypeGet) {
        [AFNetworkConfig getCacheWithUrl:[self requestUrl] parameters:[self requestParameters] success:success failur:failur];
    } else if ([self requestType] == RequestTypePost) {
        [AFNetworkConfig postWithUrl:[self requestUrl] parameters:[self requestParameters] success:success failur:failur];
    }
}

@end
