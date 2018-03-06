//  Created by R on 18/3/6.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 说明***
     
     1.蓝牙数据定义(根据自已的蓝牙数据规则做调整,类似tcp定义数据报)
     
        (1)规则为＝＝》指令码＋扩展字段长度＋扩展内容＋body长度+body内容
          
         (a.)指令码  1表示文本  2表示文件(包含图片)   字节长度为1
         (b.)扩展字段  字节长度为2
         (c.)body长度  字节长度为4
     
        (2)UEBaseData类用于封装与解码蓝牙数据,UEReadDataPack是辅助读取类
     
     2.蓝牙数据的发送
       (1)最大发送了节长度为20
       (2)BLEDataPack类处理分段发送数据,每次发送20个字节
     
     3.BluetoothCore文件夹下的内容是蓝牙核心代码
     
     4.如果你是对接第三方设备开发，只需要把BluetoothCore/Central 与 BluetoothCore/Common 文件夹拖到自已的项目中,在相应的调整就OK
     
     5.仅供思路与参考
     
     **/
    
    
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
