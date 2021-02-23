//
//  YDViewController.m
//  YDImageBrowser
//
//  Created by Think on 2021/2/23.
//  Copyright (c) 2021 YD. All rights reserved.
//

#import "YDViewController.h"
#import "YDImageBrowserController.h"
#import "YDHomeCell.h"

@interface YDViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, YDImageBrowserControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation YDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self initView];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat scr_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat scr_h = [UIScreen mainScreen].bounds.size.height;
    CGRect frame = CGRectMake(0, 0, scr_w, scr_h);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [_collectionView registerClass:[YDHomeCell class] forCellWithReuseIdentifier:@"YDHomeCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    YDHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDHomeCell" forIndexPath:indexPath];
    NSObject *obj = _imageArray[indexPath.item];
    if ([obj isKindOfClass:[UIImage class]]) {
        [cell updateImage:(UIImage *)obj];
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        [cell updateImageURL:(NSString *)obj];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width/3-15;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i< self.imageArray.count; i++) {
        YDImageModel *model = [[YDImageModel alloc] init];
        model.url = self.imageArray[i];
        
        YDHomeCell *cell = (YDHomeCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        model.sourceImageView = cell.imageView;
        [imageArray addObject:model];
    }
    
    YDImageBrowserController *vc = [[YDImageBrowserController alloc] init];
    vc.images = imageArray;
    vc.currentIndex = indexPath.item;
    vc.delegate = self;
    [vc showFromVC:self];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        NSArray *images = @[@"http://ww4.sinaimg.cn/bmiddle/677febf5gw1erma1g5xd0j20k0esa7wj.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=550206595,4113627805&fm=11&gp=0.jpg", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwx4.sinaimg.cn%2Flarge%2F007d2BQ6ly4gm743pbrubj30jn0jnjru.jpg&refer=http%3A%2F%2Fwx4.sinaimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614315620&t=5696c4010e2419b440d4a306a0d32105", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fww3.sinaimg.cn%2Fmw690%2F00222i3dly1gmk0bi24nwj60dw0dwjxl02.jpg&refer=http%3A%2F%2Fwww.sina.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614315620&t=277ad29a43fb4f01f4fa53ffbb328a05", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwx1.sinaimg.cn%2Fmw690%2F001q2GAPly1gml7hais8zj60i20hq76r02.jpg&refer=http%3A%2F%2Fwx1.sinaimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614315620&t=969d4cad46cb4fea248fe3feac28d1cf", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fwx3.sinaimg.cn%2Fmw690%2F00222i3dly1gmk0bilq5bj60dw0dwn0802.jpg&refer=http%3A%2F%2Fwx3.sinaimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614315620&t=eed09ab11073cfad4d87b0348a7a3a51", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2Ftx28%2F470114245410973.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1614315620&t=7ff6f381550a92f5715546c471673d30"];
        _imageArray = [NSMutableArray arrayWithArray:images];
    }
    return _imageArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
