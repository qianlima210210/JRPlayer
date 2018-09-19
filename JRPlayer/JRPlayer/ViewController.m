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
    
    NSURL *url = [NSURL URLWithString:@"http://vjs.zencdn.net/v/oceans.mp4"];
    JRPlayerView * playerView = [JRPlayerView playerViewWithURL:url];
    [self.view addSubview:playerView];
    _playerView = playerView;
    
    [self viewWillTransitionToSize:UIScreen.mainScreen.bounds.size withTransitionCoordinator:self.transitionCoordinator];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if (size.width > size.height) {
        _playerView.frame = CGRectMake(0, 0, size.width, size.height);
    }else{
       _playerView.frame = CGRectMake(0, kStatusBarHeight, size.width, size.height / 2.0);
    }
}

@end
