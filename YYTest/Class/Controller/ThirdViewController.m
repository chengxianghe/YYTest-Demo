//
//  ThirdViewController.m
//  YYTest
//
//  Created by chengxianghe on 16/1/18.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import "ThirdViewController.h"
#import "RequestHelper.h"
#import "YYModel.h"
#import "JokeModel.h"
#import "JokeCell.h"
#import "YYPhotoGroupView.h"
#import "YYFPSLabel.h"
#import "YYTableView.h"
#import "UIColor+YYAdd.h"
#import "UIView+YYAdd.h"
#import <MJRefresh.h>
#import "TabBarHelper.h"
#import "VideoDetailController.h"

#define offsetChange   20
#define offsetChangeBegin 0

@interface ThirdViewController ()<UITableViewDelegate, UITableViewDataSource, JokeCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@property (nonatomic, strong) NSMutableArray *jokeTextArray;
@property (nonatomic, strong) NSMutableArray *jokePhotoArray;
@property (nonatomic, strong) NSMutableArray *jokeVideoArray;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) int currentTextIndex;
@property (nonatomic, assign) int currentPhotoIndex;
@property (nonatomic, assign) int currentVideoIndex;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) BOOL isUp;

@end

@implementation ThirdViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _tableView = [YYTableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _jokeTextArray = [NSMutableArray array];
        _jokePhotoArray = [NSMutableArray array];
        _jokeVideoArray = [NSMutableArray array];
        _currentIndex = 0;
        _currentTextIndex = 0;
        _currentPhotoIndex = 0;
        _currentVideoIndex = 0;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    _tableView = [YYTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _jokeTextArray = [NSMutableArray array];
    _jokePhotoArray = [NSMutableArray array];
    _jokeVideoArray = [NSMutableArray array];
    _currentIndex = 0;
    _currentTextIndex = 0;
    _currentPhotoIndex = 0;
    _currentVideoIndex = 0;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
    
    [self configRefresh];
    
    self.segment.selectedSegmentIndex = 1;
    [self onSegment:self.segment];
}

- (void)configUI {
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    _tableView.frame = self.view.bounds;
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    self.view.backgroundColor = kJokeCellBackgroundColor;
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = 100;
    _fpsLabel.left = kJokeCellPadding;
    _fpsLabel.alpha = 0;
    [self.view addSubview:_fpsLabel];
    
    if (kSystemVersion < 7) {
        _fpsLabel.top -= 44;
        _tableView.top -= 64;
        _tableView.height += 20;
    }

    
    [_segment addTarget:self action:@selector(onSegment:) forControlEvents:UIControlEventValueChanged];
    [_segment setSelectedSegmentIndex:0];
    
    
}

- (void)configRefresh {
    @weakify(self);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([weak_self.tableView.mj_footer isRefreshing]) {
            [weak_self.tableView.mj_header endRefreshing];
            return;
        }
        
        switch (_currentIndex) {
            case 0:
                [weak_self requestTextJokesIsGetMore:NO];
                break;
            case 1:
                [weak_self requestPhotoJokesIsGetMore:NO];
                break;
            case 2:
                [weak_self requestVideoJokesIsGetMore:NO];
                break;
            default:
                break;
        }
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        if ([weak_self.tableView.mj_header isRefreshing]) {
            [weak_self.tableView.mj_footer endRefreshing];
            return;
        }
        switch (_currentIndex) {
            case 0:
                [weak_self requestTextJokesIsGetMore:YES];
                break;
            case 1:
                [weak_self requestPhotoJokesIsGetMore:YES];
                break;
            case 2:
                [weak_self requestVideoJokesIsGetMore:YES];
                break;
            default:
                break;
        }
    }];
    [(MJRefreshAutoNormalFooter *)_tableView.mj_footer setTitle:@"" forState:MJRefreshStateIdle];
}

