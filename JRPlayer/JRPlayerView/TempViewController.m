//
//  TempViewController.m
//  JRPlayer
//
//  Created by maqianli on 2018/9/20.
//  Copyright © 2018年 onesmart. All rights reserved.
//

#import "TempViewController.h"

@interface TempViewController ()

@end

@implementation TempViewController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationNone;
}



@end
