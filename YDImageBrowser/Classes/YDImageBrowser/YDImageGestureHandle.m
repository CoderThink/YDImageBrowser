//
//  YDImageGestureHandle.m
//  YDImageBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2020年 YD. All rights reserved.
//

#import "YDImageGestureHandle.h"
#import "YDImageZoomView.h"

@interface YDImageGestureHandle () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScrollView    *scrollView;
@property (nonatomic, weak) UIView          *coverView;
@property (nonatomic, assign) BOOL          isPull;
@property (nonatomic, assign) CGFloat       normalScale;
@property (nonatomic, assign) CGPoint       transitionImgViewCenter;

@end

@implementation YDImageGestureHandle

- (instancetype)initWithScrollView:(UIScrollView *)scrollView coverView:(UIView *)coverView
{
    if (self = [super init]) {
        _coverView = coverView;
        _scrollView = scrollView;
        [self addGesture];
    }
    return self;
}

- (void)addGesture
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizerAction:)];
    panRecognizer.delegate = self;
    [self.scrollView addGestureRecognizer:panRecognizer];
}

// 让 scrollView 能够 同时 相应 上下拖动 和 作用滑动 两种手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)panRecognizerAction:(UIPanGestureRecognizer *)panGesture{
    
    if (![self.delegate respondsToSelector:@selector(currentImageView:)]) {
        return;
    }
    YDImageZoomView *zoomView = [self.delegate currentImageView:self];
    UIImageView *photoImageView = zoomView.imageView;
    
    if(!_isPull) {
        return;//横向拖动
    }else {
        _scrollView.scrollEnabled = NO;
        panGesture.enabled = YES;
    }

    CGFloat scrH = [UIScreen mainScreen].bounds.size.height;
    // 手指在视图上移动的位置(x,y)向下和右为正，向上和左为负
    CGPoint translation = [panGesture translationInView:panGesture.view];
    
    CGFloat scale = 1 - fabs(translation.y / scrH);
    scale = scale < 0 ? 0 : scale;
    UIView *window = _coverView;
    switch (panGesture.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan: {
            
            self.normalScale = zoomView.zoomScale;
            // 手指在视图上的位置(x,y)
            CGPoint touchPoint = [panGesture locationInView:photoImageView];
            touchPoint = CGPointMake(touchPoint.x + zoomView.contentOffset.x, touchPoint.y+zoomView.contentOffset.y);
            // 改变锚点
            [[self class] setupViewAnchorPoint:photoImageView anchorPoint:touchPoint];
            
            self.transitionImgViewCenter = photoImageView.center;
            
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            if (translation.y < 0) {
                scale = self.normalScale;
                
                photoImageView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x, self.transitionImgViewCenter.y + translation.y);
                photoImageView.transform = CGAffineTransformMakeScale(scale, scale);
                window.alpha = 1;
                return;
            }
            
            photoImageView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x, self.transitionImgViewCenter.y + translation.y + zoomView.contentOffset.y);
            window.alpha = scale*scale;
            
            CGFloat photoScale = scale * self.normalScale;
            photoImageView.transform = CGAffineTransformMakeScale(photoScale, photoScale);
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            _scrollView.scrollEnabled = YES;
            _isPull = NO;
            // 手指在视图上移动的速度(x,y)
            CGPoint velocity = [panGesture velocityInView:panGesture.view];
            if ((scale < 0.80 && translation.y > 0) || velocity.y > 800) {// 比例大于0.80，或者下拉速度大于800，退出界面
                
                [[self class] setupViewAnchorPoint:photoImageView anchorPoint:CGPointMake(0.5, 0.5)];
                CGRect frame = photoImageView.frame;
                frame.origin.x -= zoomView.contentOffset.x;
                frame.origin.y -= zoomView.contentOffset.y;
                
                photoImageView.frame = frame;
                
                if ([self.delegate respondsToSelector:@selector(imageViewDismiss)]) {
                    [self.delegate imageViewDismiss];
                }
            }
            else {
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    photoImageView.center = self.transitionImgViewCenter;
                    photoImageView.transform = CGAffineTransformMakeScale(1, 1);
                    window.alpha = 1;
                } completion:^(BOOL finished) {
                    
                    [[self class] setupViewAnchorPoint:photoImageView anchorPoint:CGPointMake(0.5, 0.5)];
                    photoImageView.transform = CGAffineTransformIdentity;
        
                }];
            }
        }
    }
}

+ (void)setupViewAnchorPoint:(UIView *)view anchorPoint:(CGPoint)anchorPoint
{
    CGPoint oldOrigin = view.frame.origin;
    CGFloat anchorPointX = isinf(anchorPoint.x/view.frame.size.width)?:anchorPoint.x/view.frame.size.width;
    CGFloat anchorPointY = isinf(anchorPoint.y/view.frame.size.height)?:anchorPoint.y/view.frame.size.height;
    view.layer.anchorPoint = CGPointMake(anchorPointX, anchorPointY);
    CGPoint newOrigin = view.frame.origin;

    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    view.center = CGPointMake(view.center.x-transition.x, view.center.y-transition.y);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        UIPanGestureRecognizer * recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        if (![self.delegate respondsToSelector:@selector(currentImageView:)]) {
            return YES;
        }
        YDImageZoomView *zoomView = [self.delegate currentImageView:self];
        
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        CGFloat translation_x = [recognizer translationInView:_coverView.superview].x;
        CGFloat translation_y = [recognizer translationInView:_coverView.superview].y;
        CGPoint contentOffset = zoomView.contentOffset;
        
        if (contentOffset.y > 0) {// 图片放大没有滑到顶部时，不响应此手势
            return NO;
        }
        if (velocity.y <= 0) {// 向上滑动，不响应此手势
            return NO;
        }
        if(fabs(translation_x) >= fabs(translation_y)) {
            _isPull = NO;
        }
        else {
            _isPull = YES;
        }
        return YES;
    }
    return YES;
}

@end
