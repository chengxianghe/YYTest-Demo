//
//  RequestHelper.m
//  YYTest
//
//  Created by chengxianghe on 16/1/19.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import "RequestHelper.h"
#import "JokeModel.h"
#import <YYModel/YYModel.h>

@implementation RequestHelper

+ (void)getJokesWithCategory:(JokeType)category page:(int)page latest_viewed:(long long)latest_viewed max_timestamp:(long long)max_timestamp success:(GetDataSuccess)success failur:(BaseRequestFailur)failur {
    __block JokeRequest *jokeRequest = [[JokeRequest alloc] init];
    jokeRequest.page = page;
    jokeRequest.pageSize = 30;
    jokeRequest.category = category;
    jokeRequest.latest_viewed_ts = latest_viewed;
    jokeRequest.apiver = 10901;
    jokeRequest.max_timestamp = max_timestamp;
    [jokeRequest requestWithSuccess:^(id responseObject) {
                                Class Model = [NSObject class];
                                switch (category) {
                                    case JokeTypeJokes: Model = [JokeTextModel class]; break;
                                    case JokeTypePics: Model = [JokeTextModel class]; break;
                                    case JokeTypeVideos: Model = [JokeVideoModel class]; break;
                                    case JokeTypeGirls: Model = [JokeTextModel class]; break;
                                    default:
                                        break;
                                }
                                
                                NSArray *arr = [NSArray yy_modelArrayWithClass:Model json:responseObject[@"items"]];
                                if (success) {
                                    success(arr);
                                }
                                jokeRequest = nil;
                            } failur:^(NSError *error) {
                                if (failur) {
                                    failur(error);
                                }
                                jokeRequest = nil;
                            }];
}

@end
