//
//  ThemeViewModel.h
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/3/5.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoryCellViewModel;
@interface ThemeViewModel : NSObject

@property (strong,nonatomic)NSString *themeID;
@property (strong,nonatomic)NSMutableArray *sectionViewModels;
@property (strong,nonatomic)NSMutableArray *allStoriesID;
@property(assign,readonly,nonatomic)BOOL isLoading;
@property (strong,nonatomic)NSString *imageURLStr;
@property (strong,nonatomic)NSString *name;
@property (strong,nonatomic)NSArray *editors;
@property(strong,nonatomic)NSOperationQueue *loadQueue;
@property (strong,nonatomic)NSMutableDictionary *progress;

- (void)getDailyThemesDataWithThemeID:(NSString *)themeID;
- (void)getMoreDailyThemesData;

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (StoryCellViewModel *)cellViewModelAtIndexPath:(NSIndexPath *)indexPath;

@end
