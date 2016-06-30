//
//  JokeRequest.m
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import "JokeRequest.h"

@implementation JokeRequest

- (NSDictionary *)requestParameters {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *catagory = nil;
    switch (_category) {
        case JokeTypeJokes: catagory = @"weibo_jokes"; break;
        case JokeTypePics: catagory = @"weibo_pics"; break;
        case JokeTypeVideos: catagory = @"weibo_videos"; break;
        case JokeTypeGirls: catagory = @"weibo_girls"; break;
        default:
            break;
    }
    
    [dict setValue:catagory forKey:@"category"];
    [dict setValue:@(_page) forKey:@"page"];
    [dict setValue:@(_pageSize) forKey:@"pageSize"];
    [dict setValue:@(_latest_viewed_ts) forKey:@"latest_viewed_ts"];
    [dict setValue:@(_max_timestamp) forKey:@"max_timestamp"];
    [dict setValue:@(_apiver) forKey:@"apiver"];

    return dict;
}

- (NSString *)requestUrl {
    return @"http://lunchsoft.com/weibofun/weibo_list.php";
}

@end
