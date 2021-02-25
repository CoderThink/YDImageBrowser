//
//  YDImageModel.h
//  YDImageBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2020年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDImageModel : NSObject

/** 图片数据 */
@property (nonatomic, strong) UIImage       *image;

/** 图片地址 */
@property (nonatomic, strong) NSString      *url;

/** 原图地址 */
@property (nonatomic, strong) NSString      *originUrl;

/** 来源imageView */
@property (nonatomic, strong) UIImageView   *sourceImageView;

/** 原图大小，单位为 B*/
@property (nonatomic, assign) CGFloat       originImageSize;

/** 记录photoView是否缩放 */
@property (nonatomic, assign) BOOL          isZooming;

/** 记录photoView缩放时的rect */
@property (nonatomic, assign) CGRect        zoomRect;

@end
