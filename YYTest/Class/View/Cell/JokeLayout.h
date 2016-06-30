//
//  JokeLayout.h
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <YYText.h>
#import "JokeModel.h"


// 宽高
#define kJokeCellTopMargin 8      // cell 顶部灰色留白
#define kJokeCellTitleHeight 25   // cell 标题高度 (例如"仅自己可见")
#define kJokeCellPadding kJokeCellTopMargin       // cell 内边距
#define kJokeCellPaddingPic 4     // cell 多张图片中间留白
#define kJokeCellNamePaddingLeft 14 // cell 名字和 avatar 之间留白
#define kJokeCellWidth (kScreenWidth - 2 * kJokeCellTopMargin) // cell背景宽度
#define kJokeCellContentWidth (kScreenWidth - 4 * kJokeCellTopMargin) // cell 内容宽度
#define kJokeCellToolbarHeight 35     // cell 下方工具栏高度
#define kJokeCellToolbarBottomMargin 2 // cell 下方灰色留白

// VideoCell
#define kJokeVideoCellHeight 100     // videoCell height
#define kJokeVideoCellContentHeight (kJokeVideoCellHeight - kJokeCellTopMargin - kJokeCellToolbarBottomMargin)     // videoCell height

#define kJokeVideoCellTopBottomMargin 6     // videoCell height
#define kJokeVideoCellLeftRightMargin 8     // videoCell height
#define kJokeVideoCellPicBoaderWidth 3     // videoCell height

#define kJokeVideoCellPicLeft kJokeVideoCellLeftRightMargin
#define kJokeVideoCellPicTop kJokeVideoCellTopBottomMargin

#define kJokeVideoCellPicHeight (kJokeVideoCellContentHeight - 2 * kJokeVideoCellPicTop) // videoCell 图片高度

//video_holder 111 * 78
#define kJokeVideoCellPicWidth 111 // videoCell 图片宽度
#define kJokeVideoCellTextWidth (kJokeCellWidth - 2 * kJokeVideoCellLeftRightMargin - kJokeVideoCellPicWidth) // videoCell 文本宽度
#define kJokeVideoCellTextLeft (2 * kJokeVideoCellLeftRightMargin + kJokeVideoCellPicWidth) // videoCell 文本左边

#define kJokeVideoCellToolBarHeight 20 // videoCell toolBar height
#define kJokeVideoCellToolBarTop (kJokeVideoCellContentHeight - kJokeVideoCellPicTop - kJokeVideoCellToolBarHeight) // videoCell toolBar height


#define kJokeCellLikeWidth 60           // 喜欢按钮 宽度
#define kJokeCellFavoriteWidth 30       // 收藏按钮 宽度
#define kJokeCellCommentWidth 40        // 评论按钮 宽度
#define kJokeCellShareWidth 30          // 分享按钮 宽度




#define kJokeCellTimeFontSize 12      // 名字字体大小
#define kJokeCellLikeFontSize 12      // 喜欢数字体大小
#define kJokeCellCommentFontSize 12    // 评论数字体大小
#define kJokeCellTextFontSize 17      // 文本字体大小

#define kJokeCellTimeColor UIColorHex(333333) // 名字颜色
#define kJokeCellTextNormalColor UIColorHex(333333) // 一般文本色
#define kJokeCellTextHighlightColor UIColorHex(527ead) // Link 文本色
#define kJokeCellTextHighlightBackgroundColor UIColorHex(bfdffe) // Link 点击背景色
#define kJokeCellToolbarTitleColor UIColorHex(929292) // 工具栏文本色
#define kJokeCellToolbarTitleHighlightColor UIColorHex(df422d) // 工具栏文本高亮色
#define kJokeCellBackgroundColor UIColorHex(f2f2f2)    // Cell背景灰色
#define kJokeCellHighlightColor UIColorHex(f0f0f0)     // Cell高亮时灰色
#define kJokeCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09] //线条颜色

#define kJokeLinkAtName @"at" //NSString


@interface JokeTextLayout : NSObject

- (instancetype)initWithTextJoke:(JokeTextModel *)joke;
- (void)layout; ///< 计算布局

// 以下是数据
@property (nonatomic, strong) JokeTextModel *joke;

//以下是布局结果

// 顶部留白
@property (nonatomic, assign) CGFloat marginTop; //顶部灰色留白

// 标题栏
@property (nonatomic, assign) CGFloat timeHeight; //标题栏高度，0为没标题栏
@property (nonatomic, strong) YYTextLayout *timeTextLayout; // 标题栏

// 图片
@property (nonatomic, assign) CGFloat picHeight; //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;

// 文本
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout; //文本

// 工具栏
@property (nonatomic, assign) CGFloat toolbarHeight; // 工具栏
@property (nonatomic, strong) YYTextLayout *toolbarCommentTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarLikeTextLayout;
@property (nonatomic, assign) CGFloat toolbarCommentTextWidth;
@property (nonatomic, assign) CGFloat toolbarLikeTextWidth;

// 下边留白
@property (nonatomic, assign) CGFloat marginBottom; //下边留白

// 总高度
@property (nonatomic, assign) CGFloat height;

@end

@interface JokeVideoLayout : NSObject

- (instancetype)initWithVideoJoke:(JokeVideoModel *)joke;
- (void)layout; ///< 计算布局

// 以下是数据
@property (nonatomic, strong) JokeVideoModel *joke;

//以下是布局结果

// 顶部留白
@property (nonatomic, assign) CGFloat marginTop; //顶部灰色留白

// 文本
@property (nonatomic, assign) CGFloat textHeight; //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout; //文本

@property (nonatomic, assign) CGFloat picWidth;
@property (nonatomic, assign) CGFloat picHeight;


// 工具栏
@property (nonatomic, assign) CGFloat toolbarHeight; // 工具栏
@property (nonatomic, strong) YYTextLayout *toolbarLookTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarCommentTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarTimeTextLayout;
@property (nonatomic, assign) CGFloat toolbarLookTextWidth;
@property (nonatomic, assign) CGFloat toolbarCommentTextWidth;
@property (nonatomic, assign) CGFloat toolbarTimeTextWidth;

// 下边留白
@property (nonatomic, assign) CGFloat marginBottom; //下边留白

// 总高度
@property (nonatomic, assign) CGFloat height;

@end
