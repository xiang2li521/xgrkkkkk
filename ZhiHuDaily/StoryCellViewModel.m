//
//  StoryCellViewModel.m
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/2/20.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import "StoryCellViewModel.h"
#import "StoryModel.h"

static const CGFloat kMainTableViewRowHeight = 95.f;
static const CGFloat kSpacing = 18.f;
static const CGFloat kNormalImageW = 75.f;
static const CGFloat kNormalImageH = 75.f;

@interface StoryCellViewModel()

@property (strong,nonatomic)StoryModel *story;

@end

@implementation StoryCellViewModel 

- (instancetype)initWithDictionary:(NSDictionary *)dic cellType:(StoryCellType) tp{
    self = [super init];
    if (self) {
        _story = [[StoryModel alloc] initWithDictionary:dic error:nil];
        _storyID = _story.storyID;
        _type = tp;
    }
    return self;
}

- (NSURL *)topStoryImaURL {
    return self.story.image;
}

- (NSAttributedString *)title {
    NSAttributedString *str;
    switch (self.type) {
        case StoryCellTypeNormal:{
            str = [[NSAttributedString alloc] initWithString:_story.title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]}];
            break;
        }
        case StoryCellTypeTopStory:{
            str = [[NSAttributedString alloc] initWithString:_story.title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:21],NSForegroundColorAttributeName:[UIColor whiteColor]}];
            break;
        }
    }
    return str;
}

- (UIImage *)preImage {

    UIImage* images;
    switch (self.type) {
        case StoryCellTypeNormal:{
            images = [UIImage imageNamed:@"Image_Preview"];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kMainTableViewRowHeight), NO, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextAddRect(context, CGRectMake(kSpacing, kSpacing, kScreenWidth-kSpacing*2, kMainTableViewRowHeight-kSpacing*2));
            CGContextClip(context);
            [images drawInRect:self.imageViewFrame];
            [self.title drawInRect:self.titleLabFrame];
            images = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            break;
        }
        case StoryCellTypeTopStory:{
            images = [UIImage imageNamed:@"Home_Image"];
            break;
        }
    }
    
    return images ;
}

- (NSBlockOperation *)loadDisplayImage {
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.story.images[0]]]];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kMainTableViewRowHeight), NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddRect(context, CGRectMake(kSpacing, kSpacing, kScreenWidth-kSpacing*2, kMainTableViewRowHeight-kSpacing*2));
        CGContextClip(context);
        [self.preImage drawInRect:CGRectMake(0, 0, kScreenWidth, kMainTableViewRowHeight)];
        [image drawInRect:self.imageViewFrame];
        if (self.story.multipic&&self.story.image) {
            UIImage *warnImage = [UIImage imageNamed:@"Home_Morepic"];
            [warnImage drawInRect:CGRectMake(kScreenWidth-warnImage.size.width-kSpacing, kMainTableViewRowHeight-kSpacing-warnImage.size.height, warnImage.size.width, warnImage.size.height)];
        }
        self.displayImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }];
    
//    op.completionBlock = ^{
//        NSLog(@"%@",_story);
//        _story = nil;
//        NSLog(@"%@",_story);
//    };
    
    return op;
}

- (CGRect)imageViewFrame {
    CGRect frame;
    switch (self.type) {
        case StoryCellTypeNormal:{
            frame = self.story.images ? CGRectMake(kScreenWidth-kNormalImageW-kSpacing, 10.f, kNormalImageH, kNormalImageW) : CGRectZero;
            break;
        }
        case StoryCellTypeTopStory:{
            frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
            break;
        }
    }
    return frame;
}

- (CGRect)titleLabFrame {
    CGRect frame;
    switch (self.type) {
        case StoryCellTypeNormal:{
            CGFloat width = CGRectEqualToRect(self.imageViewFrame, CGRectZero) ? (kScreenWidth - kSpacing*2) : (kScreenWidth - kSpacing*3 - kNormalImageW);
            CGFloat height = [self.title boundingRectWithSize:CGSizeMake(width, kMainTableViewRowHeight - kSpacing*2) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
            frame = CGRectMake(kSpacing, kSpacing, width, height);
            break;
        }
        case StoryCellTypeTopStory:{
            CGFloat height = [self.title boundingRectWithSize:CGSizeMake(kScreenWidth-kSpacing*2, kScreenWidth) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
            frame = CGRectMake(kSpacing, kScreenWidth- (kScreenWidth-220)/2 - height - 30.f, kScreenWidth-kSpacing*2, height);
            break;
        }
    }
    return frame;

}

@end
