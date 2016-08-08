//
//  CarouselView.m
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/2/24.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//

#import "CarouselView.h"
#import "TopStoryCell.h"
#import "StoryCellViewModel.h"

@interface CarouselView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong,nonatomic)NSTimer *timer;
@property (strong,nonatomic)UIPageControl *pageControl;
@property (strong,nonatomic)CoverView *cover;

@end



@implementation CarouselView

- (instancetype)initWithFrame:(CGRect)frame itemViewModels:(NSArray *)itemvs {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self updateSubViewsContentWithItems:itemvs];
    }
    return self;
}


- (void)initSubViews{
    
    self.cv = ({
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.itemSize = CGSizeMake(self.width,self.height);
        flowlayout.minimumInteritemSpacing = 0.f;
        flowlayout.minimumLineSpacing = 0.f;
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, self.height) collectionViewLayout:flowlayout];
        view.backgroundColor = [UIColor whiteColor];
        view.showsHorizontalScrollIndicator = NO;
        view.showsVerticalScrollIndicator = NO;
        view.pagingEnabled = true;
        view.delegate = self;
        view.dataSource = self;
        [self addSubview:view];
        [view registerClass:[TopStoryCell class] forCellWithReuseIdentifier:NSStringFromClass([TopStoryCell class])];
        
        view;
    });
    
    self.pageControl = ({
        UIPageControl *pc = [UIPageControl new];
        [self addSubview:pc];
        [pc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-(kScreenWidth-220)/2);
        }];
        pc.pageIndicatorTintColor = [UIColor grayColor];
        pc.currentPageIndicatorTintColor = [UIColor whiteColor];
        pc;
    });
}

- (void)updateSubViewsPosition:(CGFloat)offset {
    int index = _cv.contentOffset.x/kScreenWidth;
    TopStoryCell *cell = [_cv cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [cell.cover mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentView).offset(-(kScreenWidth-220.f)/2-offset);
    }];
    
    [_pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-(kScreenWidth-220)/2-offset);
    }];
    [super updateConstraints];
}

- (void)updateSubViewsContentWithItems:(NSArray *)itemvms {
    if (itemvms) {
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:itemvms];
        [tmp insertObject:[itemvms lastObject] atIndex:0];
        [tmp addObject:[itemvms firstObject]];
        self.items = tmp;
        [self.cv reloadData];
        [self.cv scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.pageControl.numberOfPages = itemvms.count;
        self.pageControl.currentPage = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(nextItem) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (StoryCellViewModel *vm in self.items) {
                vm.displayImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:vm.topStoryImaURL]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cv reloadData];
            });
        });
    }
}

- (void)nextItem {
    int currentItem = self.cv.contentOffset.x/self.bounds.size.width;
    currentItem ++;
    [self.cv scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TopStoryCell class]) forIndexPath:indexPath];
    StoryCellViewModel *vm = self.items[indexPath.item];
    if (!vm.displayImage) {
        cell.imageView.image = vm.preImage;
    }else {
        cell.imageView.image = vm.displayImage;
    }
    cell.titleLab.attributedText = vm.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tap) {
        self.tap(indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.x <= self.bounds.size.width/4) {
        [self.cv scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(self.items.count-2) inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    else if(scrollView.contentOffset.x >= (self.items.count-5/4)*self.bounds.size.width){
        [self.cv scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    _pageControl.currentPage = scrollView.contentOffset.x/self.bounds.size.width - 1;

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:10.f]];
}


@end
