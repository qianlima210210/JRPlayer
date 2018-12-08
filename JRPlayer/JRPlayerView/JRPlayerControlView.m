//
//  JRPlayerControlView.m
//  JRPlayer
//
//  Created by maqianli on 2018/9/19.
//  Copyright © 2018年 onesmart. All rights reserved.
//

#import "MyPlayProgressView.h"
#import "JRPlayerControlView.h"

#define kControlBarHeight 40.0f

#define kPlayBtnWidth 20.0f
#define kPlayBtnHeight 20.0f

#define kPauseBtnWidth 20.0f
#define kPauseBtnHeight 20.0f

#define kMaxBtnWidth 20.0f
#define kMaxBtnHeight 20.0f

#define kMinBtnWidth 20.0f
#define kMinBtnHeight 20.0f

#define kBackBtnWidth 20.0f
#define kBackBtnHeight 20.0f

#define kLeftMagin 0.0f
#define kRightMagin 3.0f
#define kMiddleMagin 5.0f

@interface JRPlayerControlView ()

//下面控制条
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UILabel *playedTimeLabel;
@property (nonatomic, strong) MyPlayProgressView *slider;
@property (nonatomic, strong) UILabel *allTimeLabel;

@property (nonatomic, strong) UIButton *maxBtn;
@property (nonatomic, strong) UIButton *minBtn;

//上面控制条
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation JRPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        //添加下面控制条
        [self addBottomView];

        //添加上面控制条
        [self addTopView];
    }
    return self;
}

//添加上面控制条
-(void)addTopView{
    _topView = [UIView new];
    [self addSubview:_topView];
    _topView.backgroundColor = UIColor.cyanColor;
    
    //添加返回按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"JRBackBtn"];
    [_backBtn setImage:backBtnImage forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_backBtn];
}

