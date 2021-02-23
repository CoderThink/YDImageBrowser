//
//  YDHomeCell.m
//  YDImageBrowser
//
//  Created by Think on 2021/2/23.
//  Copyright © 2020年 YD. All rights reserved.
//

#import "YDHomeCell.h"
#import <YYWebImage.h>

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
}

- (void)updateImage:(UIImage *)image;
{
    _imageView.image = image;
}

- (void)updateImageURL:(NSString *)URLString
{
    [_imageView yy_setImageWithURL:[NSURL URLWithString:URLString] options:kNilOptions];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
}

@end
