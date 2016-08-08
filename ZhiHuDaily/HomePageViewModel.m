//
//  HomePageViewModel.m
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/2/4.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import "HomePageViewModel.h"
#import "NSDateFormatter+Extension.h"

@interface SectionViewModel : NSObject

@property(strong,readonly,nonatomic)NSString *titleText;
@property(strong,readonly,nonatomic)NSArray *cellViewModels;


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@implementation SectionViewModel

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _titleText = [self stringConvertToSectionTitleText:dic[@"date"]];
        NSArray *stories = dic[@"stories"];
        NSMutableArray *temp = [NSMutableArray new];
        for (NSDictionary *storyDic in stories) {
            StoryCellViewModel *vm = [[StoryCellViewModel alloc] initWithDictionary:storyDic cellType:StoryCellTypeNormal];
            [temp addObject:vm];
        }
        _cellViewModels = temp;
    }
    return self;
}

- (NSString*)stringConvertToSectionTitleText:(NSString*)str {
    
    NSDateFormatter *formatter = [NSDateFormatter sharedInstance];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:str];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CH"];
    [formatter setDateFormat:@"MM月dd日 EEEE"];
    NSString *sectionTitleText = [formatter stringFromDate:date];
    
    return sectionTitleText;
}

@end


@implementation HomePageViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _loadQueue = [[NSOperationQueue alloc] init];
        _sectionViewModels = [NSMutableArray array];
        _progress = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSUInteger)numberOfSections {
    return self.sectionViewModels.count;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    SectionViewModel *svm = self.sectionViewModels[section];
    return svm.cellViewModels.count;
}

- (NSAttributedString *)titleForSection:(NSInteger)section {
    SectionViewModel *svm = self.sectionViewModels[section];
    return [[NSAttributedString alloc] initWithString:svm.titleText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18] ,NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (StoryCellViewModel *)cellViewModelAtIndexPath:(NSIndexPath *)indexPath {
    SectionViewModel *svm = _sectionViewModels[indexPath.section];
    StoryCellViewModel *story = svm.cellViewModels[indexPath.row];
    return story;
}

//获取最新的新闻
- (void)getLatestStories {
    [NetOperation getRequestWithURL:@"stories/latest" parameters:nil success:^(id responseObject) {

        NSDictionary *jsonDic = (NSDictionary*)responseObject;
        self.currentLoadDayStr = responseObject[@"date"];
        
        SectionViewModel *vm = [[SectionViewModel alloc] initWithDictionary:jsonDic];
        if (self.sectionViewModels.count == 0){
            NSMutableArray *secvms = [NSMutableArray arrayWithObject:vm];
            [self setValue:secvms forKey:@"sectionViewModels"];
            _allStoriesID = [NSMutableArray arrayWithArray:[vm valueForKeyPath:@"cellViewModels.storyID"]];
        }else {
            NSMutableArray *temp = [self mutableArrayValueForKey:@"sectionViewModels"];
            SectionViewModel *old = [temp objectAtIndex:0];
            SectionViewModel *new = vm;
            if (old.cellViewModels.count < new.cellViewModels.count) {
                [temp replaceObjectAtIndex:0 withObject:new];
                NSUInteger addNum = new.cellViewModels.count - old.cellViewModels.count;
                for (NSUInteger i = addNum ; i > 0; i--){
                    StoryCellViewModel *svm = new.cellViewModels[i-1];
                    [_allStoriesID insertObject:svm.storyID atIndex:0];
                }
            }
        }
        
        NSArray *topstories = jsonDic[@"top_stories"];
        NSMutableArray *temp = [NSMutableArray new];
        for (NSDictionary *storyDic in topstories) {
            StoryCellViewModel *vm = [[StoryCellViewModel alloc] initWithDictionary:storyDic cellType:StoryCellTypeTopStory];
            [temp addObject:vm];
        }
        [self setValue:temp forKey:@"top_stories"];
    } failure:nil];
}

- (void)getPreviousStories {
    
    _isLoading = YES;
    [NetOperation getRequestWithURL:[NSString stringWithFormat:@"stories/before/%@",self.currentLoadDayStr] parameters:nil success:^(id responseObject) {
        NSDictionary *jsonDic = (NSDictionary*)responseObject;
        self.currentLoadDayStr = responseObject[@"date"];
        
        SectionViewModel *vm = [[SectionViewModel alloc] initWithDictionary:jsonDic];
        NSMutableArray *temp = [self mutableArrayValueForKey:@"sectionViewModels"];
        [temp addObject:vm];
        [_allStoriesID addObjectsFromArray:[vm valueForKeyPath:@"cellViewModels.storyID"]];
        _isLoading = NO;
    } failure:^(NSError *error) {
        _isLoading = NO;
    }];
}

@end
