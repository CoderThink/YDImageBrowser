//
//  YDYYWebImageManager.m
//  KYPhotoBrowser
//
//  Created by Think on 2021/2/24.
//  Copyright © 2021 YD. All rights reserved.
//

#import "YDYYWebImageManager.h"

#if __has_include(<YYWebImage/YYWebImage>)
#import <YYWebImage/YYWebImage.h>
#else
#import "YYWebImage.h"
#endif

@implementation YDYYWebImageManager

- (Class)imageViewClass {
    return YYAnimatedImageView.class;
}

- (void)yd_setImageWithImageView:(id)imageView imageURL:(NSURL *)imageURL placeholder:(id)placeholder progress:(YDWebImageProgressBlock)progress completion:(YDWebImageCompletionBlock)completion {

    [imageView yy_setImageWithURL:imageURL placeholder:placeholder options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        !progress ? : progress(receivedSize, expectedSize);
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        BOOL success = (stage == YYWebImageStageFinished);
        !completion ? : completion(image, url, success, error);
    }];
}

- (void)cancelImageRequestWithImageView:(UIImageView *)imageView {
    [imageView yy_cancelCurrentImageRequest];
}


- (UIImage *)imageMemoryWithURL:(NSURL *)url {
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.cache getImageForKey:key withType:YYImageCacheTypeAll];
    
}

- (void)clearMemory {
    [[YYImageCache sharedCache].memoryCache removeAllObjects];
}


@end
