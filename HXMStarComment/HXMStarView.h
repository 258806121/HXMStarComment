//
//  HXMStarView.h
//  HXMStarComment
//
//  Created by HXM on 2017/5/5.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXMStarView;

/**
 评分完成的block
 
 @param currentScore 当前评分
 */
typedef void(^finishBlock)(CGFloat currentScore);

/**
 评分样式
 */
typedef NS_ENUM(NSInteger, RateStyle)
{
    WholeStar = 0,      // 只能整星评论
    HalfStar,           // 允许半星评论
    IncompleteStar      // 允许不完整星评论
};

@protocol HXMStarViewDelegate <NSObject>

/**
 代理方法 (当前星星评论视图的评分)

 @param starView 星级评论视图
 @param currentScore 当前评分
 */
- (void)starView:(HXMStarView *)starView currentScore:(CGFloat)currentScore;

@end

@interface HXMStarView : UIView

/**
 代理
 */
@property (nonatomic,weak) id<HXMStarViewDelegate>delegate;

/**
 是否动画显示,默认NO
 */
@property (nonatomic, assign) BOOL isAnimation;

/**
 评分样式,默认是WholeStar
 */
@property (nonatomic, assign) RateStyle rateStyle;

/**
 星星数量
 */
@property (nonatomic, assign) NSInteger numberOfStars;

/**
 当前评分：0-5  默认0
 */
@property (nonatomic, assign) CGFloat currentScore;

/**
 默认初始化方法,(默认5星,整星),代理方式

 @param frame frame
 @return hxmStarView
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 自定义初始化(代理方式)

 @param frame frame
 @param numberOfStars 星星数量
 @param rateStyle 评分样式
 @param isAnimation 是否显示动画
 @param delegate 代理
 @return hxmStarView
 */
- (instancetype)initWithFrame:(CGRect)frame
                numberOfStars:(NSInteger)numberOfStars
                    rateStyle:(RateStyle)rateStyle
                  isAnimation:(BOOL)isAnimation
                     delegate:(id)delegate;

/**
 初始化,(默认5星,整星),(block)

 @param frame frame
 @param finishBlock block
 @return hxmStarView
 */
- (instancetype)initWithFrame:(CGRect)frame finishBlock:(finishBlock)finishBlock;

/**
 自定义初始化 (block)

 @param frame frame
 @param numberOfStars 星星数量
 @param rateStyle 评分样式
 @param isAnimation 是否显示动画
 @param finishBlock block
 @return hxmStarView
 */
- (instancetype)initWithFrame:(CGRect)frame
                numberOfStars:(NSInteger)numberOfStars
                    rateStyle:(RateStyle)rateStyle
                  isAnimation:(BOOL)isAnimation
                  finishBlock:(finishBlock)finishBlock;

@end
