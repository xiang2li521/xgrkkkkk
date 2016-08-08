//
//  TopStoryCell.m
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/2/24.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import "TopStoryCell.h"

@implementation TopStoryCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView = ({
            UIImageView *view = [UIImageView new];
            [self.contentView addSubview:view];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            
            view;
        });
        
        self.cover = ({
            CoverView *view = [CoverView new];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.and.top.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView).offset(-(kScreenWidth-220.f)/2);
            }];
            
            CAGradientLayer *grandient = (CAGradientLayer *)view.layer;
            grandient.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.60f].CGColor,
                                 (id)[[UIColor blackColor] colorWithAlphaComponent:0.30f].CGColor,
                                 (id)[[UIColor blackColor] colorWithAlphaComponent:0.0f].CGColor,
                                 (id)[[UIColor blackColor] colorWithAlphaComponent:0.25f].CGColor,
                                 (id)[[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor];
            grandient.locations = @[@0.0,@0.1,@0.25,@0.75,@0.9,@1.0];
            grandient.startPoint = CGPointMake(0, 0);
            grandient.endPoint = CGPointMake(0, 1);
            
            view;
        });
        
        self.titleLab = ({
            UILabel *label = [UILabel new];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.cover).offset(16.f);
                make.right.equalTo(self.cover).offset(-16.f);
                make.bottom.equalTo(self.cover).offset(-25);
            }];
            label.numberOfLines = 2;
            label;
        });
    }
    
    return self;
}

@end
