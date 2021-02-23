//
//  YDImageZoomView.m
//  YDImageBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2020年 YD. All rights reserved.
//

#import "YDImageZoomView.h"
#import "YDImageBrowserMacro.h"

@interface YDImageZoomView ()

@property (nonatomic, strong) YDImageModel  *photoModel;
@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIButton      *originButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation YDImageZoomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initView];
        [self addGestures];
    }
    return self;
}

- (void)initView
{
    _imageState = YDShowImageStateSmall;
    self.directionalLockEnabled = YES;
    self.minimumZoomScale = 1.f;
    self.maximumZoomScale = 2.f;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    
    [self addSubview:self.imageView];
    [self addSubview:self.originButton];

    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)addGestures
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleClick:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [tap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:tap];
}

#pragma mark - 手势处理 && 事件处理
// 下载原图
- (void)downloadOriginImage
{
    UIImage *placeholderImage = nil;
    if ([self.zoomDelegate respondsToSelector:@selector(imageZoomViewPlaceholderImage)]) {
        placeholderImage = [self.zoomDelegate imageZoomViewPlaceholderImage];
    }
    [self.activityIndicator startAnimating];
    [_imageView yy_setImageWithURL:[NSURL URLWithString:_photoModel.originUrl]
                       placeholder:placeholderImage
                           options:kNilOptions
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    }transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        [self.activityIndicator stopAnimating];
        self.originButton.hidden = YES;
    }];
}

- (void)tapAction:(UIPanGestureRecognizer *)sender
{
    [self dismissAnimation:YES];
}

- (void)didDoubleClick:(UITapGestureRecognizer *)sender
{
    if (self.imageState > YDShowImageStateSmall) {
        if (self.zoomScale != 1.0) {// 还原
            
            [self setZoomScale:1.f animated:YES];
        } else {// 放大
            
            CGPoint touchPoint = [sender locationInView:sender.view];
            CGFloat newZoomScale = self.maximumZoomScale;
            CGFloat xsize = self.frame.size.width / newZoomScale;
            CGFloat ysize = self.frame.size.height / newZoomScale;
            CGRect zoomRect = CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize);
            [self zoomToRect:zoomRect animated:YES];
            
            self.photoModel.isZooming = YES;
            
        }
    }
}

#pragma mark - API
- (void)resetScale
{
    [self setZoomScale:1.f animated:NO];
}

- (void)showImageWithPhotoModel:(YDImageModel *)photoModel;
{
    _photoModel = photoModel;
    [self setupDownloadButton];
    UIImage *placeholderImage = nil;
    if ([self.zoomDelegate respondsToSelector:@selector(imageZoomViewPlaceholderImage)]) {
        placeholderImage = [self.zoomDelegate imageZoomViewPlaceholderImage];
    }
    
    if (!photoModel) {
        if ([self.zoomDelegate respondsToSelector:@selector(imageZoomViewPlaceholderImage)]) {
            _imageView.image = placeholderImage;
        }
        return;
    }
    
    BOOL hasOriginImageCache = [[YYImageCache sharedCache] containsImageForKey:photoModel.originUrl];
    // 1，检测原图
    if (photoModel.originUrl && hasOriginImageCache) {
        
        [_imageView yy_setImageWithURL:[NSURL URLWithString:photoModel.originUrl]
                           placeholder:placeholderImage
                               options:kNilOptions
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            self.process = (CGFloat)receivedSize/(CGFloat)expectedSize;
        }
                             transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            if (image) {
                [self becomeBigStateImage:self.imageView.image animation:YES];
                self.imageState = YDShowImageStateOrigin;
                self.originButton.hidden = YES;
            }
            else {// 处理大图加载失效情况
                
            }
        }];
    }else if (photoModel.url) { // 2，加载普通图片
        
        BOOL hasThumbImageCache = [[YYImageCache sharedCache] containsImageForKey:photoModel.url];
        if (!hasThumbImageCache) {
            [self.activityIndicator startAnimating];
        }
        [_imageView yy_setImageWithURL:[NSURL URLWithString:photoModel.url]
                           placeholder:placeholderImage
                               options:kNilOptions
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            [self.activityIndicator stopAnimating];
            if (image) {
                [self becomeBigStateImage:self.imageView.image animation:YES];
                self.imageState = YDShowImageStateBig;
            }
            else {// 处理普通图加载失败的情况
                
            }
        }];
    }else {
        _imageView.image = placeholderImage;
        [self becomeBigStateImage:_imageView.image animation:YES];
        _imageState = YDShowImageStateBig;
    }
    
}

