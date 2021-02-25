//
//  YDImageBrowserController.m
//  YDImageBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2020年 YD. All rights reserved.
//

#import "YDImageBrowserController.h"
#import "YDImageBrowserMacro.h"
#import "YDImageZoomView.h"
#import "YDImageGestureHandle.h"

@interface YDImageBrowserController () <UIScrollViewDelegate, YDImageZoomViewDelegate, YDImageGestureHandleDelegate>

@property (nonatomic, strong) UIScrollView              *photoScrollView;
@property (nonatomic, strong) UIView                    *coverView;
@property (nonatomic, strong) NSMutableDictionary       *zoomViewCache;
@property (nonatomic, strong) YDImageGestureHandle      *gestureHandle;

@end

@implementation YDImageBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    [self setupGestureHandle];
    [self setupScrollView];
    [self loadImageAtIndex:_currentIndex];
    [self showImage];

}

- (void)initView
{
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.photoScrollView];
    [self.view addSubview:self.pageLabel];
    [self.view addSubview:self.pageControl];
}

- (void)setupGestureHandle
{
    _gestureHandle = [[YDImageGestureHandle alloc] initWithScrollView:_photoScrollView coverView:_coverView];
    _gestureHandle.delegate = self;
}

// 设置scrollView
- (void)setupScrollView
{
    if (_currentIndex < 0 || _currentIndex >= _images.count) {
        return;
    }
    
    CGFloat scrollW = _photoScrollView.frame.size.width;
    _photoScrollView.contentSize = CGSizeMake(scrollW * _images.count, _photoScrollView.frame.size.height);
    _photoScrollView.contentOffset = CGPointMake(scrollW * _currentIndex, 0);
    
}

// 加载图片
- (void)loadImageAtIndex:(NSInteger)index
{
    // 改变指示标记
    [self.pageLabel setText:[NSString stringWithFormat:@"%ld/%ld", index + 1, (long)self.images.count]];
    self.pageControl.currentPage = index;
    
    CGFloat scrollW = _photoScrollView.frame.size.width;
    for (NSInteger i = index - 1; i <= index + 1; i++) {
        if (i < 0 || i >= self.images.count) continue;
        YDImageModel *photoModel = _images[i];
        YDImageZoomView *zoomView = self.zoomViewCache[@(i)];
        if (!zoomView) {
            CGRect frame = CGRectMake(i * scrollW, 0, scrollW, _photoScrollView.frame.size.height);
            zoomView = [[YDImageZoomView alloc] initWithFrame:frame];
            zoomView.zoomDelegate = self;
            zoomView.frame = frame;
            [_photoScrollView addSubview:zoomView];
            [self.zoomViewCache setObject:zoomView forKey:@(i)];
        }
        [zoomView showImageWithPhotoModel:photoModel];
    }
}

// 点击进入动画效果
- (void)showImage
{
    CGRect startRect;
    YDImageModel *currentPhotoModel = self.images[self.currentIndex];
    UIImageView *imageView = currentPhotoModel.sourceImageView;
    if (!imageView) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.coverView.alpha = 1;
        }];
        return;
    }
    
    startRect = [imageView.superview convertRect:imageView.frame toView:self.view];
    UIImage *image = imageView.image;
    if (!image) {
        return;
    }
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = image;
    tempImageView.frame = startRect;
    [self.view addSubview:tempImageView];
    
    // 目标frame
    CGRect targetRect;
    CGFloat imageWidthHeightRatio = image.size.width / image.size.height;
    CGFloat width = KScreenW;
    CGFloat scrH = KScreenH;
    CGFloat height = width / imageWidthHeightRatio;
    CGFloat x = 0;
    CGFloat y;
    if (height > scrH) {
        y = 0;
    }else {
        y = (scrH - height ) * 0.5;
    }
    targetRect = CGRectMake(x, y, width, height);
    
    self.photoScrollView.hidden = YES;
    self.view.alpha = 1.f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            tempImageView.frame = targetRect;
            self.coverView.alpha = 1;
        } completion:^(BOOL finished) {
            [tempImageView removeFromSuperview];
            self.photoScrollView.hidden = NO;
        }];
        
    });
    
}

#pragma mark - API

- (void)showFromVC:(UIViewController *)vc {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalTransitionStyle   = UIModalTransitionStyleCoverVertical;
    [vc presentViewController:self animated:NO completion:nil];
}

- (void)dismissAnimation:(BOOL)animation
{
    YDImageZoomView *zoomView = _zoomViewCache[@(_currentIndex)];
    [zoomView dismissAnimation:animation];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    if (_currentIndex != page) {
        _currentIndex = page;
        [self loadImageAtIndex:_currentIndex];
    }
}

#pragma mark - YDImageGestureHandleDelegate
- (YDImageZoomView *)currentImageView:(YDImageGestureHandle *)handle
{
    YDImageZoomView *zoomView = _zoomViewCache[@(_currentIndex)];
    return zoomView;
}

- (void)imageViewDismiss
{
    YDImageZoomView *zoomView = _zoomViewCache[@(_currentIndex)];
    [zoomView dismissAnimation:YES];
}

#pragma mark - YDImageZoomViewDelegate
- (CGRect)dismissRect
{
    
    YDImageModel *currentPhotoModel = self.images[self.currentIndex];
    UIImageView *imageView = currentPhotoModel.sourceImageView;
    if (!imageView) {
        return CGRectZero;
    }

    return [imageView.superview convertRect:imageView.frame toView:self.view];;
}

- (UIImage *)imageZoomViewPlaceholderImage
{
    if ([self.delegate respondsToSelector:@selector(imageBrowserPlaceholderImage)]) {
        UIImage *image = [self.delegate imageBrowserPlaceholderImage];
        return image;
    }
    return nil;
}

- (void)dismiss {
    
    [UIView animateWithDuration:kDismissAnimationDuration animations:^{
        self.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];

}

#pragma mark - setter/getter

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0;
    }
    return _coverView;
}

- (UIScrollView *)photoScrollView {
    if (!_photoScrollView) {
        CGRect frame = self.view.bounds;
        frame.origin.x   -= kImageViewPadding;
        frame.size.width += kImageViewPadding * 2;
        _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _photoScrollView.delegate = self;
        _photoScrollView.showsHorizontalScrollIndicator = NO;
        _photoScrollView.showsVerticalScrollIndicator = NO;
        _photoScrollView.pagingEnabled = YES;
        _photoScrollView.backgroundColor = [UIColor clearColor];
    }
    return _photoScrollView;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KScreenH - 30 - YDSafeAreaBottomHeight(), KScreenW, 30)];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont systemFontOfSize:16.0f];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.hidden = YES;
    }
    return _pageLabel;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, KScreenH - 30 - YDSafeAreaBottomHeight(), KScreenW, 30)];
        _pageControl.numberOfPages = self.images.count;
        _pageControl.currentPage = self.currentIndex;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.enabled = NO;
    }
    return _pageControl;;
}

- (NSMutableDictionary *)zoomViewCache
{
    if (!_zoomViewCache) {
        _zoomViewCache = [NSMutableDictionary dictionary];
    }
    return _zoomViewCache;
}

@end
