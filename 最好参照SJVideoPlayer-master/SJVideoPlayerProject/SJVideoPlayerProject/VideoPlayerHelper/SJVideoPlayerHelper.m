//
//  SJVideoPlayerHelper.m
//  SJVideoPlayerProject
//
//  Created by BlueDancer on 2018/2/25.
//  Copyright © 2018年 SanJiang. All rights reserved.
//

#import "SJVideoPlayerHelper.h"
#import "SJVideoPlayer.h"
#import <Masonry/Masonry.h>
#import "SJFilmEditingResultShareItem.h"
#import <objc/message.h>
#import "SJMediaDownloader.h"
#import <UIViewController+SJVideoPlayerAdd.h>
#import <SJBaseVideoPlayer/SJBaseVideoPlayer+PlayStatus.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJVideoPlayerHelper ()

@property (nonatomic, strong, readwrite, nullable) SJVideoPlayer *videoPlayer;
@property (nonatomic, assign) SJVideoPlayerType playerType;

@end

NS_ASSUME_NONNULL_END

@implementation SJVideoPlayerHelper

- (instancetype)initWithViewController:(__weak UIViewController<SJVideoPlayerHelperUseProtocol> *)viewController {
    return [self initWithViewController:viewController playerType:0];
}

- (instancetype)initWithViewController:(__weak UIViewController<SJVideoPlayerHelperUseProtocol> *)viewController playerType:(SJVideoPlayerType)playerType {
    self = [super init];
    if ( !self ) return nil;
    self.playerType = playerType;
    self.viewController = viewController;
    return self;
}
- (void)setViewController:(UIViewController<SJVideoPlayerHelperUseProtocol> *)viewController {
    if ( viewController == _viewController ) return;
    _viewController = viewController;
    
    // pop gesture
    __weak typeof(self) _self = self;
    viewController.sj_viewWillBeginDragging = ^(UIViewController *vc) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        // video player disable roatation
        self.videoPlayer.disableAutoRotation = YES;   // 触发全屏手势时, 禁止播放器旋转
    };
    
    viewController.sj_viewDidEndDragging = ^(UIViewController *vc) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        // video player enable roatation
        self.videoPlayer.disableAutoRotation = NO;    // 恢复旋转
    };
}
@end




