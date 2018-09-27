//
//  JRPlayerView.m
//  精锐播放器
//
//  Created by maqianli on 2018/9/19.
//  Copyright © 2018年 onesmart. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "JRPlayerView.h"
#import "JRPlayerControlView.h"

@import Masonry;
@interface JRPlayerView ()

@property (nonatomic, strong) UIView *fatherView;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) id playTimeObserver;

@property (nonatomic, strong) JRPlayerControlView *playerControlView;


/**
 添加AVPlayer
 */
-(void)addAVPlayer;

/**
 添加JRPlayerControlView
 */
-(void)addJRPlayerControlView;

/**
 设置新的AVPlayerItem

 @param url 视频资源地主
 */
-(void)setPlayerItemWithURL:(NSURL*)url;


@end

@implementation JRPlayerView

/**
 工厂方法：获取播放器视图
 
 @param url 视频资源地址
 @return 播放器视图
 */
+(instancetype)playerViewWithURL:(NSURL*)url{
    JRPlayerView *playerView = [JRPlayerView new];
    playerView.backgroundColor = [UIColor yellowColor];
    [playerView setPlayerItemWithURL:url];
    return playerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.redColor;
        [self addAVPlayer];
        [self addJRPlayerControlView];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserverForAVPlayerItem];
    [self removeMonitoringPlayback];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //设置播放器层位置
    _playerLayer.frame = self.bounds;
    
    //设置播放器控制条视图
    _playerControlView.frame = self.bounds;
}

/**
 添加AVPlayer
 */
-(void)addAVPlayer{
    _player = [AVPlayer new];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:_playerLayer];
}

/**
 添加JRPlayerControlView
 */
-(void)addJRPlayerControlView{
    _playerControlView = [JRPlayerControlView new];
    [self addSubview:_playerControlView];
    
    __weak typeof(self) weakSelf = self;
    
    _playerControlView.playBtnClicked = ^{
        NSLog(@"playBtnClicked");
        [weakSelf.player play];
    };
    
    _playerControlView.pauseBtnClicked = ^{
        NSLog(@"pauseBtnClicked");
        [weakSelf.player pause];
    };
    
    _playerControlView.maxBtnClicked = ^{
        NSLog(@"maxBtnClicked");
        
        //记录父视图、标记全屏
        weakSelf.fatherView  = weakSelf.superview;
        
        //获取window作为新的父视图
        UIWindow *window = [(id)[UIApplication sharedApplication].delegate valueForKey:@"window"];
        //将当前坐标系下的frme转换成windowx坐标系的坐标(目的保证平滑移动)
        CGRect con_portraitRect = [window convertRect:weakSelf.superview.bounds fromView:weakSelf.superview];
        //正向旋转90度
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
        
        weakSelf.frame = con_portraitRect;
        [window addSubview:weakSelf];
        
        //隐藏状态栏
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationOfHideStatusBar object:nil];
        
        [UIView animateWithDuration:0.2 animations:^{
            //先旋转
            weakSelf.transform = transform;
            //改变frame
            CGFloat width  = window.bounds.size.width;
            CGFloat height = window.bounds.size.height;
            CGFloat max = MAX(width, height);
            CGFloat min = MIN(width, height);
            weakSelf.bounds = (CGRect){CGPointZero, (CGSize){max, min}};
            weakSelf.center = (CGPoint){min * 0.5, max * 0.5};
        }];
    };
    
    _playerControlView.minBtnClicked = ^{
        NSLog(@"minBtnClicked");
        
        //获取获取当前父视图
        UIWindow *window = [(id)[UIApplication sharedApplication].delegate valueForKey:@"window"];
        //将以前fatherView坐标系在的坐标，换成window坐标系下的坐标
        CGRect con_portraitRect = [window convertRect:weakSelf.fatherView.bounds fromView:weakSelf.fatherView];
        //恢复到原始角度
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        //显示状态栏
        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationOfShowStatusBar object:nil];
        
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.transform = transform;
            
            weakSelf.bounds = (CGRect){CGPointZero, con_portraitRect.size};
            weakSelf.center =
            (CGPoint){con_portraitRect.origin.x +
                con_portraitRect.size.width * 0.5,
                con_portraitRect.origin.y +
                con_portraitRect.size.height * 0.5};
            
        } completion:^(BOOL finished) {
            [weakSelf.fatherView addSubview:weakSelf];
            weakSelf.frame = weakSelf.fatherView.bounds;
        }];
    };
    
    _playerControlView.backBtnClicked = ^{
        NSLog(@"backBtnClicked");
    };
}

/**
 设置新的AVPlayerItem
 
 @param url 视频资源地址
 */
-(void)setPlayerItemWithURL:(NSURL*)url{
    //先移除是一个item的观察者
    [self removeObserverForAVPlayerItem];
    
    //设置新的item
    AVPlayerItem *newpPlayerItem = [AVPlayerItem playerItemWithURL:url];
    [_player replaceCurrentItemWithPlayerItem:newpPlayerItem];
    
    //记录新的item
    _playerItem = newpPlayerItem;
    
    //为AVPlayerItem添加观察者
    [self addObserverForAVPlayerItem];
}

/**
 为AVPlayerItem添加观察者
 */
-(void)addObserverForAVPlayerItem{
    //观察status属性
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //观察loadedTimeRanges属性
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 移除AVPlayerItem的观察者
 */
-(void)removeObserverForAVPlayerItem{
    if (_playerItem) {
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *item = (AVPlayerItem*)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        //获取变更后的状态值
        AVPlayerStatus status = [[change objectForKey:@"new"]intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            [self readyToPlay];
            [self monitoringPlaybackWithAVPlayerItem:item];
            
        }else if (status == AVPlayerStatusFailed){
            NSLog(@"AVPlayerStatusFailed");
        }else{
            NSLog(@"AVPlayerStatusUnknown");
        }
        
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        //处理缓冲时间
    }
}

/**
 通知控制条准备播放
 */
-(void)readyToPlay{
    //1、初始化相关时间
    
}

/**
 监测播放进度
 @param item 播放项
 */
-(void)monitoringPlaybackWithAVPlayerItem:(AVPlayerItem*)item{
    [self removeMonitoringPlayback];
    
    //__weak typeof(self) weakSelf = self;
    _playTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //通知通知控制条更新播放进度
        
    }];
}

/**
 移除播放进度的监测
 */
-(void)removeMonitoringPlayback{
    if (_playTimeObserver) {
        [_player removeTimeObserver:_playTimeObserver];
        _playTimeObserver = nil;
    }
}









@end
