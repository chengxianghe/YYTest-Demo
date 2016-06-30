//
//  JokeCell.m
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import "JokeCell.h"
#import "UIView+YYAdd.h"
#import "UIImage+YYWebImage.h"
#import "UIGestureRecognizer+YYAdd.h"
#import "UIColor+YYAdd.h"
#import "ScreenHelper.h"
#import "UIControl+YYAdd.h"
#import <YYWebImage.h>
#import "JokeHelper.h"

@implementation JokeToolbarView
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kJokeCellContentWidth;
        frame.size.height = kJokeCellToolbarHeight;
        frame.origin.x = kJokeCellTopMargin;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    CGFloat selfH = CGFloatPixelRound(self.height - 12);
    CGFloat selfTop = CGFloatPixelRound(6);
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.exclusiveTouch = YES;
    _likeButton.top = selfTop;
    _likeButton.size = CGSizeMake(CGFloatPixelRound(kJokeCellLikeWidth), selfH);
    [_likeButton setBackgroundImage:[JokeHelper imageNamed:@"digbtn_listpage_press"] forState:UIControlStateHighlighted];
    [_likeButton setBackgroundImage:[JokeHelper imageNamed:@"digbtn_listpage"] forState:UIControlStateNormal];

    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.exclusiveTouch = YES;
    _commentButton.top = selfTop;
    _commentButton.size = CGSizeMake(CGFloatPixelRound(kJokeCellCommentWidth), selfH + 5);
    _commentButton.right = CGFloatPixelRound(kJokeCellContentWidth);
    [_commentButton setBackgroundImage:[JokeHelper imageNamed:@"commentbtn_listpage_press"] forState:UIControlStateHighlighted];
    [_commentButton setBackgroundImage:[JokeHelper imageNamed:@"commentbtn_listpage"] forState:UIControlStateNormal];

    
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.exclusiveTouch = YES;
    _shareButton.top = selfTop;
    _shareButton.size = CGSizeMake(CGFloatPixelRound(kJokeCellShareWidth), selfH);
    _shareButton.right = CGFloatPixelRound(_commentButton.left - kJokeCellPadding);
    [_shareButton setBackgroundImage:[JokeHelper imageNamed:@"digbtn_listpage_press"] forState:UIControlStateHighlighted];
    [_shareButton setBackgroundImage:[JokeHelper imageNamed:@"digbtn_listpage"] forState:UIControlStateNormal];
    
    _favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _favoriteButton.exclusiveTouch = YES;
    _favoriteButton.top = selfTop;
    _favoriteButton.size = CGSizeMake(CGFloatPixelRound(kJokeCellFavoriteWidth), selfH);
    _favoriteButton.right = CGFloatPixelRound(_shareButton.left - kJokeCellPadding);
    [_favoriteButton setBackgroundImage:[JokeHelper imageNamed:@"digbtn_listpage_press"] forState:UIControlStateHighlighted];
    [_favoriteButton setBackgroundImage:[JokeHelper imageNamed:@"digbtn_listpage"] forState:UIControlStateNormal];
    
    
    _shareImageView = [[UIImageView alloc] initWithImage:[JokeHelper imageNamed:@"reposticon_btn_listpage"]];
    _shareImageView.centerY = _shareButton.height / 2;
    _shareImageView.centerX = _shareButton.width / 2;
    [_shareButton addSubview:_shareImageView];
    
    
    _favoriteImageView = [[UIImageView alloc] initWithImage:[JokeHelper imageNamed:@"favicon_btn_listpage"]];
    _favoriteImageView.centerY = _favoriteButton.height / 2;
    _favoriteImageView.centerX = _favoriteButton.width / 2;
    [_favoriteButton addSubview:_favoriteImageView];
    
    _likeImageView = [[UIImageView alloc] initWithImage:[JokeHelper imageNamed:@"digupicon_btn_listpage"]];
    _likeImageView.centerY = _likeButton.height / 2;
    [_likeButton addSubview:_likeImageView];
    
    _commentLabel = [YYLabel new];
    _commentLabel.userInteractionEnabled = NO;
    _commentLabel.height = selfH;
    _commentLabel.width = _commentButton.width;
    _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _commentLabel.displaysAsynchronously = YES;
    _commentLabel.ignoreCommonProperties = YES;
    _commentLabel.fadeOnHighlight = NO;
    _commentLabel.fadeOnAsynchronouslyDisplay = NO;
    [_commentButton addSubview:_commentLabel];
    
    _likeLabel = [YYLabel new];
    _likeLabel.userInteractionEnabled = NO;
    _likeLabel.height = selfH;
    _likeLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _likeLabel.displaysAsynchronously = YES;
    _likeLabel.ignoreCommonProperties = YES;
    _likeLabel.fadeOnHighlight = NO;
    _likeLabel.fadeOnAsynchronouslyDisplay = NO;
    [_likeButton addSubview:_likeLabel];
    
    
    [self addSubview:_commentButton];
    [self addSubview:_likeButton];
    [self addSubview:_favoriteButton];
    [self addSubview:_shareButton];
    
    @weakify(self);
    [_likeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        JokeTextCell *cell = weak_self.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickLike:)]) {
            [cell.delegate cellDidClickLike:cell];
        }
    }];
    
    [_favoriteButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        JokeTextCell *cell = weak_self.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickFavorite:)]) {
            [cell.delegate cellDidClickFavorite:cell];
        }
    }];
    
    [_shareButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        JokeTextCell *cell = weak_self.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickShare:)]) {
            [cell.delegate cellDidClickShare:cell];
        }
    }];
    
    [_commentButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        JokeTextCell *cell = weak_self.cell;
        if ([cell.delegate respondsToSelector:@selector(cellDidClickComment:)]) {
            [cell.delegate cellDidClickComment:cell];
        }
    }];
    
    return self;
}

