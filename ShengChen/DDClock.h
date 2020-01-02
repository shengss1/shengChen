//
//  DDClock.h
//  Created by David on 15/1/26.
//  有问题可以联系我撒
//  博客：http://www.cnblogs.com/daiweilai/
//  QQ：1293420170
//  github：https://github.com/daiweilai/
//  Copyright (c) 2015年 DavidDay. All rights reserved.
// 

#import <UIKit/UIKit.h>
#define DDClockSize 200 //强制时钟的长宽都为200
#if ! __has_feature(objc_arc)
#error "需要开启ARC"
#endif

@interface DDClock : UIView

typedef NS_ENUM(NSUInteger, DDClockTheme) {
    DDClockThemeDefault = 0,
    DDClockThemeDark,
    DDClockThemeModerm
};
@property (nonatomic)NSTimer* timer;
@property (nonatomic)NSDate* currentTime;

///DDClock的构造方法 theme:主题 position:左上角所处的位置
-(instancetype)initWithTheme:(DDClockTheme)theme position:(CGPoint)position;

- (void)drawDDClockWithTime:(NSDate*)currentTime theme:(DDClockTheme)theme;
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
