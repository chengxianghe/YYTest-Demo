//
//  JokeLayout.m
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import "JokeLayout.h"
#import "UIColor+YYAdd.h"
#import "JokeHelper.h"
#import "ScreenHelper.h"

@implementation JokeTextLayout : NSObject
- (instancetype)initWithTextJoke:(JokeTextModel *)joke {
    if (!joke) return nil;
    self = [super init];
    _joke = joke;
    [self layout];
    return self;
}

- (void)layout {
    [self _layout];
}
- (void)_layout {
    
    _marginTop = kJokeCellTopMargin;
    _timeHeight = kJokeCellTitleHeight;
    _textHeight = 0;
    _picHeight = 0;
    _toolbarHeight = kJokeCellToolbarHeight;
    _marginBottom = kJokeCellToolbarBottomMargin;
    
    
    // 文本排版，计算布局
    [self _layoutTime];
    [self _layoutText];
    [self _layoutPic];
    [self _layoutToolbar];
    
    // 计算高度
    _height = 0;
    _height += _marginTop;
    _height += _timeHeight;
    _height += _textHeight;
    _height += _picHeight;
    _height += _toolbarHeight;
    _height += _marginBottom;
}

- (void)_layoutTime {
    _timeHeight = 0;
    _timeTextLayout = nil;
    
    NSString *time = _joke.showTime;
    if (time.length == 0) return;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:time];
    
    text.yy_color = kJokeCellTimeColor;
    text.yy_font = [UIFont systemFontOfSize:kJokeCellTimeFontSize];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kJokeCellContentWidth, kJokeCellTitleHeight)];
    _timeTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    _timeHeight = kJokeCellTitleHeight;
}

- (void)_layoutToolbar {
    
    // should be localized
    UIFont *font = [UIFont systemFontOfSize:kJokeCellCommentFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kJokeCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    
    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:_joke.comments.longLongValue <= 0 ? @"评论" : [JokeHelper shortedNumberDesc:_joke.comments.longLongValue]];
    commentText.yy_font = font;
    commentText.yy_color = kJokeCellToolbarTitleColor;
    _toolbarCommentTextLayout = [YYTextLayout layoutWithContainer:container text:commentText];
    _toolbarCommentTextWidth = CGFloatPixelRound(_toolbarCommentTextLayout.textBoundingRect.size.width);
    
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:_joke.likes.longLongValue <= 0 ? @"赞" : [JokeHelper shortedNumberDesc:_joke.likes.longLongValue]];
    likeText.yy_font = font;
    likeText.yy_color = _joke.isLike ? kJokeCellToolbarTitleHighlightColor : kJokeCellToolbarTitleColor;
    _toolbarLikeTextLayout = [YYTextLayout layoutWithContainer:container text:likeText];
    _toolbarLikeTextWidth = CGFloatPixelRound(_toolbarLikeTextLayout.textBoundingRect.size.width);
    
    _toolbarHeight = kJokeCellToolbarHeight;

}

- (void)_layoutPic {
    
    if (_joke.photo) {

        CGFloat radio  = CGFloatPixelRound(_joke.photo.height)/CGFloatPixelRound(_joke.photo.width);
        
        _picHeight = kJokeCellContentWidth * radio + kJokeCellPaddingPic;
        _picSize = CGSizeMake(kJokeCellContentWidth, kJokeCellContentWidth * radio);
    }
}

/// 文本
- (void)_layoutText {
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [self _textWithJoke:_joke
                                                   fontSize:kJokeCellTextFontSize
                                                  textColor:kJokeCellTextNormalColor];
    if (text.length == 0) return;
    
    text.yy_lineSpacing = 5.0;
//    text.yy_kern = @1.0;

    
//    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
//    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
//    modifier.paddingTop = kWBCellPaddingText;
//    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kJokeCellContentWidth, HUGE);
//    container.linePositionModifier = modifier;
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];

    if (!_textLayout) return;
    
    _textHeight = _textLayout ? (CGRectGetMaxY(_textLayout.textBoundingRect)) : 0;

//    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];
}

