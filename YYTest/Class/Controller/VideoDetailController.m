//
//  VideoDetailController.m
//  YYTest
//
//  Created by chengxianghe on 16/2/2.
//  Copyright © 2016年 CXH. All rights reserved.
//

#import "VideoDetailController.h"
#import <ZFPlayer/ZFPlayer.h>
#import "YYFPSLabel.h"
#import "YYTableView.h"
#import "UIColor+YYAdd.h"
#import "UIView+YYAdd.h"
#import <MJRefresh.h>

@protocol MySessionDelegate <NSObject>
@optional
- (void)sessionLocationURL:(NSString *)url;
- (void)sessionLocationURLFailed:(NSURL *)url;

@end

@interface MySessionHelper : NSObject <NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, weak) id<MySessionDelegate> delegate;
@end

@implementation MySessionHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        
    }
    return self;
}

- (void)dealloc {
    [self.session invalidateAndCancel];
}

//处理重定向请求，直接使用nil来取消重定向请求
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    completionHandler(nil);
    //http://49.4.178.176/vplay.aixifan.com/des/20160130/3140937_MP4/3140937_480p.mp4?k=9cf9bdb9e759101764aad0f8dd292781&t=1454387542
}

- (void)sendRequest:(NSURL *)url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    //    request.HTTPBody = [url.parameterString dataUsingEncoding:NSStringEncodingConversionAllowLossy allowLossyConversion:true];
    
    NSURLSessionTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //由于拦截了302，设置了completionHandler参数为nil，所以忽略了重定向请求，这里返回的Response就是包含302状态码的Response了。
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        NSLog(@"%@", resp);
        NSLog(@"包含302状态的Response Header字段 ：%@", resp.allHeaderFields);
        
        NSString *url = resp.allHeaderFields[@"Location"];
        
        if (url.length && [self.delegate respondsToSelector:@selector(sessionLocationURL:)]) {
            [self.delegate sessionLocationURL:url];
        } else if([self.delegate respondsToSelector:@selector(sessionLocationURLFailed:)]) {
            [self.delegate sessionLocationURLFailed:resp.URL];
        }
        
    }];
    [task resume];
}

@end

@interface VideoDetailController () <MySessionDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@property (nonatomic, strong) NSMutableArray *jokeTextArray;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, strong) ZFPlayerView *playerView;     //
@property (nonatomic, strong) JokeVideoModel *videoModel;

@end

@implementation VideoDetailController

- (instancetype)initWithVideoModel:(JokeVideoModel *)videoModel {
    self = [super init];
    if (self) {
        _videoModel = videoModel;
//        _tableView = [YYTableView new];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
        _jokeTextArray = [NSMutableArray array];
        _currentIndex = 0;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tabBarController.tabBar setHidden:NO];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
        
    if (self.videoModel.fetch_play_url) {
        NSURL *url = self.videoModel.vplay_url;
        
        MySessionHelper *help = [[MySessionHelper alloc] init];
        help.delegate = self;
        [help sendRequest:url];
        
    } else {
        self.playerView = [[ZFPlayerView alloc] init];
        [self.view addSubview:self.playerView];
        [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
            make.left.right.equalTo(self.view);
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
        }];
        self.playerView.videoURL = self.videoModel.vplay_url;
        // Back button event
        __weak typeof(self) weakSelf = self;
        self.playerView.goBackBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    
    //    http://49.4.178.176:80/vplay.aixifan.com/des/20160130/3140937_MP4/3140937_480p.mp4?k=9cf9bdb9e759101764aad0f8dd292781&t=1454387542
    [self configUI];
    
//    [self configRefresh];
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = 100;
    _fpsLabel.left = 10;
    _fpsLabel.alpha = 0;
    [self.view addSubview:_fpsLabel];
    
    if (kSystemVersion < 7) {
        _fpsLabel.top -= 44;
        _tableView.top -= 64;
        _tableView.height += 20;
    }
}

//- (void)configRefresh {
//    @weakify(self);
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        if ([weak_self.tableView.mj_footer isRefreshing]) {
//            [weak_self.tableView.mj_header endRefreshing];
//            return;
//        }
////        [weak_self requestVideoDetailIsGetMore:NO];
//    }];
//    
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        
//        if ([weak_self.tableView.mj_header isRefreshing]) {
//            [weak_self.tableView.mj_footer endRefreshing];
//            return;
//        }
//
////        [weak_self requestVideoDetailIsGetMore:YES];
//
//    }];
//    [(MJRefreshAutoNormalFooter *)_tableView.mj_footer setTitle:@"" forState:MJRefreshStateIdle];
//}

- (void)sessionLocationURL:(NSString *)url {
    if (url) {
        // 这个重定向的url
        NSLog(@"重定向:%@", url);
    }
}

- (void)sessionLocationURLFailed:(NSURL *)url {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
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
