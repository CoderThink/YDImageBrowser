//
//  YDImageBrowserController.h
//  YDImageBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2020年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDImageModel.h"
@class YDImageBrowserController;

@protocol YDImageBrowserControllerDelegate <NSObject>

@optional

// 图片占位图
- (UIImage *)imageBrowserPlaceholderImage;

@end

@interface YDImageBrowserController : UIViewController

/** 代理 */
@property (nonatomic, weak) id <YDImageBrowserControllerDelegate> delegate;

/** 当前显示的photoView */
@property (nonatomic, strong, readonly) UIScrollView              *photoScrollView;

/** 数量  */
@property (nonatomic, strong) UILabel  *pageLabel;

/** 页码 */
@property (nonatomic, strong) UIPageControl *pageControl;

/** 当前索引 */
@property (nonatomic, assign) NSInteger currentIndex;

/** 图片模型数组 */
@property (nonatomic, strong) NSArray *images;

/**
 显示图片浏览器
 
 @param vc 控制器
 */
- (void)showFromVC:(UIViewController *)vc;

/**
 隐藏图片浏览器
 */
- (void)dismissAnimation:(BOOL)animation;

@end
