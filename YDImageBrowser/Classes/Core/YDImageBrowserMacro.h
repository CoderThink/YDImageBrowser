//
//  YDImageBrowserMacro.h
//  YDImageBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2020 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// browser中显示图片动画时长
#define kAnimationDuration 0.3f
#define kDismissAnimationDuration 0.4f

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

// 默认图片间距
#define kImageViewPadding           10

@interface YDImageBrowserMacro : NSObject

/// 判断是否是刘海屏
BOOL YDIsIPhoneXSeries(void);

/// 状态栏高度
CGFloat YDStatusbarHeight(void);

/// 底部安全区域高度
CGFloat YDSafeAreaBottomHeight(void);

@end

NS_ASSUME_NONNULL_END
