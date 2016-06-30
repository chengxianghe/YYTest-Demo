//
//  JokeCell.h
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTableViewCell.h"
#import "YYText.h"
#import "JokeLayout.h"
#import <YYAnimatedImageView.h>

@class JokeTextCell;

@interface JokeToolbarView : UIView
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UIImageView *favoriteImageView;
@property (nonatomic, strong) UIImageView *shareImageView;
@property (nonatomic, strong) UIImageView *commentImageView;

@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) YYLabel *likeLabel;

@property (nonatomic, weak) JokeTextCell *cell;

- (void)setWithLayout:(JokeTextLayout *)layout;
// set both "liked" and "likeCount"
- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation;
@end

@interface JokeBodyView : UIView
@property (nonatomic, strong) UIView *contentView;              // 容器
@property (nonatomic, strong) YYLabel *timeLabel;               // 时间
@property (nonatomic, strong) YYLabel *textLabel;               // 文本
@property (nonatomic, strong) YYAnimatedImageView *picView;                // 图片 Array<YYControl>
@property (nonatomic, strong) JokeToolbarView *toolbarView;
@property (nonatomic, strong) JokeTextLayout *layout;
@property (nonatomic, weak) JokeTextCell *cell;

@end



@protocol JokeCellDelegate <NSObject>
@optional
- (void)cell:(JokeTextCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
- (void)cell:(JokeTextCell *)cell didClickImageAtIndex:(NSUInteger)index;
- (void)cell:(JokeTextCell *)cell didClickContentWithLongPress:(BOOL)longPress;
- (void)cellDidClickLike:(JokeTextCell *)cell;
- (void)cellDidClickFavorite:(JokeTextCell *)cell;
- (void)cellDidClickShare:(JokeTextCell *)cell;
- (void)cellDidClickComment:(JokeTextCell *)cell;

@end


@interface JokeTextCell : YYTableViewCell
@property (nonatomic, strong) JokeBodyView *statusView;
@property (nonatomic, strong) JokeTextLayout *layout;
@property (nonatomic, weak) id<JokeCellDelegate> delegate;
@end


@class JokeVideoCell;

@interface JokeVideoToolbarView : UIView

@property (nonatomic, strong) UIButton *lookButton;
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) UIImageView *lookImageView;
@property (nonatomic, strong) UIImageView *commentImageView;

@property (nonatomic, strong) YYLabel *timeLabel;               // 时间
@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) YYLabel *lookLabel;

@property (nonatomic, weak) JokeVideoCell *cell;

- (void)setWithLayout:(JokeVideoLayout *)layout;

@end

@interface JokeVideoBodyView : UIView
@property (nonatomic, strong) UIView *contentView;              // 容器
@property (nonatomic, strong) YYAnimatedImageView *picView;     // 图片 Array<YYControl>
@property (nonatomic, strong) YYLabel *textLabel;               // 文本
@property (nonatomic, strong) JokeVideoToolbarView *toolbarView;
@property (nonatomic, strong) JokeVideoLayout *layout;
@property (nonatomic, weak) JokeVideoCell *cell;

@end

@interface JokeVideoCell : YYTableViewCell
@property (nonatomic, strong) JokeVideoLayout *layout;
@property (nonatomic, strong) JokeVideoBodyView *statusView;

@end