- (void)setWithLayout:(JokeTextLayout *)layout {
    
    _commentLabel.width = layout.toolbarCommentTextWidth;
    _commentLabel.textAlignment = NSTextAlignmentCenter;
    _likeLabel.width = layout.toolbarLikeTextWidth;
    
    _commentLabel.textLayout = layout.toolbarCommentTextLayout;
    _likeLabel.textLayout = layout.toolbarLikeTextLayout;
    
    _commentLabel.centerX = CGFloatPixelRound((_commentButton.width)/2);

    [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
    
    _likeImageView.image = layout.joke.isLike ? [self likeImage] : [self unlikeImage];
}

- (UIImage *)likeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [JokeHelper imageNamed:@"digupicon_btn_listpage_select"];
    });
    return img;
}

- (UIImage *)unlikeImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [JokeHelper imageNamed:@"digupicon_btn_listpage"];
    });
    return img;
}

- (void)adjustImage:(UIImageView *)image label:(YYLabel *)label inButton:(UIButton *)button {
    CGFloat imageWidth = image.bounds.size.width;
    CGFloat labelWidth = label.width;
    CGFloat paddingMid = 5;
    CGFloat paddingSide = (button.width - imageWidth - labelWidth - paddingMid) / 2.0;
    image.centerX = CGFloatPixelRound((paddingSide + imageWidth / 2));
    label.right = CGFloatPixelRound((button.width - paddingSide));
}

- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation {
    JokeTextLayout *layout = _cell.statusView.layout;
    if (layout.joke.isLike == liked) return;
    
    UIImage *image = liked ? [self likeImage] : [self unlikeImage];
    int newCount = layout.joke.likes.intValue;
    newCount = liked ? newCount + 1 : newCount - 1;
    if (newCount < 0) newCount = 0;
    if (liked && newCount < 1) newCount = 1;
    NSString *newCountDesc = newCount > 0 ? [JokeHelper shortedNumberDesc:newCount] : @"赞";
    
    UIFont *font = [UIFont systemFontOfSize:kJokeCellCommentFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kJokeCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:newCountDesc];
    likeText.yy_font = font;
    likeText.yy_color = liked ? kJokeCellToolbarTitleHighlightColor : kJokeCellToolbarTitleColor;
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:likeText];
    
    layout.joke.isLike = liked;
    layout.joke.likes = @(newCount).stringValue;
    layout.toolbarLikeTextLayout = textLayout;
    
    if (!animation) {
        _likeImageView.image = image;
        _likeLabel.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width);
        _likeLabel.textLayout = layout.toolbarLikeTextLayout;
        [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
        return;
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [_likeImageView.layer setValue:@(1.7) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        
        _likeImageView.image = image;
        _likeLabel.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width);
        _likeLabel.textLayout = layout.toolbarLikeTextLayout;
        [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [_likeImageView.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [_likeImageView.layer setValue:@(1) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}
@end



@implementation JokeBodyView
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kJokeCellWidth;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    @weakify(self);
    
    _contentView = [UIView new];
    _contentView.width = kJokeCellWidth;
    _contentView.height = 1;
    _contentView.left = kJokeCellTopMargin;

    _contentView.backgroundColor = [UIColor whiteColor];
    static UIImage *topLineBG, *leftLineBG, *bottomLineBG, *rightLineBG;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        topLineBG = [UIImage yy_imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, 3, 4, 4));
            CGContextFillPath(context);
        }];
        
        leftLineBG = [UIImage yy_imageWithSize:CGSizeMake(3, 1) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, 3, 4, 4));
            CGContextFillPath(context);
        }];
        

        bottomLineBG = [UIImage yy_imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0.4), 2, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, -2, 4, 2));
            CGContextFillPath(context);
        }];
        
        rightLineBG = [UIImage yy_imageWithSize:CGSizeMake(3, 1) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0.4), 2, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, -2, 4, 2));
            CGContextFillPath(context);
        }];
    });
    UIImageView *topLine = [[UIImageView alloc] initWithImage:topLineBG];
    topLine.width = _contentView.width;
    topLine.bottom = 0;
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [_contentView addSubview:topLine];
    
    UIImageView *leftLine = [[UIImageView alloc] initWithImage:leftLineBG];
    leftLine.width = kJokeCellPaddingPic;
    leftLine.right = 0;
    leftLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_contentView addSubview:leftLine];
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:bottomLineBG];
    bottomLine.width = _contentView.width;
    bottomLine.top = _contentView.height;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_contentView addSubview:bottomLine];
    [self addSubview:_contentView];
    
    UIImageView *rightLine = [[UIImageView alloc] initWithImage:rightLineBG];
    rightLine.width = kJokeCellPaddingPic;
    rightLine.left = 0;
    rightLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_contentView addSubview:rightLine];
    
    _timeLabel = [YYLabel new];
    _timeLabel.left = kJokeCellPadding;
    _timeLabel.width = kJokeCellContentWidth;
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.displaysAsynchronously = YES;
    _timeLabel.ignoreCommonProperties = YES;
    _timeLabel.fadeOnAsynchronouslyDisplay = NO;
    _timeLabel.fadeOnHighlight = NO;
    [_contentView addSubview:_timeLabel];

    
    _textLabel = [YYLabel new];
    _textLabel.top = CGRectGetMaxY(_timeLabel.frame);
    _textLabel.left = kJokeCellPadding;
    _textLabel.width = kJokeCellContentWidth;
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.fadeOnHighlight = NO;
    _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_textLabel];
    
    
    
    
    YYAnimatedImageView *imageView = [YYAnimatedImageView new];
    imageView.size = CGSizeMake(100, 100);
    imageView.hidden = YES;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = kJokeCellHighlightColor;
    imageView.exclusiveTouch = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer *sender) {
        if (![weak_self.cell.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:)]) return;
        
        if (sender.state == UIGestureRecognizerStateEnded) {
            CGPoint p = [sender locationInView:imageView];
            if (CGRectContainsPoint(imageView.bounds, p)) {
                [weak_self.cell.delegate cell:weak_self.cell didClickImageAtIndex:0];
            }
        }
    }];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
    
    
    UIView *badge = [UIImageView new];
    badge.userInteractionEnabled = NO;
    badge.contentMode = UIViewContentModeScaleAspectFit;
    badge.size = CGSizeMake(76, 76);
    badge.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    badge.origin = CGPointZero;
    badge.hidden = YES;
    [imageView addSubview:badge];
    
    [_contentView addSubview:imageView];
    _picView = imageView;
    
    
    _toolbarView = [JokeToolbarView new];
    [_contentView addSubview:_toolbarView];
    
    return self;
}


- (void)setLayout:(JokeTextLayout *)layout {
    _layout = layout;
    
    self.height = layout.height;
    _contentView.top = layout.marginTop;
    _contentView.height = layout.height - layout.marginTop - layout.marginBottom;
    
    CGFloat top = 0;
    
    _timeLabel.top = top;
    _timeLabel.height = layout.timeHeight;
    _timeLabel.textLayout = layout.timeTextLayout;
    top += layout.timeHeight;

    
    _textLabel.top = top;
    _textLabel.height = layout.textHeight;
    _textLabel.textLayout = layout.textLayout;
    top += layout.textHeight;
    
    if (layout.picHeight == 0) {
        [self _hideImageViews];
    }
    
    
    //优先级是 转发->图片->卡片
    if (layout.picHeight > 0) {
        top += kJokeCellPaddingPic;
        [self _setImageViewWithTop:top];
    }
    
    _toolbarView.bottom = _contentView.height;
    [_toolbarView setWithLayout:layout];
}

