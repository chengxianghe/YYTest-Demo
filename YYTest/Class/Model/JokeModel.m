//
//  JokeModel.m
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import "JokeModel.h"
#import "YYModel.h"
#import "NSDictionary+YYAdd.h"
#import "NSDate+Utilities.h"

@implementation JokePhotoItem

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"isGif"       : @"is_gif",
             @"width"       : @"wpic_m_width",
             @"height"      : @"wpic_m_height",
             @"smallUrl"    : @"wpic_small",
             @"middleUrl"   : @"wpic_middle",
             @"largeUrl"    : @"wpic_large",
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    _isGif = [dic boolValueForKey:@"is_gif" default:NO];
    
    return YES;
}

@end

@implementation JokeTextModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    if (dic[@"update_time"]) {
        _showTime = [[NSDate dateFromStringOrNumber:dic[@"update_time"]] customTimeDescription];
    }
    
    if (dic[@"wpic_s_width"]) {
        _photo = [JokePhotoItem yy_modelWithDictionary:dic]; 
    }
    
    return YES;
}
@end


@implementation JokeVideoModel

@end