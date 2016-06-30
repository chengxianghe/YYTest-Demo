//
//  BaseRequest.h
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkConfig.h"

typedef NS_ENUM(NSUInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
};

@interface BaseRequest : NSObject

- (RequestType)requestType;

- (NSDictionary *)requestParameters;

- (NSString *)requestUrl;

- (void)requestWithSuccess:(BaseRequestSuccess)success failur:(BaseRequestFailur)failur;

- (void)cancelRequest;
@end