- (void)_hideImageViews {
    _picView.hidden = YES;
}

- (void)_setImageViewWithTop:(CGFloat)imageTop {
    CGSize picSize = _layout.picSize;
    JokePhotoItem *pic = _layout.joke.photo;
    
    YYAnimatedImageView *imageView = _picView;
    
    
    CGPoint origin = CGPointMake(kJokeCellPadding, imageTop);
    
    imageView.frame = (CGRect){.origin = origin, .size = picSize};
    imageView.hidden = NO;
    [imageView.layer removeAnimationForKey:@"contents"];
    
    UIView *badge = imageView.subviews.firstObject;
    
    if (pic.isGif) {
        badge.layer.contents = (__bridge id)([JokeHelper imageNamed:@"timelineGIF"].CGImage);
        badge.hidden = NO;
    } else {
        if (badge.layer.contents) {
            badge.layer.contents = nil;
            badge.hidden = YES;
        }
    }
    
    
    @weakify(imageView);
    [imageView yy_setImageWithURL:pic.middleUrl
                      placeholder:nil
                          options:YYWebImageOptionAvoidSetImage
                       completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                           
                           @strongify(imageView);
                           if (!imageView) return;
                           if (image && stage == YYWebImageStageFinished) {
                               
                               imageView.image = image;
                               if (from != YYWebImageFromMemoryCacheFast) {
                                   CATransition *transition = [CATransition animation];
                                   transition.duration = 0.15;
                                   transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                   transition.type = kCATransitionFade;
                                   [imageView.layer addAnimation:transition forKey:@"contents"];
                               }
                           }
                           
                       }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [(_contentView) performSelector:@selector(setBackgroundColor:) withObject:kJokeCellHighlightColor afterDelay:0.15];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
    
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
    [NSObject cancelPreviousPerformRequestsWithTarget:_contentView selector:@selector(setBackgroundColor:) object:kJokeCellHighlightColor];
    
    _contentView.backgroundColor = [UIColor whiteColor];
}

@end


@implementation JokeTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _statusView = [JokeBodyView new];
    _statusView.cell = self;
    _statusView.toolbarView.cell = self;
    [self.contentView addSubview:_statusView];
    return self;
}

- (void)prepareForReuse {
    // ignore
}

- (void)setLayout:(JokeTextLayout *)layout {
    self.height = layout.height;
    self.contentView.height = layout.height;
    _statusView.layout = layout;
}

@end


@implementation JokeVideoToolbarView
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kJokeVideoCellTextWidth;
        frame.size.height = kJokeVideoCellToolBarHeight;
        frame.origin.y = kJokeVideoCellToolBarTop;
        frame.origin.x = kJokeVideoCellTextLeft;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    CGFloat selfH = CGFloatPixelRound(self.height - 4);
    CGFloat selfTop = CGFloatPixelRound(4);
    
    _timeLabel = [YYLabel new];
    _timeLabel.top = selfTop;
    _timeLabel.left = 0;
    _timeLabel.width = kJokeCellContentWidth;
    _timeLabel.height = selfH;
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.displaysAsynchronously = YES;
    _timeLabel.ignoreCommonProperties = YES;
    _timeLabel.fadeOnAsynchronouslyDisplay = NO;
    _timeLabel.fadeOnHighlight = NO;

    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.exclusiveTouch = YES;
    _commentButton.userInteractionEnabled = NO;
    _commentButton.top = selfTop;
    _commentButton.size = CGSizeMake(CGFloatPixelRound(50), selfH);
    _commentButton.right = CGFloatPixelRound(kJokeVideoCellTextWidth - kJokeVideoCellLeftRightMargin);
    
    
    _lookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookButton.exclusiveTouch = YES;
    _lookButton.userInteractionEnabled = NO;
    _lookButton.top = selfTop;
    _lookButton.size = CGSizeMake(CGFloatPixelRound(50), selfH);
    _lookButton.right = CGFloatPixelRound(_commentButton.left - kJokeVideoCellLeftRightMargin);
    
    
    
    _lookImageView = [[UIImageView alloc] initWithImage:[JokeHelper imageNamed:@"favicon_btn_listpage"]];
    _lookImageView.centerY = _lookButton.height / 2;
    [_lookButton addSubview:_lookImageView];
    
    _commentImageView = [[UIImageView alloc] initWithImage:[JokeHelper imageNamed:@"digupicon_btn_listpage"]];
    _commentImageView.centerY = _commentButton.height / 2;
    [_commentButton addSubview:_commentImageView];
    
    _lookLabel = [YYLabel new];
    _lookLabel.userInteractionEnabled = NO;
    _lookLabel.height = selfH;
    _lookLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _lookLabel.displaysAsynchronously = YES;
    _lookLabel.ignoreCommonProperties = YES;
    _lookLabel.fadeOnHighlight = NO;
    _lookLabel.fadeOnAsynchronouslyDisplay = NO;
    [_lookButton addSubview:_lookLabel];
    
    
    _commentLabel = [YYLabel new];
    _commentLabel.userInteractionEnabled = NO;
    _commentLabel.height = selfH;
    _commentLabel.width = _commentButton.width;
    _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _commentLabel.displaysAsynchronously = YES;
    _commentLabel.ignoreCommonProperties = YES;
    _commentLabel.fadeOnHighlight = NO;
    _commentLabel.fadeOnAsynchronouslyDisplay = NO;
    [_commentButton addSubview:_commentLabel];
    

    
    
    [self addSubview:_timeLabel];
    [self addSubview:_lookButton];
    [self addSubview:_commentButton];

    
    return self;
}

