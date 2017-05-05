//
//  HXMStarView.m
//  HXMStarComment
//
//  Created by HXM on 2017/5/5.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import "HXMStarView.h"

/**
 选中状态的星星图片
 */
#define STAR_SELECTED @"star_selecred"

/**
 正常状态的星星图片
 */
#define STAR_NORMAL @"star_normal"

typedef void(^CompletionBlock)(CGFloat currentScore);

@interface HXMStarView ()

/**
 选中状态的星级View
 */
@property (nonatomic, strong) UIView *selectedStarView;

/**
 正常状态的星级View
 */
@property (nonatomic, strong) UIView *normalStarView;

/**
 block
 */
@property (nonatomic, copy) CompletionBlock completionBlock;

@end

@implementation HXMStarView

#pragma mark - 初始化方法

/**
 默认初始化方法,(默认5星,整星),代理方式

 @param frame frame
 @return hxmStarView
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 默认 5 星
        _numberOfStars = 5;
        // 评分样式,默认整星
        _rateStyle = WholeStar;
        // 创建视图
        [self setupStarView];
    }
    return self;
}

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
                     delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // 星星数量
        _numberOfStars = numberOfStars;
        // 评分样式
        _rateStyle = rateStyle;
        // 是否有动画
        _isAnimation = isAnimation;
        // 代理
        _delegate = delegate;
        // 创建视图
        [self setupStarView];
    }
    return self;
}

/**
 初始化,(默认5星,整星),(block)
 
 @param frame frame
 @param finishBlock block
 @return hxmStarView
 */
- (instancetype)initWithFrame:(CGRect)frame finishBlock:(finishBlock)finishBlock
{
    self = [super initWithFrame:frame];
    if (self ) {
        // 默认 5 星
        _numberOfStars = 5;
        // 评分样式,默认整星
        _rateStyle = WholeStar;
        // block
        _completionBlock = ^(CGFloat currentScore){
            finishBlock(currentScore);
        };
        // 创建视图
        [self setupStarView];
    }
    return self;
}

/**
 自定义初始化 (block)
 
 @param frame frame
 @param numberOfStars 星星数量
 @param rateStyle 评分样式
 @param isAnimation 是否显示动画
 @param finishBlock block
 @return hxmStarView
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnimation:(BOOL)isAnimation finishBlock:(finishBlock)finishBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        // 星星数量
        _numberOfStars = numberOfStars;
        // 评分样式
        _rateStyle = rateStyle;
        // 是否有动画
        _isAnimation = isAnimation;
        // block
        _completionBlock = ^(CGFloat currentScore){
            finishBlock(currentScore);
        };
        // 创建视图
        [self setupStarView];
    }
    return self;
}

#pragma mark - Data & UI

/**
 创建视图
 */
- (void)setupStarView
{
    // 选中状态的星级View
    self.selectedStarView = [self createStarViewWithImage:STAR_SELECTED];
    self.selectedStarView.frame = CGRectMake(0, 0, self.bounds.size.width * _currentScore/self.numberOfStars, self.bounds.size.height);
    
    // 正常状态的星级View
    self.normalStarView = [self createStarViewWithImage:STAR_NORMAL];
    
    // 添加视图
    [self addSubview:self.normalStarView];
    [self addSubview:self.selectedStarView];
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    [self addGestureRecognizer:tapGesture];
}

/**
 星级View
 
 @param imageName 图片名字
 @return starView
 */
- (UIView *)createStarViewWithImage:(NSString *)imageName
{
    UIView *starView = [[UIView alloc] initWithFrame:self.bounds];
    starView.clipsToBounds = YES;
    starView.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * self.bounds.size.width / self.numberOfStars, 0, self.bounds.size.width / self.numberOfStars, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [starView addSubview:imageView];
    }
    return starView;
}

/**
 用户点击starView的方法

 @param gesture gesture
 */
- (void)userTapRateView:(UITapGestureRecognizer *)gesture
{
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
    switch (_rateStyle) {
        case WholeStar:
        {
            self.currentScore = ceilf(realStarScore);
            break;
        }
        case HalfStar:
            self.currentScore = roundf(realStarScore)>realStarScore ? ceilf(realStarScore):(ceilf(realStarScore)-0.5);
            break;
        case IncompleteStar:
            self.currentScore = realStarScore;
            break;
        default:
            break;
    }
}

/**
 layoutSubviews
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 弱引用,防止循环引用
    __weak typeof(self) ws = self;
    // 动画时间,是 0.2 否 0
    CGFloat animationTimeInterval = self.isAnimation ? 0.2 : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        ws.selectedStarView.frame = CGRectMake(0, 0, ws.bounds.size.width * ws.currentScore/self.numberOfStars, ws.bounds.size.height);
    }];
}

/**
 setter方法

 @param currentScore 当前评分
 */
- (void)setCurrentScore:(CGFloat)currentScore
{
    if (_currentScore == currentScore) {
        return;
    }
    
    // 如果当前评分 < 0
    if (currentScore < 0) {
        _currentScore = 0;
    } else if (currentScore > _numberOfStars) {
        _currentScore = _numberOfStars;
    } else {
        _currentScore = currentScore;
    }
    
    // 代理方法
    if ([self.delegate respondsToSelector:@selector(starView:currentScore:)]) {
        [self.delegate starView:self currentScore:_currentScore];
    }
    
    // block
    if (self.completionBlock) {
        _completionBlock(_currentScore);
    }
    
    [self setNeedsLayout];
}

@end
