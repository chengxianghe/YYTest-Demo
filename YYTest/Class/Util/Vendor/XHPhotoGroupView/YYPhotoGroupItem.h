//
//  YYPhotoGroupItem.h
//  YYKitDemo
//
//  Created by chengxianghe on 15/12/26.
//  Copyright © 2015年 ibireme. All rights reserved.
//

/// Single picture's info.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYPhotoGroupItem : NSObject

@property (nonatomic, strong) UIView *thumbView; ///< thumb image, used for animation position calculation
@property (nonatomic, assign) CGSize largeImageSize;
@property (nonatomic, strong) NSURL *largeImageURL;
@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;
@end
