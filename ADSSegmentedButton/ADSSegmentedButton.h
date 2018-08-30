//
//  ADSSegmentedButton.h
//  ADSSegmentedButtonDemo
//
//  Created by Andrew Shen on 2016/10/18.
//  Copyright © 2016年 Mintcode.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADSSegmentedButton;

typedef void(^ADSSegmentedButtonCompletion)(UIButton *selectedButton, NSInteger tag);
typedef NS_ENUM(NSUInteger, ADSSegmentedButtonAlignment) {
    ADSSegmentedButtonAlignmentJustified,
    ADSSegmentedButtonAlignmentLeft,
};

NS_ASSUME_NONNULL_BEGIN
@protocol ADSSegmentedButtonDelegate <NSObject>

// 按钮点击
- (void)ADSSegmentedButtonDelegate:(ADSSegmentedButton *)segmentedButton btnClickedWithTag:(NSInteger)tag;

@end

@interface ADSSegmentedButton : UIView

@property (nonatomic, weak)  id <ADSSegmentedButtonDelegate>  delegate; // 委托
@property (nonatomic, strong, readonly)  UIButton  *selectedButton; // 当前选中的btn

/**
 *  初始化一行按钮
 *
 *  @param arrayTitles        按钮标题
 *  @param arrayTags          按钮tag，可选，不设定则默认为0..n
 *  @param minimumButtonWidth   最小按钮宽度,可为0
 *  @param alignment   按钮对齐方式
 */
- (instancetype)initWithTitles:(NSArray<NSString *> *)arrayTitles tags:(nullable NSArray<NSNumber *> *)arrayTags minimumButtonWidth:(CGFloat)minimumButtonWidth alignment:(ADSSegmentedButtonAlignment)alignment;


/**
 重设按钮
 *  @param arrayTitles        按钮标题
 *  @param arrayTags          按钮tag，可选，不设定则默认为0..n
 *  @param minimumButtonWidth   最小按钮宽度,可为0
 */
- (void)resetSegmentedButtonsWithTitles:(NSArray<NSString *> *)arrayTitles tags:(nullable NSArray<NSNumber *> *)arrayTags minimumButtonWidth:(CGFloat)minimumButtonWidth alignment:(ADSSegmentedButtonAlignment)alignment;

/**
 监听按钮点击
 
 @param completion 点击回调
 */
- (void)observeButtonSelectedCallback:(ADSSegmentedButtonCompletion)completion;

/**
 配置按钮样式,方法可选
 
 @param normalTitleColor   正常状态颜色，默认蓝色
 @param selectedTitleColor 标题选中状态颜色，默认黑色
 @param normalFont               标题字体，默认button字体
 @param selectFont              选中字体
 */
- (void)configNormalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor normalFont:(UIFont *)normalFont selectedFont:(nullable UIFont *)selectFont;


/**
 配置底部线条样式，可选，不调用此方法则不显示下划线
 
 @param highlightLineColor   滚动线条颜色
 @param highlightLineHeight  滚动线条高度
 @param backgroundLineColor  背景线条颜色
 @param backgroundLineHeight 背景线条高度
 @param lineWidth            滚动线条宽度
 */
- (void)configBottomLineWithHighlightLineColor:(nullable UIColor *)highlightLineColor highlightLineHeight:(CGFloat)highlightLineHeight backgroundLineColor:(nullable UIColor *)backgroundLineColor backgroundLineHeight:(CGFloat)backgroundLineHeight lineWidth:(CGFloat)lineWidth;

/**
 *  设置根据tag按钮选中
 *
 *  @param tag 选中按钮tag
 */
- (void)selectedButtonWithTag:(NSInteger)tag;


@end

NS_ASSUME_NONNULL_END