@implementation SJVideoPlayerHelper (FilmEditing)
- (void)setFilmEditingConfig:(SJVideoPlayerFilmEditingConfig *)filmEditingConfig {
    objc_setAssociatedObject(self, @selector(filmEditingConfig), filmEditingConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SJVideoPlayerFilmEditingConfig *)filmEditingConfig {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setUploader:(id<SJVideoPlayerFilmEditingResultUpload>)uploader {
    objc_setAssociatedObject(self, @selector(uploader), uploader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id<SJVideoPlayerFilmEditingResultUpload>)uploader {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setEnableFilmEditing:(BOOL)enableFilmEditing {
    objc_setAssociatedObject(self, @selector(enableFilmEditing), @(enableFilmEditing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)enableFilmEditing {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end




#pragma mark -
@implementation SJVideoPlayerHelper (SJVideoPlayerOperation)

- (void)setDisableAutoRotation:(BOOL)disableAutoRotation  {
    self.videoPlayer.disableAutoRotation = disableAutoRotation;
}

- (BOOL)disableAutoRotation {
    return self.videoPlayer.disableAutoRotation;
}

- (void)setSupportedOrientation:(SJAutoRotateSupportedOrientation)supportedOrientation {
    self.videoPlayer.supportedOrientation = supportedOrientation;
}

- (SJAutoRotateSupportedOrientation)supportedOrientation {
    return self.videoPlayer.supportedOrientation;
}
- (void)rotate:(SJOrientation)orientation
      animated:(BOOL)animated
    completion:(void (^ _Nullable)(__kindof SJVideoPlayerHelper *helper))block {
    [self.videoPlayer rotate:orientation animated:animated completion:^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        if ( block ) block(self);
    }];
}
- (void)setLockScreen:(BOOL)lockScreen {
    self.videoPlayer.lockedScreen = lockScreen;
}
- (BOOL)lockScreen {
    return self.videoPlayer.isLockedScreen;
}

- (void)setRate:(CGFloat)rate {
    self.videoPlayer.rate = rate;
}

- (CGFloat)rate {
    return self.videoPlayer.rate;
}

- (void)playWithAsset:(SJVideoPlayerURLAsset *)asset playerParentView:(UIView *)playerParentView {
    __weak typeof(self) _self = self;
    
    if ( !_videoPlayer.isFullScreen ) {
        // old player fade out
        [_videoPlayer stopAndFadeOut];
        
        // create new player
        switch ( _playerType ) {
            case SJVideoPlayerType_Default: {
                _videoPlayer = [SJVideoPlayer player];
                _videoPlayer.generatePreviewImages = YES;
            }
                break;
            case SJVideoPlayerType_Lightweight: {
                _videoPlayer = [SJVideoPlayer lightweightPlayer];
                _videoPlayer.topControlItems = self.topItemsOfLightweightControlLayer;
                _videoPlayer.clickedTopControlItemExeBlock = ^(SJVideoPlayer * _Nonnull player, SJLightweightTopItem * _Nonnull item) {
                    __strong typeof(_self) self = _self;
                    if ( !self ) return;
                    if ( self.userClickedTopItemOfLightweightControlLayerExeBlock ) self.userClickedTopItemOfLightweightControlLayerExeBlock(self, item);
                };
            }
                break;
        }
    }
    
    // play asset
    _videoPlayer.URLAsset = asset;
    _videoPlayer.pausedToKeepAppearState = YES;
    
    // add player view to parent view
    [playerParentView addSubview:_videoPlayer.view];
    [_videoPlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    // player view fade in
    _videoPlayer.view.alpha = 0.001;
    [UIView animateWithDuration:0.5 animations:^{
        self->_videoPlayer.view.alpha = 1;
    }];
    
    // The block invoked when the `control view` is `hidden` or `displayed`
    _videoPlayer.controlLayerAppearStateChanged = ^(SJVideoPlayer * _Nonnull player, BOOL displayed) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.controlLayerAppearStateChangedExeBlock ) self.controlLayerAppearStateChangedExeBlock(self, displayed);
    };
    
    // The block invoked when player rate changed
    _videoPlayer.rateChanged = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.playerRateChangedExeBlock ) self.playerRateChangedExeBlock(self, player.rate);
    };
    
    // update prompt view background color
    _videoPlayer.prompt.update(^(SJPromptConfig * _Nonnull config) {
        config.backgroundColor = [UIColor colorWithWhite:0 alpha:0.76];
    });
    
    if ( self.enableFilmEditing ) {
        _videoPlayer.enableFilmEditing = YES;
        [_videoPlayer.filmEditingConfig config:self.filmEditingConfig];
    }
    
    // The block invoked when play did to end
    _videoPlayer.playDidToEndExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.playDidToEnd ) self.playDidToEnd(self);
    };
    
    _videoPlayer.moreSettings = @[[[SJVideoPlayerMoreSetting alloc] initWithTitle:@"下载" image:[UIImage imageNamed:@"download"] clickedExeBlock:^(SJVideoPlayerMoreSetting * _Nonnull model) {
#ifdef DEBUG
        NSLog(@"%d - %s", (int)__LINE__, __func__);
#endif
    }]];
}

- (void)clearPlayer {
    [self.videoPlayer.view removeFromSuperview];
    _videoPlayer = nil;
}

- (void)clearAsset {
    _videoPlayer.URLAsset = nil;
}

- (void)pause {
    [_videoPlayer pause];
}

- (void)play {
    [_videoPlayer play];
}

@end


#pragma mark -
@implementation SJVideoPlayerHelper (SJVideoPlayerProperty)
- (void)setPlayDidToEnd:(void (^)(SJVideoPlayerHelper * _Nonnull))playDidToEnd {
    objc_setAssociatedObject(self, @selector(playDidToEnd), playDidToEnd, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(SJVideoPlayerHelper * _Nonnull))playDidToEnd {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setControlLayerAppearStateChangedExeBlock:(void (^)(SJVideoPlayerHelper * _Nonnull, BOOL))controlLayerAppearStateChangedExeBlock {
    objc_setAssociatedObject(self, @selector(controlLayerAppearStateChangedExeBlock), controlLayerAppearStateChangedExeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(SJVideoPlayerHelper * _Nonnull, BOOL))controlLayerAppearStateChangedExeBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPlayerRateChangedExeBlock:(void (^)(SJVideoPlayerHelper * _Nonnull, float))playerRateChangedExeBlock {
    objc_setAssociatedObject(self, @selector(playerRateChangedExeBlock), playerRateChangedExeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(SJVideoPlayerHelper * _Nonnull, float))playerRateChangedExeBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTopItemsOfLightweightControlLayer:(NSArray<SJLightweightTopItem *> *)topItemsOfLightweightControlLayer {
    objc_setAssociatedObject(self, @selector(topItemsOfLightweightControlLayer), topItemsOfLightweightControlLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<SJLightweightTopItem *> *)topItemsOfLightweightControlLayer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUserClickedTopItemOfLightweightControlLayerExeBlock:(void (^)(SJVideoPlayerHelper * _Nonnull, SJLightweightTopItem * _Nonnull))userClickedTopItemOfLightweightControlLayerExeBlock {
    objc_setAssociatedObject(self, @selector(userClickedTopItemOfLightweightControlLayerExeBlock), userClickedTopItemOfLightweightControlLayerExeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (void (^)(SJVideoPlayerHelper * _Nonnull, SJLightweightTopItem * _Nonnull))userClickedTopItemOfLightweightControlLayerExeBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (SJVideoPlayerURLAsset *)asset {
    return self.videoPlayer.URLAsset;
}

- (SJPrompt *)prompt {
    return _videoPlayer.prompt;
}

- (NSURL *)currentPlayURL {
    return self.videoPlayer.URLAsset.mediaURL;
}

- (NSTimeInterval)currentTime {
    return self.videoPlayer.currentTime;
}

- (NSTimeInterval)totalTime {
    return self.videoPlayer.totalTime;
}

@end




#pragma mark -

@implementation SJVideoPlayerHelper (UIViewControllerHelper)
- (void (^)(void))vc_viewDidAppearExeBlock {
    __weak typeof(self) _self = self;
    return ^ () {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self.videoPlayer vc_viewDidAppear];
    };
}

- (void (^)(void))vc_viewWillDisappearExeBlock {
    __weak typeof(self) _self = self;
    return ^ () {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self.videoPlayer vc_viewWillDisappear];
    };
}

- (void (^)(void))vc_viewDidDisappearExeBlock {
    __weak typeof(self) _self = self;
    return ^ () {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self.videoPlayer vc_viewDidDisappear];
    };
}

- (BOOL (^)(void))vc_prefersStatusBarHiddenExeBlock {
    __weak typeof(self) _self = self;
    return ^BOOL () {
        __strong typeof(_self) self = _self;
        if ( !self ) return NO;
        return [self.videoPlayer vc_prefersStatusBarHidden];
    };
}

- (UIStatusBarStyle (^)(void))vc_preferredStatusBarStyleExeBlock {
    __weak typeof(self) _self = self;
    return ^UIStatusBarStyle () {
        __strong typeof(_self) self = _self;
        if ( !self ) return  UIStatusBarStyleDefault;
        return [self.videoPlayer vc_preferredStatusBarStyle];
    };
}
@end

