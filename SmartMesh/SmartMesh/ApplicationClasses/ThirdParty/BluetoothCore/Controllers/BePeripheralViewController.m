//  Created by R on 18/3/6.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import "BePeripheralViewController.h"
#import "BLEPeripheralManager.h"
#import "UEBaseData.h"
#import "SVProgressHUD.h"
#import "AlbumCameraImage.h"
#import "ActionSheetHelper.h"

@interface BePeripheralViewController ()<AlbumCameraDelegate>{
   __block UEBaseData *_receiveDataModel;    //接收数据
   __block UEBaseData *_sendingDataModel; //发送数据
}
/**
 *  图片选择
 */
@property (nonatomic,strong) AlbumCameraImage *albumCamera;
@end

@implementation BePeripheralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据初始化
    [self dataInit];
    
    //设置服务
    [[BLEPeripheralManager shareInstance] startService];
    
    //蓝牙状态(对应通知kBLEStateChangedNotification)
    [[BLEPeripheralManager shareInstance] setStateChangedBlock:^(BLEState bleState){
        
        if (bleState!=BLEStateOpen) {
            [SVProgressHUD showInView:self.view];
            [SVProgressHUD dismissWithError:@"蓝牙未开启" afterDelay:2.0f];
        }
        
    }];
    
    //接收数据处理(或者监听通知kBLEPeripheralReceivePartialDataNotification)
    [[BLEPeripheralManager shareInstance] setReceivePartialDataBlock:^(NSData *receiveData) {
        [self handlerReceiveData:receiveData];
    }];
    
    //发送数据处理(或者监听通知kBLEPeripheralWritePartialDataNotification)
    [[BLEPeripheralManager shareInstance] setWritePartialDataBlock:^(NSData *writeData) {
        [self handlerWriteData:writeData];
    }];
    
}

#pragma mark -发送数据处理

/**
 * 处理发送的数据
 *
 *  @param writeData
 */
- (void)handlerWriteData:(NSData *)writeData{
    if (_sendingDataModel==nil) {
        //解析发送的数据
        _sendingDataModel=[UEBaseData decodeWithData:writeData];
        
        if (_sendingDataModel.packetId==2) {
            //更新发送进度
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat progress=[_sendingDataModel progress];
                self.progressView.progress=progress;
                self.labProgress.text=[NSString stringWithFormat:@"%.1f%%",progress*100];
            });
            
        }
        
        //全部发送完成
        if (_sendingDataModel&&[_sendingDataModel isFinished]) {
            _sendingDataModel=nil;
        }
        
        return;
    }
    
    //添加未发送完的数据
    if (_sendingDataModel) {
        [_sendingDataModel addReadData:writeData];
    }
    
    
    if (_sendingDataModel&&_sendingDataModel.packetId==2) {
        //更新发送进度
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat progress=[_sendingDataModel progress];
            self.progressView.progress=progress;
            self.labProgress.text=[NSString stringWithFormat:@"%.1f%%",progress*100];
        });
    }
    
    //全部发送完成
    if (_sendingDataModel&&[_sendingDataModel isFinished]) {
        self.labFileName.text=@"";
        _sendingDataModel=nil;
    }

}


#pragma mark -接收数据处理

/**
 *  处理接收的数据
 *
 *  @param receiveData
 */
- (void)handlerReceiveData:(NSData *)receiveData{
    NSLog(@"wai wei she bei shou dao data:\n%@", [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding]);
    if (!_receiveDataModel) {
        _receiveDataModel=[UEBaseData decodeWithData:receiveData];
        
        //显示接收的数据
        [self showReceiveDataWithModel:_receiveDataModel completed:^{
            _receiveDataModel=nil;
        }];
        
        return;
    }
    
    if (_receiveDataModel) {
        [_receiveDataModel addReadData:receiveData];
    }
    
    //显示接收的数据
    [self showReceiveDataWithModel:_receiveDataModel completed:^{
        _receiveDataModel=nil;
    }];
}