//添加下面控制条
-(void)addBottomView{
    _bottomView = [UIView new];
    [self addSubview:_bottomView];
    _bottomView.backgroundColor = UIColor.blackColor;
    
    //添加播放、暂停按钮
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *playBtnImage = [UIImage imageNamed:@"JRPlayBtn"];
    [_playBtn setImage:playBtnImage forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_playBtn];
    
    _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _pauseBtn.hidden = YES;
    UIImage *pauseBtnImage = [UIImage imageNamed:@"JRPauseBtn"];
    [_pauseBtn setImage:pauseBtnImage forState:UIControlStateNormal];
    [_pauseBtn addTarget:self action:@selector(pauseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_pauseBtn];
    
    //添加已播放时间标签
    _playedTimeLabel = [UILabel new];
    _playedTimeLabel.text = @"00:00";
    _playedTimeLabel.textColor = UIColor.whiteColor;
    _playedTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_playedTimeLabel];
    
    //添加slider
    _slider = [MyPlayProgressView new];
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 1.0;
    [_bottomView addSubview:_slider];
    
    //添加总播放时间标签
    _allTimeLabel = [UILabel new];
    _allTimeLabel.text = @"00:00";
    _allTimeLabel.textColor = UIColor.whiteColor;
    _allTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_allTimeLabel];
    
    //添加最大、最小按钮
    _maxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *maxBtnImage = [UIImage imageNamed:@"JRMaxBtn"];
    [_maxBtn setImage:maxBtnImage forState:UIControlStateNormal];
    [_maxBtn addTarget:self action:@selector(maxBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_maxBtn];
    
    _minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _minBtn.hidden = YES;
    UIImage *minBtnImage = [UIImage imageNamed:@"JRMinBtn"];
    [_minBtn setImage:minBtnImage forState:UIControlStateNormal];
    [_minBtn addTarget:self action:@selector(minBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_minBtn];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //设置下面控制条位置
    [self setBottomViewFrame];
    
    //设置上面控制条位置
    [self setTopViewFrame];
}

//设置下面控制条位置
-(void)setBottomViewFrame{
    _bottomView.frame = CGRectMake(0, self.bounds.size.height - kControlBarHeight, self.bounds.size.width, kControlBarHeight);
    
    _playBtn.frame = CGRectMake(kLeftMagin,
                                (_bottomView.bounds.size.height - kPlayBtnHeight) / 2.0,
                                kPlayBtnWidth,
                                kPlayBtnHeight);
    
    _pauseBtn.frame = CGRectMake(kLeftMagin,
                                (_bottomView.bounds.size.height - kPauseBtnHeight) / 2.0,
                                kPauseBtnWidth,
                                kPauseBtnHeight);
    
    [_playedTimeLabel sizeToFit];
    _playedTimeLabel.frame = CGRectMake(_playBtn.frame.origin.x + _playBtn.frame.size.width + kMiddleMagin,
                                        (_bottomView.bounds.size.height - _playedTimeLabel.bounds.size.height) / 2.0,
                                        _playedTimeLabel.bounds.size.width,
                                        _playedTimeLabel.bounds.size.height);
    
    _maxBtn.frame = CGRectMake(_bottomView.bounds.size.width - kMaxBtnWidth - kRightMagin,
                               (_bottomView.bounds.size.height - kMaxBtnHeight) / 2.0,
                               kMaxBtnWidth,
                               kMaxBtnHeight);
    
    _minBtn.frame = CGRectMake(_bottomView.bounds.size.width - kMinBtnWidth - kRightMagin,
                               (_bottomView.bounds.size.height - kMinBtnHeight) / 2.0,
                               kMinBtnWidth,
                               kMinBtnHeight);
    
    [_allTimeLabel sizeToFit];
    _allTimeLabel.frame = CGRectMake(_bottomView.bounds.size.width - kRightMagin - _maxBtn.bounds.size.width - kMiddleMagin - _allTimeLabel.bounds.size.width,
                                     (_bottomView.bounds.size.height - _allTimeLabel.bounds.size.height) / 2.0,
                                     _allTimeLabel.bounds.size.width,
                                    _allTimeLabel.bounds.size.height);
    
    _slider.frame = CGRectMake(_playedTimeLabel.frame.origin.x + _playedTimeLabel.frame.size.width + kMiddleMagin,
                               0,
                               _allTimeLabel.frame.origin.x - kMiddleMagin - (_playedTimeLabel.frame.origin.x + _playedTimeLabel.frame.size.width + kMiddleMagin),
                                _bottomView.bounds.size.height);
    
}

//设置上面控制条位置
-(void)setTopViewFrame{
    _topView.frame = CGRectMake(0, 0, self.bounds.size.width, kControlBarHeight);
    
    _backBtn.frame = CGRectMake(kLeftMagin + 10,
                                (_topView.bounds.size.height - kBackBtnHeight) / 2.0,
                                kBackBtnWidth,
                                kBackBtnHeight);
}

-(void)periodicTimeObserverForInterval:(CGFloat) value{
    self.slider.value = value;
}

//MARK: 按钮响应函数
-(void)playBtnClicked:(id)sender{
    _playBtn.hidden = YES;
    _pauseBtn.hidden = NO;
    
    if (_playBtnClicked) {
        _playBtnClicked();
    }
}

-(void)pauseBtnClicked:(id)sender{
    _playBtn.hidden = NO;
    _pauseBtn.hidden = YES;
    
    if (_pauseBtnClicked) {
        _pauseBtnClicked();
    }
}

-(void)maxBtnClicked:(id)sender{
    _maxBtn.hidden = YES;
    _minBtn.hidden = NO;
    
    if (_maxBtnClicked) {
        _maxBtnClicked();
    }
}

-(void)minBtnClicked:(id)sender{
    _maxBtn.hidden = NO;
    _minBtn.hidden = YES;
    
    if (_minBtnClicked) {
        _minBtnClicked();
    }
}

-(void)backBtnClicked:(id)sender{
    if (_backBtnClicked) {
        _backBtnClicked();
        
        if (_minBtnClicked) {
            _minBtnClicked();
        }
    }
}

@end
