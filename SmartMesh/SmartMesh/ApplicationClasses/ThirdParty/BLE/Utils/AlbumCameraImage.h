//  Created by R on 18/3/7.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AlbumCameraDelegate <NSObject>
- (void)photoFromAlbumCameraWithImage:(UIImage*)image fromFileName:(NSString*)fileName;
@end

@interface AlbumCameraImage : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,assign) id<AlbumCameraDelegate> delegate;
-(void)showCameraInController:(UIViewController*)controller;
-(void)showAlbumInController:(UIViewController*)controller;
@end
