//
//  LaunchViewController.m
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/3/7.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import "LaunchViewController.h"

@interface LaunchViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *launchView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showStartImage];
}

- (void)showStartImage {

    CGFloat scale = [UIScreen mainScreen].scale;
    NSInteger imageWidth = [@(kScreenWidth * scale) integerValue];
    NSInteger imageHeight = [@(kScreenHeight * scale) integerValue];
    [NetOperation getRequestWithURL:[NSString stringWithFormat:@"start-image/%ld*%ld",(long)imageWidth,(long)imageHeight] parameters:nil success:^(id responseObject) {
        NSString *imageURL = responseObject[@"img"];
        NSString *title = responseObject[@"text"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                _imageView.image = image;
                _titleLab.text = title;
                [UIView animateWithDuration:1.5f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    _launchView.alpha = 0.f;
                    _imageView.transform = CGAffineTransformMakeScale(1.08, 1.08);
                } completion:^(BOOL finished) {
                    self.view.window.rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).mainViewController;
                }];
            });
        });
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
