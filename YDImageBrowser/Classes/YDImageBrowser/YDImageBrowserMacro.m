//
//  YDImageBrowserMacro.m
//  YDImageBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2021 YD. All rights reserved.
//

#import "YDImageBrowserMacro.h"

@implementation YDImageBrowserMacro

BOOL YDIsIPhoneXSeries(void) {
    return YDStatusbarHeight() > 20;
}

CGFloat YDStatusbarHeight(void) {
    CGFloat height = 0;
    if (@available(iOS 11.0, *)) {
        height = UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
    }
    if (height <= 0) {
        height = UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    if (height <= 0) {
        height = 20;
    }
    return height;
}

CGFloat YDSafeAreaBottomHeight(void) {
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom;
    }
    return bottom;
}

@end
