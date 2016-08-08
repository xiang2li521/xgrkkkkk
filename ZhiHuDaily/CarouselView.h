//
//  CarouselView.h
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/2/24.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapBlock)(NSIndexPath *);

@interface CarouselView : UIView

@property (strong,nonatomic)NSArray *items;
@property (strong,nonatomic)UICollectionView *cv;
@property (strong,nonatomic)tapBlock tap;

- (instancetype)initWithFrame:(CGRect)frame itemViewModels:(NSArray *)itemvs;
- (void)updateSubViewsContentWithItems:(NSArray *)itemvms;
- (void)updateSubViewsPosition:(CGFloat)offset;

@end
