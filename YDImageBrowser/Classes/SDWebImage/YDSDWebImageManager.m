//
//  YDSDWebImageManager.m
//  KYPhotoBrowser
//
//  Created by Think on 2021/2/24.
//  Copyright © 2021 YD. All rights reserved.
//

#import "YDSDWebImageManager.h"

#if __has_include(<SDWebImage/SDImageCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDAnimatedImageView.h>
#import <SDWebImage/UIImage+GIF.h>
#else
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"
#import "SDAnimatedImageView.h"
#endif

@implementation YDSDWebImageManager

- (Class _Nonnull)imageViewClass {
    return SDAnimatedImageView.class;
}

- (void)yd_setImageWithImageView:(UIImageView * _Nonnull)imageView imageURL:(NSURL * _Nonnull)imageURL placeholder:(UIImage * _Nullable)placeholder progress:(YDWebImageProgressBlock _Nullable)progress completion:(YDWebImageCompletionBlock _Nullable)completion {
    
    [imageView sd_setImageWithURL:imageURL placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        !progress ? : progress(receivedSize, expectedSize);
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        !completion ? : completion(image, imageURL, !error, error);
    }];
}

- (void)cancelImageRequestWithImageView:(UIImageView * _Nonnull)imageView {
    [imageView sd_cancelCurrentImageLoad];
}

- (UIImage * _Nonnull)imageMemoryWithURL:(NSURL * _Nonnull)url {
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    return [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
}

- (void)clearMemory {
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
