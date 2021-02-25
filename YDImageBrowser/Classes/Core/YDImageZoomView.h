//
//  YDImageZoomView.h
//  YDImageBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2020年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDImageModel.h"
#import "YDWebImageProtocol.h"

static Class imageManagerClass = nil;

typedef NS_ENUM(NSInteger, YDShowImageState) {
    YDShowImageStateSmall,    // 初始化默认是小图
    YDShowImageStateBig,      // 全屏的正常图片
    YDShowImageStateOrigin    // 原图
};

@class YDImageZoomView;
@protocol YDImageZoomViewDelegate <NSObject>

- (CGRect)dismissRect;

- (UIImage *)imageZoomViewPlaceholderImage;

- (void)dismiss;

@end

@interface YDImageZoomView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id <YDImageZoomViewDelegate> zoomDelegate;
@property (nonatomic, strong) id<YDWebImageProtocol> imageProtocol;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, assign) YDShowImageState imageState;
@property (nonatomic, assign) CGFloat process;

- (void)resetScale;

- (void)showImageWithPhotoModel:(YDImageModel *)photoModel;

- (void)dismissAnimation:(BOOL)animation;

@end
