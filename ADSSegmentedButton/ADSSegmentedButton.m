//
//  ADSSegmentedButton.m
//  ADSSegmentedButtonDemo
//
//  Created by Andrew Shen on 2016/10/18.
//  Copyright © 2016年 Mintcode.com. All rights reserved.
//

#import "ADSSegmentedButton.h"
#import <Masonry/Masonry.h>

@interface ADSSegmentedButton ()

@property (nonatomic, strong)  NSMutableArray<UIButton *>  *buttonArray; // <##>
@property (nonatomic, strong)  UIView  *moveLine; // 移动的线
@property (nonatomic, strong)  UIView  *backgroundLine; // 底部背景线
@property (nonatomic, strong)  UIScrollView  *scrollView; // <##>
@property (nonatomic, strong, readwrite)  UIButton  *selectedButton; // 当前选中的btn
@property (nonatomic, assign)  CGFloat  moveLineHeight; // <##>
@end

@implementation ADSSegmentedButton

#pragma mark - InterfaceMethod
/**
 *  初始化一行按钮
 *
 *  @param arrayTitles        按钮标题
 *  @param arrayTags          按钮tag
 *  @param minimumButtonWidth   最小按钮宽度
 *
 */
- (instancetype)initWithTitles:(NSArray<NSString *> *)arrayTitles tags:(NSArray<NSNumber *> *)arrayTags minimumButtonWidth:(CGFloat)minimumButtonWidth {
    self = [super init];
    if (self) {
        // btn 个数
        [self addSubview:self.scrollView];
        NSInteger btnCount = arrayTitles.count;
        __block UIButton *btnLast;
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [arrayTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
            [btn setTitle:obj forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSNumber *tag = arrayTags ? arrayTags[idx] : @(idx);
            btn.tag = tag.integerValue;
            if (idx == 0) {
                [btn setSelected:YES];
                self.selectedButton = btn;
                
            }
            [self.scrollView addSubview:btn];
            [self.buttonArray addObject:btn];
            
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.top.bottom.equalTo(self.scrollView);
                make.width.greaterThanOrEqualTo(@(minimumButtonWidth)).priorityHigh();
                make.width.equalTo(self).multipliedBy(1.0 / btnCount).priorityMedium();
                if (btnLast) {
                    make.left.equalTo(btnLast.mas_right);
                }
                else {
                    make.left.equalTo(self.scrollView);
                }
                
            }];
            btnLast = btn;

        }];
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btnLast);
        }];
    }
    return self;
}


/**
 配置按钮样式
 
 @param normalTitleColor   正常状态颜色，默认黑色
 @param selectedTitleColor 标题选中状态颜色，默认黑色
 @param font               标题字体，默认button字体
 */
- (void)configNormalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor titleFont:(UIFont *)font {
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        !normalTitleColor ?: [obj setTitleColor:normalTitleColor forState:UIControlStateNormal];
        !selectedTitleColor ?: [obj setTitleColor:selectedTitleColor forState:UIControlStateSelected];
        !font ?: [obj.titleLabel setFont:font];
    }];
}


/**
 配置底部线条样式
 
 @param highlightLineColor   滚动线条颜色
 @param highlightLineHeight  滚动线条高度
 @param backgroundLineColor  背景线条颜色
 @param backgroundLineHeight 背景线条高度
 */
- (void)configBottomLineWithHighlightLineColor:(UIColor *)highlightLineColor highlightLineHeight:(CGFloat)highlightLineHeight backgroundLineColor:(UIColor *)backgroundLineColor backgroundLineHeight:(CGFloat)backgroundLineHeight {
    [self.backgroundLine setBackgroundColor:backgroundLineColor ?: [UIButton new].tintColor];
    [self.scrollView addSubview:self.backgroundLine];
    [self.backgroundLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(backgroundLineHeight);
    }];
    // moveLine
    [self.moveLine setBackgroundColor:highlightLineColor ?: [UIColor groupTableViewBackgroundColor]];
    [self.backgroundLine addSubview:self.moveLine];
    self.moveLineHeight = highlightLineHeight;
}

/**
 *  设置根据tag按钮选中
 *
 *  @param tag 选中按钮tag
 */
- (void)selectedButtonWithTag:(NSInteger)tag {
    UIButton *currentBtn = self.buttonArray[tag];
    [self.scrollView scrollRectToVisible:currentBtn.frame animated:YES];
    if (self.selectedButton.tag != currentBtn.tag) {
        [self.selectedButton setSelected:NO];
        [currentBtn setSelected:YES];
        self.selectedButton = currentBtn;
        
        [self p_updateLineConstraints];
        if ([self.delegate respondsToSelector:@selector(ADSSegmentedButtonDelegate:btnClickedWithTag:)]) {
            [self.delegate ADSSegmentedButtonDelegate:self btnClickedWithTag:self.selectedButton.tag];
        }
    }

}

#pragma mark - Event Method

- (void)buttonClicked:(UIButton *)sender {
    if (self.selectedButton.tag != sender.tag) {
        [self selectedButtonWithTag:sender.tag];
    }
}

#pragma mark - Private Method

- (void)p_updateLineConstraints {
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - Override

- (void)updateConstraints {
    if (_moveLine) {
        [self.moveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(self.selectedButton);
            make.bottom.equalTo(self.backgroundLine);
            make.height.mas_equalTo(@(self.moveLineHeight));
        }];
    }
    
    [super updateConstraints];
}


#pragma mark - Init

- (NSMutableArray<UIButton *> *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (UIView *)moveLine {
    if (!_moveLine) {
        _moveLine = [UIView new];
        _moveLine.backgroundColor = [UIButton new].tintColor;
    }
    return _moveLine;
}

- (UIView *)backgroundLine {
    if (!_backgroundLine) {
        _backgroundLine = [UIView new];
        _backgroundLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _backgroundLine;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
