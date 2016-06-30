//
//  NSDate+Current.h
//  DateTest
//
//  Created by chengxianghe on 15/11/4.
//  Copyright © 2015年 CXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Category)

+ (NSDateFormatter *)dateFormatter;
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)dateFormat;

+ (NSDateFormatter *)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

@end
