//
//  LeftSettingViewController.m
//  FoodMemory
//
//  Created by morplcp on 15/12/4.
//  Copyright © 2015年 morplcp. All rights reserved.
//

#import "LeftSettingViewController.h"

@interface LeftSettingViewController ()

@end

@implementation LeftSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RgbColor(255, 255, 255);
}

- (void)setTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kWindowHeight - 90)];
    topView.backgroundColor = RgbColor(255, 255, 255);
    [self.view addSubview:topView];
}

- (void)setPlayerView{
    UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 90, self.view.frame.size.width, 90)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bac.jpg"]];
    imgView.frame = CGRectMake(0, 0, kWindowWidth, 90);
    playerView.backgroundColor = RgbColor(231, 231, 231);
    self.btnLast = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _btnLast.frame = CGRectMake(30, 30, 30, 30);
    _btnLast.backgroundColor = [UIColor clearColor];
    [_btnLast setBackgroundImage:[UIImage imageNamed:@"rewind_54.920245398773px_1187724_easyicon.net.png"] forState:(UIControlStateNormal)];
    self.btnPlayOrPause = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _btnPlayOrPause.frame = CGRectMake((playerView.frame.size.width - 30) / 2.0, 30, 30, 30);
    [_btnPlayOrPause setBackgroundImage:[UIImage imageNamed:@"pauze_34.159509202454px_1187701_easyicon.net"] forState:(UIControlStateNormal)];
    _btnPlayOrPause.backgroundColor = [UIColor clearColor];
    self.btnNext = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _btnNext.frame = CGRectMake(self.view.frame.size.width - 60, 30, 30, 30);
    _btnNext.backgroundColor = [UIColor clearColor];
    [_btnNext setBackgroundImage:[UIImage imageNamed:@"forward_54.920245398773px_1187658_easyicon.net.png"] forState:(UIControlStateNormal)];
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, -5, playerView.frame.size.width, 10)];
    [slider setThumbTintColor:[UIColor clearColor]];
    [playerView addSubview:imgView];
    [playerView addSubview:slider];
    [playerView addSubview:_btnNext];
    [playerView addSubview:_btnPlayOrPause];
    [playerView addSubview:_btnLast];
    [self.view addSubview:playerView];
    [self setAction];
}

- (void)setAction{
    [_btnLast addTarget:self action:@selector(actionLast) forControlEvents:(UIControlEventTouchUpInside)];
    [_btnNext addTarget:self action:@selector(actionNext) forControlEvents:(UIControlEventTouchUpInside)];
    [_btnPlayOrPause addTarget:self action:@selector(actionPlayOrPause:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)actionLast{
    
}

- (void)actionNext{
    
}

- (void)actionPlayOrPause:(UIButton *)sender{
    static int i = 0;
    if (i == 0) {
        [_btnPlayOrPause setBackgroundImage:[UIImage imageNamed:@"play_37.546012269939px_1187706_easyicon.net.png"] forState:(UIControlStateNormal)];
        i = 1;
    }else{
        [_btnPlayOrPause setBackgroundImage:[UIImage imageNamed:@"pauze_34.159509202454px_1187701_easyicon.net"] forState:(UIControlStateNormal)];
        i = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setTopView];
        [self setPlayerView];
    });
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
