//
//  JokeRequest.h
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

typedef NS_ENUM(NSUInteger, JokeType) {
    JokeTypeJokes,  // weibo_jokes
    JokeTypePics,   // weibo_pics
    JokeTypeVideos, // weibo_videos
    JokeTypeGirls   // weibo_girls
};

@interface JokeRequest : BaseRequest

@property (nonatomic, assign) int page; // 0
@property (nonatomic, assign) int pageSize; // 30
@property (nonatomic, assign) long long latest_viewed_ts; //1453096440
@property (nonatomic, assign) long long max_timestamp; // -1
@property (nonatomic, assign) int apiver;// 10901
@property (nonatomic, assign) JokeType category; // weibo_jokes
/*
 http://lunchsoft.com/weibofun/weibo_list.php?
 */

@end
