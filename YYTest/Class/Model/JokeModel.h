//
//  JokeModel.h
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 一个图片的元数据
 */
@interface JokePhotoItem : NSObject

@property (nonatomic, strong) NSURL *smallUrl; ///< Full image url
@property (nonatomic, strong) NSURL *middleUrl; ///< Full image url
@property (nonatomic, strong) NSURL *largeUrl; ///< Full image url
@property (nonatomic, assign) int width; ///< pixel width
@property (nonatomic, assign) int height; ///< pixel height
@property (nonatomic, assign) BOOL isGif; ///< "WEBP" "JPEG" "GIF"
@property (nonatomic, assign) int cutType; ///< Default:1

@end


@interface JokeTextModel : NSObject
/*
 {
 "wid": "59953",
 "update_time": "1453098060",
 "wbody": "妹子失恋了，今天穿了一身黑。出门之后盆友问，为毛穿一身黑？妹子答：心里死了个人，正在给他奔丧。。。",
 "comments": "2",
 "likes": "274.56",
 "w_sensitive": "0"
 }
 */

@property (nonatomic, copy) NSString *wid;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *wbody;
@property (nonatomic, copy) NSString *comments;   
@property (nonatomic, copy) NSString *likes;
@property (nonatomic, copy) NSString *w_sensitive;
@property (nonatomic, assign) BOOL    isLike;
@property (nonatomic, copy) NSString *showTime;

/*
 {
 "wid": "85707",
 "update_time": "1453103100",
 "wbody": "请你吃辣八粥",
 "comments": "3",
 "likes": "149.76",
 "w_sensitive": "0"
 
 "is_gif": "0",
 "wpic_s_width": "57",
 "wpic_s_height": "118",
 "wpic_m_width": "440",
 "wpic_m_height": "913",
 "wpic_small": "http://ww3.sinaimg.cn/thumbnail/e55451afjw1f0337csabkj20c80pdgmb.jpg",
 "wpic_middle": "http://ww3.sinaimg.cn/bmiddle/e55451afjw1f0337csabkj20c80pdgmb.jpg",
 "wpic_large": "http://ww3.sinaimg.cn/large/e55451afjw1f0337csabkj20c80pdgmb.jpg",
 }
 */

@property (nonatomic, strong) JokePhotoItem *photo;

@end


@interface JokeVideoModel : JokeTextModel
/*
 {
 "wid": "26355",
 "update_time": "1453104000",
 "wbody": "结婚不仅要有爱，更要有习惯在里面。",
 "comments": "2",
 "likes": "8.32",
 "w_sensitive": "0"
 
 "vpic_small": "http://ww4.sinaimg.cn/orj480/736f0c7ejw1f02jnumjb6j20no0dcdn5.jpg",
 "vpic_middle": "",
 "vplay_url": "http://us.sinaimg.cn/000KPemYjx06YDOlQ3vF050d0100008B0k01.m3u8?KID=unistore,video&Expires=1453058004&ssig=u2jtVXbpuZ",
 "vsource_url": "http://video.weibo.com/show?fid=1034:ae7a10e9b6ccb88a5ba1d1b583fb762a",
 "fetch_play_url": "0",
 "site_code": "weibo",
 "no_copyright": "0",
 "views": "58",
 }
 */
@property (nonatomic, copy) NSString *site_code; //acfun
@property (nonatomic, copy) NSString *no_copyright; // 0
@property (nonatomic, copy) NSString *views; //播放次数
@property (nonatomic, strong) NSURL *vpic_small;
@property (nonatomic, strong) NSURL *vpic_middle;
@property (nonatomic, strong) NSURL *vplay_url; //播放地址
@property (nonatomic, strong) NSURL *vsource_url; //原网页
@property (nonatomic, assign) BOOL fetch_play_url; // 1

@end