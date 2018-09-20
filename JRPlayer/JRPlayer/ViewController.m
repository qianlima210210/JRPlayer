//
//  ViewController.m
//  JRPlayer
//
//  Created by maqianli on 2018/9/19.
//  Copyright © 2018年 onesmart. All rights reserved.
//

#import "ViewController.h"
#import "JRPlayerView.h"
#import "JRViewCoordinateMacro.h"

@import Masonry;
@import AFNetworking;

@interface ViewController ()

@property (nonatomic, strong) JRPlayerView *playerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"http://ohjdda8lm.bkt.clouddn.com/course/sample1.mp4"];
    JRPlayerView * playerView = [JRPlayerView playerViewWithURL:url];
    [self.view addSubview:playerView];
    _playerView = playerView;
    
    [_playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0.0);
        make.top.equalTo(self.view.mas_top).offset(0.0);
        make.width.equalTo(self.view.mas_width).offset(0.0);
        make.height.equalTo(self.view.mas_height).multipliedBy(1.0 / 3.0);
    }];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationNone;
}


@end