- (void)setWithLayout:(JokeVideoLayout *)layout {
    
    _timeLabel.width = layout.toolbarTimeTextWidth;
    _timeLabel.textLayout = layout.toolbarTimeTextLayout;
    
    _commentLabel.width = layout.toolbarCommentTextWidth;
    _commentLabel.textLayout = layout.toolbarCommentTextLayout;

    _lookLabel.textLayout = layout.toolbarLookTextLayout;
    _lookLabel.width = layout.toolbarLookTextWidth;
    
    [self adjustImage:_commentImageView label:_commentLabel inButton:_commentButton];
    [self adjustImage:_lookImageView label:_lookLabel inButton:_lookButton];

}

- (void)adjustImage:(UIImageView *)image label:(YYLabel *)label inButton:(UIButton *)button {
    CGFloat imageWidth = image.bounds.size.width;
    CGFloat labelWidth = label.width;
    CGFloat paddingMid = 5;
    CGFloat paddingSide = (button.width - imageWidth - labelWidth - paddingMid) / 2.0;
    image.centerX = CGFloatPixelRound((paddingSide + imageWidth / 2));
    label.right = CGFloatPixelRound((button.width - paddingSide));
}

@end

@implementation JokeVideoBodyView
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kJokeCellWidth;
        frame.size.height = kJokeVideoCellHeight;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    
    _contentView = [UIView new];
    _contentView.width = kJokeCellWidth;
    _contentView.height = kJokeVideoCellContentHeight;
    _contentView.left = kJokeCellTopMargin;
    _contentView.top = kJokeCellTopMargin;
    
    _contentView.backgroundColor = [UIColor whiteColor];

    static UIImage *topLineBG, *leftLineBG, *bottomLineBG, *rightLineBG;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        topLineBG = [UIImage yy_imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, 3, 4, 4));
            CGContextFillPath(context);
        }];
        
        leftLineBG = [UIImage yy_imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(1, 0, 1, 3));
            CGContextFillPath(context);
        }];
        
        
        bottomLineBG = [UIImage yy_imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0.4), 2, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(-2, -2, 4, 2));
            CGContextFillPath(context);
        }];
        
        rightLineBG = [UIImage yy_imageWithSize:CGSizeMake(3, 1) drawBlock:^(CGContextRef context) {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0.4), 2, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
            CGContextAddRect(context, CGRectMake(0, 1, 3, 1));
            CGContextFillPath(context);
        }];
    });
    UIImageView *topLine = [[UIImageView alloc] initWithImage:topLineBG];
    topLine.width = _contentView.width;
    topLine.bottom = 0;
    topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [_contentView addSubview:topLine];
    
    UIImageView *leftLine = [[UIImageView alloc] initWithImage:leftLineBG];
    leftLine.width = kJokeCellPaddingPic;
    leftLine.right = 0;
    leftLine.height = kJokeVideoCellContentHeight;
    [_contentView addSubview:leftLine];
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:bottomLineBG];
    bottomLine.width = _contentView.width;
    bottomLine.top = _contentView.height;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_contentView addSubview:bottomLine];
    [self addSubview:_contentView];
    
    UIImageView *rightLine = [[UIImageView alloc] initWithImage:rightLineBG];
    rightLine.width = kJokeCellPaddingPic;
    rightLine.left = _contentView.width;
    rightLine.height = kJokeVideoCellContentHeight;
    [_contentView addSubview:rightLine];
    
    CALayer *backLayer = [[CALayer alloc] init];
    backLayer.frame = CGRectPixelRound(CGRectMake(kJokeVideoCellPicLeft, kJokeVideoCellPicTop, kJokeVideoCellPicWidth, kJokeVideoCellPicHeight));
    [backLayer yy_setImageWithURL:nil placeholder:[JokeHelper imageNamed:@"video_holder"]];
    [_contentView.layer addSublayer:backLayer];
    
    YYAnimatedImageView *imageView = [YYAnimatedImageView new];
    imageView.left = CGFloatPixelRound(kJokeVideoCellPicLeft + kJokeVideoCellPicBoaderWidth);
    imageView.top = CGFloatPixelRound(kJokeVideoCellPicTop + kJokeVideoCellPicBoaderWidth);
    imageView.size = CGSizePixelRound(CGSizeMake(kJokeVideoCellPicWidth - 2 * kJokeVideoCellPicBoaderWidth, kJokeVideoCellPicHeight - 2 * kJokeVideoCellPicBoaderWidth));
    imageView.hidden = YES;
    imageView.exclusiveTouch = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;