#pragma mark - 辅助函数
// 设置 下载原图 按钮
- (void)setupDownloadButton
{
    if (_photoModel.originUrl) {
        _originButton.hidden = NO;
        NSString *title = [NSString stringWithFormat:@"  查看原图(%.1fM)  ", _photoModel.originImageSize/1024.0/1024.0];
        [_originButton setTitle:title forState:UIControlStateNormal];
        [_originButton sizeToFit];
        CGPoint center = _originButton.center;
        
        center.x = KScreenW * 0.5;
        _originButton.center = center;
        CGRect frame = _originButton.frame;
        frame.origin.y = KScreenH - 10 - frame.size.height;
        _originButton.frame = frame;
    }
    
    BOOL hasOriginImageCache = [[YYImageCache sharedCache] containsImageForKey:_photoModel.originUrl];
    
    // 图片有原图链接，并且本地有缓存，直接加载原图
    if (_photoModel.originUrl && hasOriginImageCache) {
        _originButton.hidden = NO;
    }else if (_photoModel.originUrl) { // 有原图，但是本地没有缓存，显示加载原图按钮
        _originButton.hidden = NO;
    }else {
        _originButton.hidden = YES;
    }
}

- (void)becomeBigStateImage:(UIImage *)image animation:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self setupImageView:image];
        }];
    }else {
        [self setupImageView:image];
    }
}

- (void)setupImageView:(UIImage *)image
{
    if (!image || self.photoModel.isZooming) {
        return;
    }
    
    CGFloat scrW = KScreenW;
    CGFloat scale = scrW / image.size.width;
    CGSize size = CGSizeMake(scrW, image.size.height * scale);
    CGFloat y = MAX(0., (self.frame.size.height - size.height) * 0.5);
    CGFloat x = MAX(0., (self.frame.size.width - size.width) * 0.5);
    [self.imageView setFrame:CGRectMake(x, y, size.width, size.height)];
    [self.imageView setImage:image];
    self.contentSize = CGSizeMake(self.bounds.size.width, size.height);
}

- (void)dismissAnimation:(BOOL)animation
{
    __block CGRect toFrame;
    if ([self.zoomDelegate respondsToSelector:@selector(dismissRect)]) {
        toFrame = [self.zoomDelegate dismissRect];
        if (CGRectEqualToRect(toFrame, CGRectZero) || CGRectEqualToRect(toFrame, CGRectNull)) {
            animation = NO;
        }
    }
    
    if (animation) {
        if (_imageView.image) {
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.imageView.frame = CGRectMake(toFrame.origin.x + kImageViewPadding, toFrame.origin.y, toFrame.size.width, toFrame.size.height);
            }];
        }
    }
    
    if ([self.zoomDelegate respondsToSelector:@selector(dismiss)]) {
        [self.zoomDelegate dismiss];
    }
    
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}

// 缩放小于1的时候，始终让其在中心点位置进行缩放
- (void)centerScrollViewContents
{
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) * 0.5;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) * 0.5;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

#pragma mark - lazy
- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat imageViewW = KScreenW - 2 * 60;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewW, imageViewW)];
        _imageView.center = CGPointMake(self.frame.size.width * 0.5 , self.frame.size.height * 0.5);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIButton *)originButton {
    if (!_originButton) {
        _originButton = [[UIButton alloc] init];
        [_originButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _originButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        _originButton.layer.masksToBounds = YES;
        _originButton.layer.borderWidth = 1.f;
        _originButton.layer.cornerRadius = 4.f;
        _originButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        _originButton.hidden = YES;
        [_originButton addTarget:self action:@selector(downloadOriginImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _originButton;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        [self addSubview:_activityIndicator];
        _activityIndicator.tintColor = [UIColor grayColor];
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}

@end
