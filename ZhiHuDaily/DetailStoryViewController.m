//
//  DetailStoryViewController.m
//  ZhiHuDaily
//
//  Created by 洪鹏宇 on 16/2/29.
//  Copyright © 2016年 洪鹏宇. All rights reserved.
//


#import "DetailStoryViewController.h"
#import "ToolBarView.h"
#import "CoverView.h"
#import <SafariServices/SafariServices.h>

@interface DetailStoryViewController ()<UIScrollViewDelegate,UIWebViewDelegate>

@property (strong,nonatomic)DetailStoryViewModel *viewModel;

@property (weak,nonatomic)UIView *headerView;
@property (weak,nonatomic)UIImageView *imageView;
@property (weak,nonatomic)CoverView *cover;
@property (weak,nonatomic)UILabel *imageSoureLab;
@property (weak,nonatomic)UILabel *titleLab;
@property (weak,nonatomic)ToolBarView *toolBar;
@property (weak,nonatomic)UIWebView *webView;
@property (assign,nonatomic)BOOL isLightContent;//状态栏风格
@property (weak,nonatomic)UIButton *previousWarnbtn;
@property (weak,nonatomic)UIButton *nextWarnBtn;

@end

@implementation DetailStoryViewController

- (instancetype)initWithViewModel:(DetailStoryViewModel *)vm {
    self = [super init];
    if (self) {
        self.viewModel = vm;
        self.isLightContent = YES;
        [self configAllObservers];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self.viewModel getStoryContentWithStoryID:self.viewModel.tagStroyID];
}

- (void)configAllObservers {
    [self.viewModel addObserver:self forKeyPath:@"detailStory" options:NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"isLightContent" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"extraDic" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeAllObservers {
    [self.viewModel removeObserver:self forKeyPath:@"detailStory"];
    [self removeObserver:self forKeyPath:@"isLightContent"];
    [self.viewModel removeObserver:self forKeyPath:@"extraDic"];
}


- (void)dealloc {
    [self removeAllObservers];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"detailStory"]) {
        self.titleLab.attributedText = self.viewModel.titleAttText;
        self.imageSoureLab.text = self.viewModel.imageSourceText;
        [self.webView loadHTMLString:self.viewModel.htmlStr baseURL:nil];
        self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.viewModel.imageURL]];
        
    }
    if ([keyPath isEqualToString:@"isLightContent"]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if ([keyPath isEqualToString:@"extraDic"]) {
        self.toolBar.update(self.viewModel.extraDic);
    }

}

