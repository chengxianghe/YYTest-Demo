//
//  RequestHelper.h
//  YYTest
//
//  Created by chengxianghe on 16/1/19.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JokeRequest.h"

typedef void(^GetDataSuccess)(NSArray *array);

@interface RequestHelper : NSObject

+ (void)getJokesWithCategory:(JokeType)category
                        page:(int)page
               latest_viewed:(long long)latest_viewed
               max_timestamp:(long long)max_timestamp
                     success:(GetDataSuccess)success
                      failur:(BaseRequestFailur)failur;

@end
