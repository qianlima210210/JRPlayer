//
//  JRPlayerControlView.h
//  JRPlayer
//
//  Created by maqianli on 2018/9/19.
//  Copyright © 2018年 onesmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRPlayerControlView : UIView

@property (nonatomic, copy) void (^playBtnClicked)(void);
@property (nonatomic, copy) void (^pauseBtnClicked)(void);
@property (nonatomic, copy) void (^maxBtnClicked)(void);
@property (nonatomic, copy) void (^minBtnClicked)(void);
@property (nonatomic, copy) void (^backBtnClicked)(void);

-(void)periodicTimeObserverForInterval:(CGFloat) value;

@end
