//
//  CoverView.m
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/3/2.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import "CoverView.h"

@implementation CoverView

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        CAGradientLayer *grandient = (CAGradientLayer *)self.layer;
//        grandient.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.35f].CGColor,
//                             (id)[[UIColor blackColor] colorWithAlphaComponent:0.f].CGColor,
//                             (id)[[UIColor blackColor] colorWithAlphaComponent:0.35f].CGColor];
//        grandient.locations = @[@0.0,@0.2,@0.8,@1.0];
//        grandient.startPoint = CGPointMake(0, 0);
//        grandient.endPoint = CGPointMake(0, 1);
//    }
//    return self;
//}


+ (Class)layerClass {
    return [CAGradientLayer class];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
