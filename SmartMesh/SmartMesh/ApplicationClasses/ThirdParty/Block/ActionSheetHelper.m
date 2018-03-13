//  Created by R on 18/3/13.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import "ActionSheetHelper.h"
#import "UIActionSheet+Blocks.h"
@implementation ActionSheetHelper


+(void)showSheetInView:(UIView*)view  sheetTitle:(NSString*)title otherTitle:(NSString*)otherTitle otherAction:(void (^)(void))otherAction otherFunTitle:(NSString*)otherFunTitle otherFunAction:(void (^)(void))funAction{

    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=@"取消";
    canBtn.action=nil;
    
    RIButtonItem *otherBtn1=[RIButtonItem item];
    otherBtn1.label=otherTitle;
    otherBtn1.action=otherAction;
    
    RIButtonItem *otherBtn2=[RIButtonItem item];
    otherBtn2.label=otherFunTitle;
    otherBtn2.action=funAction;
    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:title cancelButtonItem:canBtn destructiveButtonItem:nil otherButtonItems:otherBtn1,otherBtn2, nil];
    [sheet showInView:view];

}

+(void)showSheetInView:(UIView*)view cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction{
    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=cancelTitle;
    canBtn.action=cancelAction;
    
    RIButtonItem *viewerBtn=[RIButtonItem item];
    viewerBtn.label=confirmTitle;
    viewerBtn.action=confirmAction;
    
   
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:canBtn destructiveButtonItem:nil otherButtonItems:viewerBtn, nil];
    [sheet showInView:view];
}
+(void)showSheetInView:(UIView*)view confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction{
    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=@"取消";
    canBtn.action=nil;
    
    RIButtonItem *viewerBtn=[RIButtonItem item];
    viewerBtn.label=confirmTitle;
    viewerBtn.action=confirmAction;
    
    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:canBtn destructiveButtonItem:nil otherButtonItems:viewerBtn, nil];
    [sheet showInView:view];
}
+(void)showSheetInView:(UIView*)view actions:(NSArray*)actions{
    RIButtonItem *canBtn=[RIButtonItem item];
    canBtn.label=@"取消";
    canBtn.action=nil;
    
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:canBtn destructiveButtonItem:nil otherButtonItems:nil, nil];
    for (RIButtonItem *item in actions) {
        [sheet addButtonItem:item];
    }
    [sheet showInView:view];
}
@end
