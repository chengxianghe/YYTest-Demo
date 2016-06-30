//
//  UIColor+YYAdd.m
//  YYTest
//
//  Created by chengxianghe on 16/1/13.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import "UIColor+YYAdd.h"

@implementation UIColor (YYAdd)

+ (UIColor *)colorWithHexString:(NSString *)hexColor{
    
    if ([hexColor length] == 6) {
    
        unsigned int red, green, blue;
        NSRange range;
        range.length = 2;
        
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
        
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
        
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
        
        return [UIColor colorWithRed:((float)red/255.0f) green:((float)green/255.0f) blue:((float)blue/255.0f) alpha:1.0f];
    }
    return [UIColor clearColor];
}

+ (UIColor *)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha {
    return [UIColor
            colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
            green:((float)((hexValue & 0xFF00) >> 8))/255.0
            blue:((float)(hexValue & 0xFF))/255.0
            alpha:alpha];
}
@end
