//
//  TopStoryCell.h
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/2/24.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoverView.h"

@interface TopStoryCell : UICollectionViewCell

@property (strong,nonatomic)UIImageView *imageView;
@property (strong,nonatomic)UILabel *titleLab;
@property (strong,nonatomic)CoverView *cover;

@end
