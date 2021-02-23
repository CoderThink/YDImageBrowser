//
//  YDImageGestureHandle.h
//  YDImageBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2020年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YDImageZoomView, YDImageGestureHandle;

@protocol YDImageGestureHandleDelegate <NSObject>

// 获取当前图片对象
- (YDImageZoomView *)currentImageView:(YDImageGestureHandle *)handle;

// 图片消失
- (void)imageViewDismiss;


@end

@interface YDImageGestureHandle : NSObject

@property (nonatomic, weak) id <YDImageGestureHandleDelegate> delegate;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView coverView:(UIView *)coverView;

@end
