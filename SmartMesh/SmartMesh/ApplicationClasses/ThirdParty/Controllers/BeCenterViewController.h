//  Created by R on 18/3/6.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BeCenterViewController : BaseViewController

//发送控件
@property (weak, nonatomic) IBOutlet UITextField *txtView;    //发送文本
@property (weak, nonatomic) IBOutlet UILabel *labFileName;  //发送文件名
@property (weak, nonatomic) IBOutlet UIProgressView *progressView; //发送进度条
@property (weak, nonatomic) IBOutlet UILabel *labProgress; //发送进度

//接收控件
@property (weak, nonatomic) IBOutlet UITextView *receiveTxtView;  //接收文本
@property (weak, nonatomic) IBOutlet UILabel *labReceiveFileName; //接收文件名
@property (weak, nonatomic) IBOutlet UILabel *labReceiveProgress; //接收进度
@property (weak, nonatomic) IBOutlet UIProgressView *receiveProgressView; //接收进度条
@property (weak, nonatomic) IBOutlet UIImageView *receiveImageView; //接收显示的图片


//发送文本
- (IBAction)sendTextClick:(id)sender;
//发送图片
- (IBAction)sendImageClick:(id)sender;


@end

