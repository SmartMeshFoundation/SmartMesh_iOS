//
//  DDYWaveVC.m
//  DDYProject
//
//  Created by LingTuan on 17/9/15.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYWaveVC.h"

@interface DDYWaveVC ()

@end

@implementation DDYWaveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    DDYWaveView *waveView = [[DDYWaveView alloc] initWithFrame:CGRectMake(0, 144, DDYSCREENW, 20)];
    [self.view addSubview:waveView];
    waveView.callBack = ^(CGFloat frontY, CGFloat insideY) {
        DDYLog(@"%f\n%f",frontY, insideY);
    };
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 164, DDYSCREENW, DDYSCREENH)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
}

@end
