//
//  YDHomeCell.m
//  YDImageBrowser
//
//  Created by Think on 2021/2/23.
//  Copyright © 2020年 YD. All rights reserved.
//

#import "YDHomeCell.h"

@interface YDHomeCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YDHomeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    imageManagerClass = NSClassFromString(@"YDSDWebImageManager");
    if (!imageManagerClass) {
        imageManagerClass = NSClassFromString(@"YDYYWebImageManager");
    }
    if (imageManagerClass) {
        self.imageProtocol = [imageManagerClass new];
    }
}

- (void)updateImage:(UIImage *)image;
{
    _imageView.image = image;
}

- (void)updateImageURL:(NSString *)URLString
{
    [self.imageProtocol yd_setImageWithImageView:_imageView imageURL:[NSURL URLWithString:URLString] placeholder:nil progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completion:^(UIImage * _Nullable image, NSURL * _Nullable url, BOOL finished, NSError * _Nullable error) {
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
}

@end
