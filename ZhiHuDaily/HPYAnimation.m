//
//  HPYAnimation.m
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/3/1.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import "HPYAnimation.h"

@implementation HPYAnimation


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.animationDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    CGRect originalFrame = fromView.frame;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    UIView *snapView;
    if (_presenting) {
        toView.frame = CGRectOffset(originalFrame, screenBounds.size.width, 0);
    }else {
        toView.frame = originalFrame;
        snapView = [fromView snapshotViewAfterScreenUpdates:YES];
        snapView.frame = originalFrame;
    }
    [containerView addSubview:toView];
    [containerView addSubview:snapView];
    [UIView animateWithDuration:self.animationDuration animations:^{
        if (_presenting) {
            toView.frame = originalFrame;
        }else {
            snapView.frame = CGRectOffset(originalFrame, screenBounds.size.width, 0);
        }
        
    } completion:^(BOOL finished) {
        [snapView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}


@end
