//
//  JRPlayerView.h
//  精锐播放器
//
//  Created by maqianli on 2018/9/19.
//  Copyright © 2018年 onesmart. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NotificationOfHideStatusBar @"NotificationOfHideStatusBar"
#define NotificationOfShowStatusBar @"NotificationOfShowStatusBar"

@interface JRPlayerView : UIView

/**
 工厂方法：获取播放器视图

 @param url 视频资源地址
 @return 播放器视图
 */
+(instancetype)playerViewWithURL:(NSURL*)url;





@end