//显示接收的数据
- (void)showReceiveDataWithModel:(UEBaseData *)mod completed:(void (^)())finished{
    
    if (mod&&mod.packetId==2) {
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labReceiveFileName.text=[mod getExtString];
            CGFloat progress=[mod progress];
            self.receiveProgressView.progress=progress;
            self.labReceiveProgress.text=[NSString stringWithFormat:@"%.1f%%",progress*100];
        });
    }
    
    
    if (mod&&[mod isFinished]) { //全部读取完成
        
        if (mod.packetId==1) { //表示文本
            NSString *str=[[NSString alloc] initWithData:mod.bodyData encoding:NSUTF8StringEncoding];
            self.receiveTxtView.text=str;
            
            if (finished) {
                finished();
            }
        }
        else if (mod.packetId==2) { //表示图片
            //更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.receiveImageView.image=[UIImage imageWithContentsOfFile:[mod getCacheFilePath]];
                //_receiveDataModel=nil;
                
                if (finished) {
                    finished();
                }
            });
        }
    }
}

#pragma mark -初始化

/**
 *  数据初始化
 */
- (void)dataInit{
    self.receiveTxtView.layer.cornerRadius=5.0;
    self.receiveTxtView.layer.borderWidth=0.5;
    self.receiveTxtView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.receiveTxtView.layer.masksToBounds=YES;
    
    //失去焦点
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResponed:)];
    tapGr.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:tapGr];
    
    //1.图片选择处理
    self.albumCamera=[[AlbumCameraImage alloc] init];
    self.albumCamera.delegate=self;
    
    _receiveDataModel=nil;
    _sendingDataModel=nil;
}

#pragma mark -数据发送

//发送文本
- (IBAction)sendTextClick:(id)sender{
    
    NSString *content=self.txtView.text;
    if ([content length]==0) {
        [SVProgressHUD showInView:self.view];
        [SVProgressHUD dismissWithError:@"发送内容不为空" afterDelay:2.0f];
        return;
    }
    
    if ([BLEPeripheralManager shareInstance].state != BLEStateOpen) {
        [SVProgressHUD showInView:self.view];
        [SVProgressHUD dismissWithError:@"蓝牙未打开，请确保打开后再试。" afterDelay:2.0f];
        return;
    }
    
    NSData *sendData=[content dataUsingEncoding:NSUTF8StringEncoding];
    
    UEBaseData *mod=[[UEBaseData alloc] init];
    mod.packetId=1;
    mod.extStr=nil;
    [mod.bodyData appendData:sendData];
    //发送
    [[BLEPeripheralManager shareInstance] sendData:[mod encodeData]];

}
//发送图片
- (IBAction)sendImageClick:(id)sender{

    [ActionSheetHelper showSheetInView:self.view sheetTitle:@"选择图片" otherTitle:@"相册" otherAction:^{
        [self.albumCamera showAlbumInController:self];
    } otherFunTitle:@"拍照" otherFunAction:^{
        [self.albumCamera showCameraInController:self];
    }];
}

#pragma mark -AlbumCameraDelegate Methods
- (void)photoFromAlbumCameraWithImage:(UIImage*)image fromFileName:(NSString *)fileName{
    
    self.labFileName.text=fileName;
    
    NSData *data=nil;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    
    UEBaseData *mod=[[UEBaseData alloc] init];
    mod.packetId=2;
    mod.extStr=fileName;
    [mod.bodyData appendData:data];
    
    //发送图片
    [[BLEPeripheralManager shareInstance] sendData:[mod encodeData]];
    
}

#pragma mark -其它事件

//失去焦点
- (void)textFieldResponed:(UITapGestureRecognizer*)tapGr{
    [self.view endEditing:YES];
}

//重写返回事件
- (BOOL)isNavigationBack{
    //停止广播
    [[BLEPeripheralManager shareInstance] stopService];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
