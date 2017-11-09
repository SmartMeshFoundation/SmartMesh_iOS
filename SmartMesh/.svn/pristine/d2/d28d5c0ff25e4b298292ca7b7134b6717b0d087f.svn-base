//
//  DDYQRCodeScanResultVC.m
//  DDYProject
//
//  Created by LingTuan on 17/8/11.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYQRCodeScanResultVC.h"

@interface DDYQRCodeScanResultVC ()

@end

@implementation DDYQRCodeScanResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, DDYSCREENW-30, DDYSCREENH-64)];
    resultLabel.text = _resultStr;
    resultLabel.font = DDYFont(15);
    resultLabel.textAlignment = NSTextAlignmentLeft;
    resultLabel.numberOfLines = 0;
    resultLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    [resultLabel sizeToFit];
    [self.view addSubview:resultLabel];
}


@end