- (void)initSubViews {
    
    _toolBar = ({
        ToolBarView *view = [ToolBarView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self.view);
            make.height.mas_equalTo(43.f);
        }];
        __weak typeof(self) weakSelf = self;
        view.back = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        };
        view.next = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.viewModel getNextStory];
        };
        view.update = ^(NSDictionary *info){
            UIButton *votebtn = (UIButton *)[self.toolBar viewWithTag:2];
            [votebtn setTitle:[info[@"popularity"] stringValue] forState:UIControlStateNormal];
            [votebtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            UIButton *commentsbtn = (UIButton *)[self.toolBar viewWithTag:4];
            [commentsbtn setTitle:[info[@"comments"] stringValue]forState:UIControlStateNormal];
            [commentsbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        };
        view;
    });

    _webView = ({
        UIWebView *view = [UIWebView new];
        [self.view insertSubview:view atIndex:0];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.mas_topLayoutGuideBottom);
            make.bottom.equalTo(self.toolBar.mas_top);
        }];
        view.scrollView.delegate = self;
        view.scrollView.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        view;
    });
    
    _headerView = ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-(kScreenWidth-220.f)/2);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo((kScreenWidth-(kScreenWidth-220.f)/2));
        }];
        view.clipsToBounds = YES;
        view;
    });
    
    _imageView = ({
        UIImageView *view = [UIImageView new];
        [self.headerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self.headerView);
            make.height.equalTo(self.view.mas_width);
        }];
        view;
    });
    
    _cover = ({
        CoverView *view = [CoverView new];
        [self.headerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.headerView);
        }];
        
        CAGradientLayer *grandient = (CAGradientLayer *)view.layer;
        grandient.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.60f].CGColor,
                             (id)[[UIColor blackColor] colorWithAlphaComponent:0.30f].CGColor,
                             (id)[[UIColor blackColor] colorWithAlphaComponent:0.0f].CGColor,
                             (id)[[UIColor blackColor] colorWithAlphaComponent:0.25f].CGColor,
                             (id)[[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor];
        grandient.locations = @[@0.0,@0.1,@0.25,@0.75,@0.9,@1.0];
        grandient.startPoint = CGPointMake(0, 0);
        grandient.endPoint = CGPointMake(0, 1);
        
        view;
    });
    
    _imageSoureLab = ({
        UILabel* label = [UILabel new];
        [self.headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headerView).offset(-16.f);
            make.bottom.equalTo(self.headerView).offset(-8.f);
        }];
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        label.font = [UIFont systemFontOfSize:11];
        label;
    });
    
    _titleLab = ({
        UILabel* label = [UILabel new];
        [self.headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView).offset(16.f);
            make.right.equalTo(self.headerView).offset(-16.f);
            make.bottom.equalTo(self.imageSoureLab.mas_top).offset(-4.f);
        }];
        label.numberOfLines = 0;
        label;
    });
    
    _previousWarnbtn = ({
        UIButton *btn = [UIButton new];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view.mas_top).offset(-10);
            make.centerX.equalTo(self.view);
        }];
        btn.enabled = NO;
        [btn setTitle:@"载入上一篇" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setImage:[UIImage imageNamed:@"ZHAnswerViewBackIcon"] forState:UIControlStateNormal];
        btn;
    });
    
    _nextWarnBtn = ({
        UIButton *btn = [UIButton new];
        [self.view insertSubview:btn belowSubview:self.toolBar];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolBar.mas_top).offset(10);
            make.centerX.equalTo(self.view);
        }];
        btn.enabled = NO;
        [btn setTitle:@"载入下一篇" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setImage:[UIImage imageNamed:@"ZHAnswerViewPrevIcon"] forState:UIControlStateNormal];
        btn;
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY < 0.f) {
        if (offSetY > - 90.f) {
            [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(-(kScreenWidth-220.f)/2-offSetY/2);
                make.height.mas_equalTo(kScreenWidth-(kScreenWidth-220.f)/2-offSetY/2);
            }];
            [super updateViewConstraints];
        }else {
            _webView.scrollView.contentOffset = CGPointMake(0.f, -90.f);
        }

    }else if (offSetY >= 0.f && offSetY <= 400.f){
        [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-(kScreenWidth-220.f)/2-offSetY);
        }];
        [super updateViewConstraints];
    }
    
    self.isLightContent = offSetY < 220.f;
    
    if (offSetY < 0.f && offSetY > - 90.f ) {
        if (offSetY > -45.f) {
            self.previousWarnbtn.imageView.transform = CGAffineTransformIdentity;
            [self.previousWarnbtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.view.mas_top).offset(-10-offSetY);
            }];
            [super updateViewConstraints];

        }else {
            self.previousWarnbtn.imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
            if (!self.webView.scrollView.dragging&&!self.viewModel.isLoading) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.viewModel getPreviousStory];
                });
            }
        }
    }
    
    if (offSetY + scrollView.frame.size.height > scrollView.contentSize.height) {
        if (offSetY + scrollView.frame.size.height < scrollView.contentSize.height + 80.f) {
            self.nextWarnBtn.imageView.transform = CGAffineTransformIdentity;
            [self.nextWarnBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.toolBar.mas_top).offset(10-(offSetY+scrollView.frame.size.height-scrollView.contentSize.height));
            }];
            [super updateViewConstraints];
        }else if (offSetY + scrollView.frame.size.height < scrollView.contentSize.height + 160.f){
            self.nextWarnBtn.imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
            if (!self.webView.scrollView.dragging&&!self.viewModel.isLoading) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.viewModel getNextStory];
                });
            }
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:request.URL];
        [self presentViewController:safariVC animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (!self.isLightContent) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

@end
