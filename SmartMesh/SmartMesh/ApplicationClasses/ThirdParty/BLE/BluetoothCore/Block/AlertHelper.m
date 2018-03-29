//  Created by R on 18/3/13.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import "AlertHelper.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
@implementation AlertHelper

/**
 *  UIAlertView信息提示,默认标题为:温馨提示，确认按钮标题为：我知道了
 *
 *  @param msg 提示内容
 */
+(void)showAlertWithMessage:(NSString *)msg{
    
    RIButtonItem *button=[RIButtonItem item];
    button.label=@"我知道了";
    button.action=nil;
    
    UIAlertView *alter=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:msg cancelButtonItem:button otherButtonItems:nil, nil];
    [alter show];
}

/**
 *  UIAlertView信息提示,默认标题为:温馨提示，确认按钮标题为：我知道了
 *
 *  @param msg           提示内容
 *  @param confirmAction 确认触发事件
 */
+(void)showAlertWithMessage:(NSString *)msg confirmAction:(void (^)(void))confirmAction{
    RIButtonItem *button=[RIButtonItem item];
    button.label=@"我知道了";
    button.action=confirmAction;
    
    UIAlertView *alter=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:msg cancelButtonItem:button otherButtonItems:nil, nil];
    [alter show];
}

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
+(UIAlertView *)showAlertWithTitle:(NSString*)title message:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction{
    RIButtonItem *cancel=[RIButtonItem item];
    cancel.label=cancelTitle;
    cancel.action=cancelAction;
    
    RIButtonItem *confirm=[RIButtonItem item];
    confirm.label=confirmTitle;
    confirm.action=confirmAction;
    
    UIAlertView *alter=[[UIAlertView alloc] initWithTitle:title message:inMessage cancelButtonItem:nil otherButtonItems:cancel, confirm, nil];
    
    [alter show];
    return alter;
}

/**
 *  UIAlertView信息提示
 *  @param title         标题
 *  @param msg           提示内容
 *  @param confirmTitle  确认按钮标题
 *  @param confirmAction 确认触发事件
 */
+(void)showAlertWithTitle:(NSString*)title message:(NSString *)msg confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction{
    RIButtonItem *confirm=[RIButtonItem item];
    confirm.label=confirmTitle;
    confirm.action=confirmAction;

    UIAlertView *alter=[[UIAlertView alloc] initWithTitle:title message:msg cancelButtonItem:nil otherButtonItems:confirm, nil];
    [alter show];
}

+(UIAlertView *)showAlertWithMessage:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction{
    return [self showAlertWithTitle:@"温馨提醒" message:inMessage cancelTitle:cancelTitle cancelAction:cancelAction confirmTitle:confirmTitle confirmAction:confirmAction];
}

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
+(UIAlertView *)showAlerInCustomUItWithTitle:(NSString*)title message:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction {
    RIButtonItem *cancel = [RIButtonItem item];
    cancel.label = cancelTitle;
    cancel.action = cancelAction;
    
    RIButtonItem *confirm = [RIButtonItem item];
    confirm.label = confirmTitle;
    confirm.action = confirmAction;
    
    NSMutableString *tempString = [NSMutableString stringWithFormat:@"%@\n\n\n\n", inMessage];
    
    UIAlertView *alter=[[UIAlertView alloc] initWithTitle:title message:@"" cancelButtonItem:nil otherButtonItems:cancel, confirm, nil];
    
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]};
    CGRect rect = [tempString boundingRectWithSize:CGSizeMake(230.0f, CGFLOAT_MAX)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attr
                                    context:nil];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textColor = [UIColor clearColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.text = tempString;
    [alter setValue:textLabel forKey:@"accessoryView"];
    
    UILabel *textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 230, rect.size.height)];
    textLabel2.font = [UIFont systemFontOfSize:15];
    textLabel2.textColor = [UIColor blackColor];
    textLabel2.backgroundColor = [UIColor clearColor];
    textLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel2.numberOfLines = 0;
    textLabel2.textAlignment = NSTextAlignmentLeft;
    textLabel2.text = tempString;
    [textLabel addSubview:textLabel2];
    
    [alter show];
    return alter;
}

@end
