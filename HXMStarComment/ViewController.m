//
//  ViewController.m
//  HXMStarComment
//
//  Created by HXM on 2017/5/5.
//  Copyright © 2017年 HXM. All rights reserved.
//

#import "ViewController.h"
#import "HXMStarView.h"

@interface ViewController ()<
HXMStarViewDelegate>
{
    HXMStarView *starView1;
    HXMStarView *starView2;
    HXMStarView *starView3;
    HXMStarView *starView4;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupView1];
    [self setupView2];
    [self setupView3];
    [self setupView4];
}

- (void)setupView1
{
    CGRect frame = CGRectMake(0, 100, self.view.frame.size.width, 40);
    starView1 = [[HXMStarView alloc] initWithFrame:frame];
    // 动画
    starView1.isAnimation = YES;
    // 代理
    starView1.delegate = self;
    // 添加
    [self.view addSubview:starView1];
}

- (void)setupView2
{
    CGRect frame = CGRectMake(0, 160, self.view.frame.size.width, 40);
    starView2 = [[HXMStarView alloc] initWithFrame:frame
                                     numberOfStars:3
                                         rateStyle:WholeStar
                                       isAnimation:YES
                                          delegate:self];
    [self.view addSubview:starView2];
}

- (void)setupView3
{
    CGRect frame = CGRectMake(0, 220, self.view.frame.size.width, 40);
    starView3 = [[HXMStarView alloc] initWithFrame:frame finishBlock:^(CGFloat currentScore) {
        NSLog(@"starView 333 ---> %.f",currentScore);
    }];
    
    [self.view addSubview:starView3];
}

- (void)setupView4
{
    CGRect frame = CGRectMake(0, 280, self.view.frame.size.width, 40);
    starView4 = [[HXMStarView alloc] initWithFrame:frame
                                     numberOfStars:5
                                         rateStyle:IncompleteStar
                                       isAnimation:YES
                                       finishBlock:^(CGFloat currentScore) {
                                           NSLog(@"starView 444 ---> %.1f",currentScore);
                                       }];
    [self.view addSubview:starView4];
}

#pragma mark - HXMStarViewDelegate

- (void)starView:(HXMStarView *)starView currentScore:(CGFloat)currentScore
{
    if (starView == starView1) {
        NSLog(@"starView 111 ---> %.f",currentScore);
    } else if (starView == starView2){
        NSLog(@"starView 222 ---> %.f",currentScore);
    }
}

@end
