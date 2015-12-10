//
//  ShowHDImage.m
//  FoodMemory
//
//  Created by morplcp on 15/12/10.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "ShowHDImage.h"

@implementation ShowHDImage

- (instancetype)initWithImageURL:(NSString *)url{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:tap];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView sd_setImageWithURL:[NSURL URLWithString:url]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addSubview:imgView];
        });
    }
    return self;
}

- (void)show{
    [UIView transitionWithView:self duration:0.1 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)close{
    __weak typeof(self)vc = self;
    [UIView transitionWithView:self duration:0.1 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        vc.alpha = 0;
    } completion:^(BOOL finished) {
        [vc removeFromSuperview];
    }];
}

@end