- (void)requestTextJokesIsGetMore:(BOOL)isGetMore {
    JokeTextLayout *layout = isGetMore ? self.jokeTextArray.lastObject : self.jokeTextArray.firstObject;
    long long updateTime = layout.joke.update_time == nil ? -1 : layout.joke.update_time.longLongValue;
    long long lastId = isGetMore ? -1 : updateTime;
    long long max_timestamp = isGetMore ? updateTime : -1;
    int page = isGetMore ? _currentTextIndex + 1 : 0;
    
    @weakify(self);
    
    [RequestHelper getJokesWithCategory:JokeTypeJokes page:page latest_viewed:lastId max_timestamp:max_timestamp success:^(NSArray *array) {
        
        if (!isGetMore) {
            [weak_self.jokeTextArray removeAllObjects];
            _currentTextIndex = 0;
            [weak_self.tableView reloadData];
            weak_self.tableView.mj_header.state = MJRefreshStateIdle;
            weak_self.tableView.mj_footer.state = MJRefreshStateIdle;

        } else {
            _currentTextIndex ++;
            weak_self.tableView.mj_footer.state = MJRefreshStateIdle;
        }
        
        if (array.count) {
            // model->layout

            NSInteger lastCount = weak_self.jokeTextArray.count;
            for (JokeTextModel *model in array) {
                JokeTextLayout *layout = [[JokeTextLayout alloc] initWithTextJoke:model];
                [weak_self.jokeTextArray addObject:layout];
            }
            NSInteger nowCount = weak_self.jokeTextArray.count;
            NSMutableArray *indexs = [NSMutableArray array];
            for (NSInteger i = lastCount; i < nowCount; i ++) {
                [indexs addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            if (_currentIndex == 0) {
                [weak_self.tableView beginUpdates];
                [weak_self.tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationFade];
                [weak_self.tableView endUpdates];
                weak_self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
        } else if (isGetMore && _currentIndex == 0) {
            _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    } failur:^(NSError *error) {
        NSLog(@"TextJokesfailur:%@", error.localizedDescription);
    }];
}

- (void)requestPhotoJokesIsGetMore:(BOOL)isGetMore {
    JokeTextLayout *layout = isGetMore ? self.jokePhotoArray.lastObject : self.jokePhotoArray.firstObject;
    long long updateTime = layout.joke.update_time == nil ? -1 : layout.joke.update_time.longLongValue;
    long long lastId = isGetMore ? -1 : updateTime;
    long long max_timestamp = isGetMore ? updateTime : -1;
    int page = isGetMore ? _currentPhotoIndex + 1 : 0;

    @weakify(self);
    [RequestHelper getJokesWithCategory:JokeTypePics page:page latest_viewed:lastId max_timestamp:max_timestamp success:^(NSArray *array) {
        if (!isGetMore) {
            [weak_self.jokePhotoArray removeAllObjects];
            _currentPhotoIndex = 0;
            [weak_self.tableView reloadData];
            weak_self.tableView.mj_header.state = MJRefreshStateIdle;
            weak_self.tableView.mj_footer.state = MJRefreshStateIdle;
        } else {
            _currentPhotoIndex ++;
            weak_self.tableView.mj_footer.state = MJRefreshStateIdle;
        }
        
        if (array.count) {
            // model->layout

            NSInteger lastCount = weak_self.jokePhotoArray.count;
            for (JokeTextModel *model in array) {
                JokeTextLayout *layout = [[JokeTextLayout alloc] initWithTextJoke:model];
                [weak_self.jokePhotoArray addObject:layout];
            }
            NSInteger nowCount = weak_self.jokePhotoArray.count;
            NSMutableArray *indexs = [NSMutableArray array];
            for (NSInteger i = lastCount; i < nowCount; i ++) {
                [indexs addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            if (_currentIndex == 1) {
                [weak_self.tableView beginUpdates];
                [weak_self.tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationFade];
                [weak_self.tableView endUpdates];
                weak_self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
        } else if (isGetMore && _currentIndex == 1) {
            _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }

    } failur:^(NSError *error) {
        NSLog(@"PhotoJokesfailur:%@", error.localizedDescription);
    }];
}

- (void)requestVideoJokesIsGetMore:(BOOL)isGetMore {
    JokeVideoLayout *model = isGetMore ? self.jokeVideoArray.lastObject : self.jokeVideoArray.firstObject;
    long long updateTime = model.joke.update_time == nil ? -1 : model.joke.update_time.longLongValue;
    long long lastId = isGetMore ? -1 : updateTime;
    long long max_timestamp = isGetMore ? updateTime : -1;
    int page = isGetMore ? _currentVideoIndex + 1 : 0;

    __weak typeof(self) weak_self = self;
    
    [RequestHelper getJokesWithCategory:JokeTypeVideos page:page latest_viewed:lastId max_timestamp:max_timestamp success:^(NSArray *array) {
        if (!isGetMore) {
            [weak_self.jokeVideoArray removeAllObjects];
            _currentVideoIndex = 0;
            [weak_self.tableView reloadData];
            weak_self.tableView.mj_header.state = MJRefreshStateIdle;
            weak_self.tableView.mj_footer.state = MJRefreshStateIdle;
        } else {
            _currentVideoIndex ++;
            weak_self.tableView.mj_footer.state = MJRefreshStateIdle;
        }
        
        if (array.count) {
            // model->layout
            
            NSInteger lastCount = weak_self.jokeVideoArray.count;
            for (JokeVideoModel *model in array) {
                JokeVideoLayout *layout = [[JokeVideoLayout alloc] initWithVideoJoke:model];
                [weak_self.jokeVideoArray addObject:layout];
            }
            NSInteger nowCount = weak_self.jokeVideoArray.count;
            NSMutableArray *indexs = [NSMutableArray array];
            for (NSInteger i = lastCount; i < nowCount; i ++) {
                [indexs addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            if (_currentIndex == 2) {
                [weak_self.tableView beginUpdates];
                [weak_self.tableView insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationFade];
                [weak_self.tableView endUpdates];
                weak_self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
        } else if (isGetMore && _currentIndex == 2) {
            _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }

    } failur:^(NSError *error) {
        NSLog(@"VideoJokesfailur:%@", error.localizedDescription);
    }];
}

- (void)onSegment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex != _currentIndex) {
        _currentIndex = (int)sender.selectedSegmentIndex;
        [self.tableView reloadData];
        
        if ((sender.selectedSegmentIndex == 0 && !self.jokeTextArray.count)
            || (sender.selectedSegmentIndex == 1 && !self.jokePhotoArray.count)
            || (sender.selectedSegmentIndex == 2 && !self.jokeVideoArray.count)) {
                [self.tableView.mj_header beginRefreshing];
        } else {
            self.tableView.mj_footer.state = MJRefreshStateIdle;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (_tableView != scrollView || _fpsLabel.alpha == 0 || offsetY < offsetChangeBegin || scrollView.contentSize.height - offsetY - kScreenHeight < 0) {
        return;
    }
    
    if (_lastOffsetY - offsetY > offsetChange) { // 上移
        if (self.isUp == true) {
            self.isUp = false;
            [TabBarHelper hidesTabBar:self.isUp];
        }
    }
    if (offsetY - _lastOffsetY > offsetChange) {
        if (self.isUp == false) {
            self.isUp = true;
            [TabBarHelper hidesTabBar:self.isUp];
        }
    }
    _lastOffsetY = offsetY;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 0;
        } completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - UITableViewDataSorce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_currentIndex) {
        case 0: return self.jokeTextArray.count; break;
        case 1: return self.jokePhotoArray.count; break;
        case 2: return self.jokeVideoArray.count; break;
        default: return 0; break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentIndex == 0 || _currentIndex == 1) {
        NSString *cellID = @"JokeTextCell";
        JokeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[JokeTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.delegate = self;
        }
        JokeTextLayout *layout = _currentIndex == 0 ? _jokeTextArray[indexPath.row] : _jokePhotoArray[indexPath.row];
        [cell setLayout:layout];
        return cell;
    } else {
        NSString *cellID = @"JokeVideoCell";
        JokeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[JokeVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell setLayout:_jokeVideoArray[indexPath.row]];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_currentIndex) {
        case 0: return ((JokeTextLayout *)_jokeTextArray[indexPath.row]).height; break;
        case 1: return ((JokeTextLayout *)_jokePhotoArray[indexPath.row]).height; break;
        case 2: return ((JokeVideoLayout *)_jokeVideoArray[indexPath.row]).height; break;
        default: return 0; break;
    }
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_segment.selectedSegmentIndex != 2) {
        return;
    }
    
    JokeVideoLayout *layout = _jokeVideoArray[indexPath.row];
    
    VideoDetailController *vc = [[VideoDetailController alloc] initWithVideoModel:layout.joke];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JokeCellDelegate

/// 点击了评论
- (void)cellDidClickComment:(JokeTextCell *)cell {
    //    WBStatusComposeViewController *vc = [WBStatusComposeViewController new];
    //    vc.type = WBStatusComposeViewTypeComment;
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    //    @weakify(nav);
    //    vc.dismiss = ^{
    //        @strongify(nav);
    //        [nav dismissViewControllerAnimated:YES completion:NULL];
    //    };
    //    [self presentViewController:nav animated:YES completion:NULL];
}

/// 点击了赞
- (void)cellDidClickLike:(JokeTextCell *)cell {
    JokeTextModel *status = cell.statusView.layout.joke;
    [cell.statusView.toolbarView setLiked:!status.isLike withAnimation:YES];
}

/// 点击了图片
- (void)cell:(JokeTextCell *)cell didClickImageAtIndex:(NSUInteger)index {
    UIImageView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    JokeTextModel *status = cell.statusView.layout.joke;
    JokePhotoItem *photoItem = status.photo;
    
        UIImageView *imgView = cell.statusView.picView;

        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = photoItem.middleUrl;
        item.largeImageSize = CGSizeMake(photoItem.width, photoItem.height);
        [items addObject:item];
        fromView = imgView;
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}

/// 点击了 Label 的链接
- (void)cell:(JokeTextCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    YYTextHighlight *highlight = [text yy_attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    if (info.count == 0) return;
  
    
    if (info[kJokeLinkAtName]) {
        NSString *name = info[kJokeLinkAtName];
        NSLog(@"kJokeLinkAtName: %@", name);
//        name = [name stringByURLEncode];
//        if (name.length) {
//            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/n/%@",name];
//            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
        return;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
