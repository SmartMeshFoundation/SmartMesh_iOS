//
//  DDYVoiceBoxVC.m
//  DDYProject
//
//  Created by LingTuan on 17/11/23.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYVoiceBoxVC.h"

@interface DDYVoiceBoxVC ()

@end

@implementation DDYVoiceBoxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    DDYVoiceBox *box = [DDYVoiceBox voiceBox];
    box.backgroundColor = DDY_White;
    [self.view addSubview:box];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = DDY_LightGray;
}

@end
