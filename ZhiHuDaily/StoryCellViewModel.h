//
//  StoryCellViewModel.h
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/2/20.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, StoryCellType) {
    StoryCellTypeNormal,
    StoryCellTypeTopStory,
};

@interface StoryCellViewModel : NSObject

@property (strong,readonly,nonatomic)NSString *storyID;
@property (assign,readonly,nonatomic)StoryCellType type;
@property (strong,readonly,nonatomic)NSAttributedString *title;
@property (strong,nonatomic)UIImage *preImage;
@property (strong,nonatomic)UIImage *displayImage;
@property (assign,readonly,nonatomic)CGRect titleLabFrame;
@property (assign,readonly,nonatomic)CGRect imageViewFrame;
@property (strong,nonatomic)NSURL *topStoryImaURL;


- (instancetype)initWithDictionary:(NSDictionary *)dic cellType:(StoryCellType) tp;
- (NSBlockOperation *)loadDisplayImage;

@end
