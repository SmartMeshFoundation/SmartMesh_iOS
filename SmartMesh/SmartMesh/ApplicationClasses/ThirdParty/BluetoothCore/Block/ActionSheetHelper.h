//  Created by R on 18/3/20.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RIButtonItem.h"
@interface ActionSheetHelper : NSObject

+(void)showSheetInView:(UIView*)view  sheetTitle:(NSString*)title otherTitle:(NSString*)otherTitle otherAction:(void (^)(void))otherAction otherFunTitle:(NSString*)otherFunTitle otherFunAction:(void (^)(void))funAction;


+(void)showSheetInView:(UIView*)view cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction;

+(void)showSheetInView:(UIView*)view confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction;

+(void)showSheetInView:(UIView*)view actions:(NSArray*)actions;

@end
