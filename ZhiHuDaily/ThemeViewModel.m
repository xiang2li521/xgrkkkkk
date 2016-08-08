//
//  ThemeViewModel.m
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/3/5.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import "ThemeViewModel.h"
#import "StoryCellViewModel.h"


@implementation ThemeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _loadQueue = [[NSOperationQueue alloc] init];
        _progress = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSUInteger)numberOfSections {
    return self.sectionViewModels.count;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    NSArray *cellvms = self.sectionViewModels[section];
    return cellvms.count;
}

- (StoryCellViewModel *)cellViewModelAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cellvms = self.sectionViewModels[indexPath.section];
    return cellvms[indexPath.row];
}

- (void)getDailyThemesDataWithThemeID:(NSString *)themeID {
    _themeID = themeID;
    [NetOperation getRequestWithURL:[NSString stringWithFormat:@"theme/%@",themeID] parameters:nil success:^(id responseObject) {
        
        NSDictionary *jsonDic = (NSDictionary *)responseObject;
        NSArray *storiesArr = jsonDic[@"stories"];
        NSMutableArray* tempArr = [NSMutableArray array];
        for (NSDictionary *dic in storiesArr) {
            StoryCellViewModel *vm = [[StoryCellViewModel alloc] initWithDictionary:dic cellType:StoryCellTypeNormal];
            [tempArr addObject:vm];
        }
        [self setValue:jsonDic[@"name"] forKey:@"name"];
        [self setValue:@[tempArr] forKey:@"sectionViewModels"];
        _allStoriesID = [NSMutableArray arrayWithArray:[tempArr valueForKey:@"storyID"]];
        [self setValue:jsonDic[@"background"] forKey:@"imageURLStr"];
        [self setValue:jsonDic[@"name"] forKey:@"name"];
        [self setValue:jsonDic[@"editors"] forKey:@"editors"];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)getMoreDailyThemesData {
    _isLoading = YES;
    [NetOperation getRequestWithURL:[NSString stringWithFormat:@"theme/%@/before/%@",_themeID,[_allStoriesID lastObject]] parameters:nil success:^(id responseObject) {
        NSDictionary *jsonDic = (NSDictionary *)responseObject;
        NSArray *storiesArr = jsonDic[@"stories"];
        NSMutableArray* tempArr = [NSMutableArray array];
        for (NSDictionary *dic in storiesArr) {
            StoryCellViewModel *vm = [[StoryCellViewModel alloc] initWithDictionary:dic cellType:StoryCellTypeNormal];
            [tempArr addObject:vm];
        }
        NSMutableArray *temp = [self mutableArrayValueForKey:@"sectionViewModels"];
        [temp addObject:tempArr];
        [_allStoriesID addObjectsFromArray:[tempArr valueForKeyPath:@"storyID"]];
        _isLoading = NO;
    } failure:^(NSError *error) {
        _isLoading = NO;
    }];
}


@end
