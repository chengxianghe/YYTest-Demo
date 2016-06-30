//
//  JokeHelper.h
//  YYTest
//
//  Created by chengxianghe on 16/1/21.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YYMemoryCache.h"
#import "YYWebImageManager.h"

@interface JokeHelper : NSObject

+ (NSString *)jokeDateFromString:(NSString *)time;

/// Joke图片 cache
+ (YYMemoryCache *)imageCache;

/// 从Joke bundle 里获取图片 (有缓存)
+ (UIImage *)imageNamed:(NSString *)name;
//
/// 从path创建图片 (有缓存)
+ (UIImage *)imageWithPath:(NSString *)path;

+ (NSString *)shortedNumberDesc:(NSUInteger)number;

/// At正则 例如 @王思聪
+ (NSRegularExpression *)regexAt;

/// 话题正则 例如 #暖暖环游世界#
+ (NSRegularExpression *)regexTopic;

/// 表情正则 例如 [偷笑]
+ (NSRegularExpression *)regexEmoticon;

/// 表情字典 key:[偷笑] value:ImagePath
+ (NSDictionary *)emoticonDic;
@end

@class WBEmoticonGroup;

typedef NS_ENUM(NSUInteger, WBEmoticonType) {
    WBEmoticonTypeImage = 0, ///< 图片表情
    WBEmoticonTypeEmoji = 1, ///< Emoji表情
};

@interface WBEmoticon : NSObject
@property (nonatomic, strong) NSString *chs;  ///< 例如 [吃惊]
@property (nonatomic, strong) NSString *cht;  ///< 例如 [吃驚]
@property (nonatomic, strong) NSString *gif;  ///< 例如 d_chijing.gif
@property (nonatomic, strong) NSString *png;  ///< 例如 d_chijing.png
@property (nonatomic, strong) NSString *code; ///< 例如 0x1f60d
@property (nonatomic, assign) WBEmoticonType type;
@property (nonatomic, weak) WBEmoticonGroup *group;
@end

@interface WBEmoticonGroup : NSObject
@property (nonatomic, strong) NSString *groupID; ///< 例如 com.sina.default
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSString *nameCN; ///< 例如 浪小花
@property (nonatomic, strong) NSString *nameEN;
@property (nonatomic, strong) NSString *nameTW;
@property (nonatomic, assign) NSInteger displayOnly;
@property (nonatomic, assign) NSInteger groupType;
@property (nonatomic, strong) NSArray *emoticons; ///< Array<WBEmoticon>
@end