- (NSMutableAttributedString *)_textWithJoke:(JokeTextModel *)joke
                                      fontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor {
    if (!joke) return nil;
    
    NSMutableString *string = joke.wbody.mutableCopy;
    if (string.length == 0) return nil;

    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kJokeCellTextHighlightBackgroundColor;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = font;
    text.yy_color = textColor;
    
    
    
    // 匹配 @用户名
    NSArray *atResults = [[JokeHelper regexAt] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [text yy_setColor:kJokeCellTextHighlightColor range:at.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{kJokeLinkAtName : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
            [text yy_setTextHighlight:highlight range:at.range];
        }
    }
    
    // 匹配 [表情]
    NSArray *emoticonResults = [[JokeHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        NSString *imagePath = [JokeHelper emoticonDic][emoString];
        UIImage *image = [JokeHelper imageWithPath:imagePath];
        //        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:fontSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    return text;
}


@end


@implementation JokeVideoLayout : NSObject
- (instancetype)initWithVideoJoke:(JokeVideoModel *)joke {
    if (!joke) return nil;
    self = [super init];
    _joke = joke;
    [self layout];
    return self;
}

- (void)layout {
    [self _layout];
}
- (void)_layout {
    _marginTop = kJokeCellTopMargin;
    _textHeight = 0;
    _picHeight = 0;
    _toolbarHeight = kJokeVideoCellToolBarHeight;
    _marginBottom = kJokeCellToolbarBottomMargin;
    
    // 文本排版，计算布局
    // 图片
    _picHeight = kJokeVideoCellPicHeight;
    _picWidth = kJokeVideoCellPicWidth;
    
    
    // text
    [self _layoutText];
    
    // toolBar
    [self _layoutToolbar];

 
    // 计算高度
    _height = kJokeVideoCellHeight;
}

- (void)_layoutToolbar {
    
    // should be localized
    UIFont *font = [UIFont systemFontOfSize:kJokeCellTimeFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kJokeVideoCellTextWidth, kJokeVideoCellToolBarHeight)];
    container.maximumNumberOfRows = 1;
    
    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:_joke.comments.longLongValue <= 0 ? @"0" : [JokeHelper shortedNumberDesc:_joke.comments.longLongValue]];
    commentText.yy_font = font;
    commentText.yy_color = kJokeCellToolbarTitleColor;
    _toolbarCommentTextLayout = [YYTextLayout layoutWithContainer:container text:commentText];
    _toolbarCommentTextWidth = CGFloatPixelRound(_toolbarCommentTextLayout.textBoundingRect.size.width);
    
    NSMutableAttributedString *lookText = [[NSMutableAttributedString alloc] initWithString:_joke.views.longLongValue <= 0 ? @"0" : [JokeHelper shortedNumberDesc:_joke.views.longLongValue]];
    lookText.yy_font = font;
    lookText.yy_color = kJokeCellToolbarTitleColor;
    _toolbarLookTextLayout = [YYTextLayout layoutWithContainer:container text:lookText];
    _toolbarLookTextWidth = CGFloatPixelRound(_toolbarLookTextLayout.textBoundingRect.size.width);
    
    
    _toolbarTimeTextLayout = nil;
    
    NSString *time = _joke.showTime;
    if (time.length == 0) return;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:time];
    
    text.yy_color = kJokeCellToolbarTitleColor;
    text.yy_font = font;
    _toolbarTimeTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    _toolbarTimeTextWidth = CGFloatPixelRound(_toolbarTimeTextLayout.textBoundingRect.size.width);
    _toolbarHeight = kJokeCellToolbarHeight;
    
}

- (void)_layoutText {
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [self _textWithJoke:_joke
                                                 fontSize:kJokeCellTextFontSize
                                                textColor:kJokeCellTextNormalColor];
    if (text.length == 0) return;
    
    text.yy_font = [UIFont systemFontOfSize:kJokeCellTextFontSize];
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kJokeVideoCellTextWidth, kJokeVideoCellContentHeight - kJokeVideoCellToolBarHeight - kJokeVideoCellTopBottomMargin);
    container.maximumNumberOfRows = 3;
    container.truncationType = YYTextTruncationTypeEnd;
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    
    _textHeight = _textLayout ? (CGRectGetMaxY(_textLayout.textBoundingRect)) : 0;

}

- (NSMutableAttributedString *)_textWithJoke:(JokeVideoModel *)joke
                                    fontSize:(CGFloat)fontSize
                                   textColor:(UIColor *)textColor {
    if (!joke) return nil;
    
    NSMutableString *string = joke.wbody.mutableCopy;
    if (string.length == 0) return nil;
    
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kJokeCellTextHighlightBackgroundColor;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = font;
    text.yy_color = textColor;
    
    
    
    // 匹配 @用户名
    NSArray *atResults = [[JokeHelper regexAt] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [text yy_setColor:kJokeCellTextHighlightColor range:at.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{kJokeLinkAtName : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
            [text yy_setTextHighlight:highlight range:at.range];
        }
    }
    
    // 匹配 [表情]
    NSArray *emoticonResults = [[JokeHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        NSString *imagePath = [JokeHelper emoticonDic][emoString];
        UIImage *image = [JokeHelper imageWithPath:imagePath];
        //        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:fontSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    return text;
}


@end