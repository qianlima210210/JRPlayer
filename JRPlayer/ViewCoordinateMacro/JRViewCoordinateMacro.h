//
//  JRViewCoordinateMacro.h
//  JingRuiOnlineSchool
//
//  Created by maqianli on 2018/9/13.
//  Copyright © 2018年 onesmart. All rights reserved.
//

#import <UIKit/UIKit.h>

//MARK: 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

//MARK: 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//MARK: 屏幕Bounds
#define kScreenBounds [UIScreen mainScreen].bounds

//MARK: 状态栏高度（20.f, iPhoneX下44.f）
#define kStatusBarHeight UIApplication.sharedApplication.statusBarFrame.size.height

//MARK: 判断是否4.7 英寸
#define IsFourSevenInch (kScreenWidth * kScreenHeight == 375.0 * 667.0)

//MARK: 判断是否5.5英寸
#define IsFiveFiveInch (kScreenWidth * kScreenHeight == 414.0 * 736.0)

//MARK: 判断是否5.8英寸（iphone X）
#define IsFiveEightInch (kScreenWidth * kScreenHeight == (375.0 * 812.0))

//MARK: tabBar的高度（iPhoneX下为83）
extern CGFloat tabBarHeight(void);

//MARK: 导航栏高度
extern CGFloat navigationBarHeight(void);

//MARK: iPhoneX下，底部安全区域高度
extern CGFloat bottomSafeAreaHeight(void);

//MARK: 相对于iPhone6(375 * 667)的比例--iPhone 6，也是目前psd设计图尺寸，比例一般用于图片的等比拉伸
extern CGFloat viewScaleX_375(void);

//MARK:同上
extern CGFloat viewScaleY_667(void);








