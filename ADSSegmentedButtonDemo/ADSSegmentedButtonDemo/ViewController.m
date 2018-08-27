//
//  ViewController.m
//  ADSSegmentedButtonDemo
//
//  Created by Andrew Shen on 2016/10/18.
//  Copyright © 2016年 AndrewShen. All rights reserved.
//

#import "ViewController.h"
#import "ADSSegmentedButton.h"
#import <Masonry/Masonry.h>
#import "SubPageViewController.h"

@interface ViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,ADSSegmentedButtonDelegate>

@property (nonatomic, strong)  ADSSegmentedButton  *segButton; // <##>
@property (nonatomic, strong)  UIPageViewController  *pageViewController; //
@property (nonatomic, copy)  NSArray  *titleArray; // <##>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
    
    [self.segButton resetSegmentedButtonsWithTitles:self.titleArray tags:nil minimumButtonWidth:0];

}

// 设置数据
- (void)configData {
    self.titleArray = @[@"第一页",@"第二页",@"第三页",@"第四页"];
    [self.pageViewController setViewControllers:@[[self viewControllerWithIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
}

// 设置约束
- (void)configConstraints {
    [self.view addSubview:self.segButton];
    [self.segButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(55);
    }];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.segButton.mas_bottom);
    }];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (UIViewController *)viewControllerWithIndex:(NSInteger)index {
    if (index == NSNotFound) {
        return nil;
    }
    SubPageViewController *VC = [SubPageViewController new];
    [VC.page setText:[NSString stringWithFormat:@"%ld",index]];
    return VC;
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - PageViewControllerDataSource && Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    SubPageViewController *VC = (SubPageViewController *)viewController;
    NSInteger currentVCIndex = VC.page.text.integerValue;
    if ((currentVCIndex == 0) || (currentVCIndex == NSNotFound)) {
        return nil;
    }
    currentVCIndex --;
    return [self viewControllerWithIndex:currentVCIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    SubPageViewController *VC = (SubPageViewController *)viewController;
    NSInteger currentVCIndex = VC.page.text.integerValue;
    if (currentVCIndex == self.titleArray.count - 1) {
        return nil;
    }
    currentVCIndex ++;
    return [self viewControllerWithIndex:currentVCIndex];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    SubPageViewController *VC = (SubPageViewController *)self.pageViewController.viewControllers.firstObject;

    [self.segButton selectedButtonWithTag:VC.page.text.integerValue];

}

#pragma mark - ADSSegmentedButtonDelegate
- (void)ADSSegmentedButtonDelegate:(ADSSegmentedButton *)segmentedButton btnClickedWithTag:(NSInteger)tag {
    SubPageViewController *VC = self.pageViewController.viewControllers.firstObject;
    if (VC.page.text.integerValue == tag) {
        return;
    }
    UIPageViewControllerNavigationDirection direction = VC.page.text.integerValue > tag ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    NSLog(@"-------------->%@",self.pageViewController.viewControllers);
        [self.pageViewController setViewControllers:@[[self viewControllerWithIndex:tag]] direction:direction animated:YES completion:nil];
    
}

#pragma mark - Override

#pragma mark - Init

- (ADSSegmentedButton *)segButton {
    if (!_segButton) {
        _segButton = [[ADSSegmentedButton alloc] init];
        [_segButton configNormalTitleColor:[UIColor darkGrayColor] selectedTitleColor:[UIColor greenColor] titleFont:[UIFont systemFontOfSize:15]];
        [_segButton configBottomLineWithHighlightLineColor:[UIColor cyanColor] highlightLineHeight:2 backgroundLineColor:[UIColor grayColor] backgroundLineHeight:1];
        _segButton.delegate = self;
        [_segButton observeButtonSelectedCallback:^(UIButton *selectedButton, NSInteger tag) {
            NSLog(@"--->tag:%ld",tag);
        }];
    }
    return _segButton;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}


@end
