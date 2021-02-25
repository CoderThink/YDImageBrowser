//
//  YDWebImageProtocol.h
//  KYPhotoBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2020 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YDWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void(^YDWebImageCompletionBlock)(UIImage * _Nullable image,NSURL * _Nullable url,BOOL finished,NSError * _Nullable error);

@protocol YDWebImageProtocol <NSObject>

/** 设置imageView 类*/
- (Class _Nonnull)imageViewClass;

/**
 设置图片
 
 @param imageView imageView
 @param imageURL url
 @param progress 加载进度
 @param completion 完成回调
 */
- (void)yd_setImageWithImageView:(UIImageView *_Nonnull)imageView
                        imageURL:(NSURL *_Nonnull)imageURL
                     placeholder:(UIImage *_Nullable)placeholder
                        progress:(YDWebImageProgressBlock _Nullable )progress
                      completion:(YDWebImageCompletionBlock _Nullable )completion;

/**
 取消imageView请求
 
 @param imageView imageView
 */
- (void)cancelImageRequestWithImageView:(UIImageView *_Nonnull)imageView;
      
/**
 从内存中获取图片
 @param url url
 */
- (UIImage *_Nonnull)imageMemoryWithURL:(NSURL *_Nonnull)url;

@optional

/** 清理内存 */
- (void)clearMemory;

@end

                    


//[_imageView yy_setImageWithURL:[NSURL URLWithString:_photoModel.originUrl]
//                   placeholder:placeholderImage
//                       options:kNilOptions
//                      progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//}transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//    [self.activityIndicator stopAnimating];
//    self.originButton.hidden = YES;
//}];