//    imageView.backgroundColor = kJokeCellHighlightColor;
//    imageView.layer.shadowOpacity = 0.5;    // 阴影不透明度
//    imageView.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
//    imageView.layer.shadowRadius = 3.0;    // 阴影半径
//    // shadowOffset 阴影偏移
//    imageView.layer.shadowOffset = CGSizeMake(0, 2); // CGSizeMake(0, 0) 四个边阴影，CGSizeMake(5, 5) 两个边阴影
//    //加快速度 避免离屏渲染
//    imageView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:[imageView bounds]] CGPath]; // 阴影路径

    [_contentView addSubview:imageView];
    _picView = imageView;

    
    _textLabel = [YYLabel new];
    _textLabel.top = CGFloatPixelRound(kJokeVideoCellPicTop);
    _textLabel.left = CGFloatPixelRound(kJokeVideoCellTextLeft);
    _textLabel.width = CGFloatPixelRound(kJokeVideoCellTextWidth);
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.fadeOnHighlight = NO;
    [_contentView addSubview:_textLabel];
    

    _toolbarView = [JokeVideoToolbarView new];
    [_contentView addSubview:_toolbarView];
    
    return self;
}


- (void)setLayout:(JokeVideoLayout *)layout {
    _layout = layout;
    self.height = layout.height;


    [self _setImageView];

    _textLabel.textLayout = layout.textLayout;
    _textLabel.height = layout.textHeight;
    
    [_toolbarView setWithLayout:layout];
}


- (void)_setImageView {

    
    YYAnimatedImageView *imageView = _picView;

    imageView.hidden = NO;
    [imageView.layer removeAnimationForKey:@"contents"];
    
    
    
    @weakify(imageView);
    [imageView yy_setImageWithURL:_layout.joke.vpic_small
                      placeholder:nil
                          options:YYWebImageOptionAvoidSetImage
                       completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                           
                           @strongify(imageView);
                           if (!imageView) return;
                           if (image && stage == YYWebImageStageFinished) {
                               
                               
                               imageView.image = image;
                               if (from != YYWebImageFromMemoryCacheFast) {
                                   CATransition *transition = [CATransition animation];
                                   transition.duration = 0.15;
                                   transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                   transition.type = kCATransitionFade;
                                   [imageView.layer addAnimation:transition forKey:@"contents"];
                               }
                           }
                           
                       }];
    
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    [(_contentView) performSelector:@selector(setBackgroundColor:) withObject:kJokeCellHighlightColor afterDelay:0.15];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self touchesRestoreBackgroundColor];
//    
//    
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self touchesRestoreBackgroundColor];
//}
//
//- (void)touchesRestoreBackgroundColor {
//    [NSObject cancelPreviousPerformRequestsWithTarget:_contentView selector:@selector(setBackgroundColor:) object:kJokeCellHighlightColor];
//    
//    _contentView.backgroundColor = [UIColor whiteColor];
//}



@end

@implementation JokeVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _statusView = [JokeVideoBodyView new];
    _statusView.cell = self;
    _statusView.toolbarView.cell = self;
    [self.contentView addSubview:_statusView];

    return self;
}

- (void)prepareForReuse {
    // ignore
}

- (void)setLayout:(JokeVideoLayout *)layout {
    self.height = layout.height;
    self.contentView.height = layout.height;
    _statusView.layout = layout;
}


@end