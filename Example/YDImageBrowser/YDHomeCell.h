//
//  YDHomeCell.h
//  YDImageBrowser
//
//  Created by Think on 2020/8/2.
//  Copyright © 2020年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDHomeCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
- (void)updateImage:(UIImage *)image;
- (void)updateImageURL:(NSString *)URLString;

@end
