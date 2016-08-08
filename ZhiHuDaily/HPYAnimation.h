//
//  HPYAnimation.h
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/3/1.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPYAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign,nonatomic)NSTimeInterval animationDuration;
@property (assign,nonatomic)BOOL presenting;


@end
