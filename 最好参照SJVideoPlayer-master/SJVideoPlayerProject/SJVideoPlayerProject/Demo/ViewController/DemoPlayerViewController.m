//
//  DemoPlayerViewController.m
//  SJVideoPlayerProject
//
//  Created by BlueDancer on 2018/3/6.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "DemoPlayerViewController.h"
#import "SJVideoPlayerHelper.h"
#import "SJVideoPlayerURLAsset+SJControlAdd.h"
#import <SJUIFactory/SJUIFactory.h>
#import <Masonry.h>
#import "SJVideoModel.h"
#import <AVFoundation/AVFoundation.h>
#import <SJBaseVideoPlayer/SJBaseVideoPlayer.h>
#import "SJLightweightTopItem.h"
#import <UIViewController+SJVideoPlayerAdd.h>

@interface DemoPlayerViewController ()<SJVideoPlayerHelperUseProtocol>

@property (nonatomic, strong, readonly) UIView *playerSuperView;

@property (nonatomic, strong, readonly) SJVideoPlayerHelper *videoPlayerHelper;
@property (nonatomic, strong) SJVideoModel *video;
@property (nonatomic, strong) SJVideoPlayerURLAsset *asset;

@end

@implementation DemoPlayerViewController {
    SJBaseVideoPlayer *player;
}

@synthesize playerSuperView = _playerSuperView;

- (instancetype)initWithVideo:(SJVideoModel *)video asset:(SJVideoPlayerURLAsset *__nullable)asset {
    if ( !asset ) return [self initWithVideo:video beginTime:0];
    
    self = [super init];
    if ( !self ) return nil;
    _video = video;
    _asset = [[SJVideoPlayerURLAsset alloc] initWithOtherAsset:asset playModel:nil];
    _asset.title = self.video.title;
    _asset.alwaysShowTitle = YES;
    return self;
}

- (instancetype)initWithVideo:(SJVideoModel *)video beginTime:(NSTimeInterval)beginTime {
    self = [super init];
    if ( !self ) return nil;
    _video = video;
    _asset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.video.playURLStr] specifyStartTime:beginTime];
    _asset.title = video.title;
    _asset.alwaysShowTitle = YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _demoVCSetupViews];
    
    
    self.sj_displayMode = SJPreViewDisplayMode_Origin;
    
    __weak typeof(self) _self = self;
    SJLightweightTopItem *download = [[SJLightweightTopItem alloc] initWithFlag:0 imageName:@"download"];
    SJLightweightTopItem *share = [[SJLightweightTopItem alloc] initWithFlag:0 imageName:@"share"];
    self.videoPlayerHelper.topItemsOfLightweightControlLayer = @[download, share];
    self.videoPlayerHelper.userClickedTopItemOfLightweightControlLayerExeBlock = ^(SJVideoPlayerHelper * _Nonnull helper, SJLightweightTopItem * _Nonnull item) {
        [helper.prompt showTitle:@"Top Item 被点击" duration:1 hiddenExeBlock:^(SJPrompt * _Nonnull prompt) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            [self.videoPlayerHelper rotate:SJOrientation_Portrait animated:YES completion:^(__kindof SJVideoPlayerHelper * _Nonnull helper) {
                [self.navigationController pushViewController:[[DemoPlayerViewController alloc] initWithVideo:self.video asset:self.asset] animated:YES];
            }];
        }];
    };
    
    
    /// test
    if ( !_video ) {
        [self.videoPlayerHelper playWithAsset:[[SJVideoPlayerURLAsset alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"mp4"]] playerParentView:self.playerSuperView];
        return;
    }
    
    [self.videoPlayerHelper playWithAsset:_asset playerParentView:self.playerSuperView];
    // Do any additional setup after loading the view.
}

#pragma mark -
// please lazy load
@synthesize videoPlayerHelper = _videoPlayerHelper;
- (SJVideoPlayerHelper *)videoPlayerHelper {
    if ( _videoPlayerHelper ) return _videoPlayerHelper;
    _videoPlayerHelper = [[SJVideoPlayerHelper alloc] initWithViewController:self playerType:SJVideoPlayerType_Lightweight];
    return _videoPlayerHelper;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.videoPlayerHelper.vc_viewDidAppearExeBlock();
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.videoPlayerHelper.vc_viewWillDisappearExeBlock();
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.videoPlayerHelper.vc_viewDidDisappearExeBlock();
}
- (BOOL)prefersStatusBarHidden {
    return self.videoPlayerHelper.vc_prefersStatusBarHiddenExeBlock();
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

#pragma mark -
- (void)_demoVCSetupViews {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerSuperView];
    [_playerSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.offset(0);
        }
        make.leading.trailing.offset(0);
        make.height.equalTo(self.view.mas_width).multipliedBy(9 / 16.0f);
    }];
}

- (UIView *)playerSuperView {
    if ( _playerSuperView ) return _playerSuperView;
    _playerSuperView = [SJUIViewFactory viewWithBackgroundColor:[UIColor blackColor]];
    return _playerSuperView;
}
@end
