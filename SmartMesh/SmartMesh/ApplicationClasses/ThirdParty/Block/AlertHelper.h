//  Created by R on 18/3/13.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertHelper : NSObject

/**
 *  UIAlertView信息提示,默认标题为:温馨提示，确认按钮标题为：我知道了
 *
 *  @param msg 提示内容
 */
+(void)showAlertWithMessage:(NSString *)msg;

/**
 *  UIAlertView信息提示,默认标题为:温馨提示，确认按钮标题为：我知道了
 *
 *  @param msg           提示内容
 *  @param confirmAction 确认触发事件
 */
+(void)showAlertWithMessage:(NSString *)msg confirmAction:(void (^)(void))confirmAction;

/**
 *  UIAlertView信息提示
 *  @param title         标题
 *  @param msg           提示内容
 *  @param confirmTitle  确认按钮标题
 *  @param confirmAction 确认触发事件
 */
+(void)showAlertWithTitle:(NSString*)title message:(NSString *)msg confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction;


/**
 *  UIAlertView信息提示
 *
 *  @param title         标题
 *  @param inMessage     提示内容
 *  @param cancelTitle   取消按钮标题
 *  @param cancelAction  取消按钮事件
 *  @param confirmTitle  确认按钮标题
 *  @param confirmAction 确认按钮事件
 */
+(UIAlertView *)showAlertWithTitle:(NSString*)title message:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction;

/**
 *  UIAlertView信息提示
 *
 *  @param inMessage     提示内容
 *  @param cancelTitle   取消按钮标题
 *  @param cancelAction  取消按钮事件
 *  @param confirmTitle  确认按钮标题
 *  @param confirmAction 确认按钮事件
 */
+(UIAlertView *)showAlertWithMessage:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction;

/**
 *  UIAlertView信息提示(内容自定义显示，左对齐)
 *
 *  @param title         标题
 *  @param inMessage     提示内容
 *  @param cancelTitle   取消按钮标题
 *  @param cancelAction  取消按钮事件
 *  @param confirmTitle  确认按钮标题
 *  @param confirmAction 确认按钮事件
 */
+(UIAlertView *)showAlerInCustomUItWithTitle:(NSString*)title message:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction;

@end
