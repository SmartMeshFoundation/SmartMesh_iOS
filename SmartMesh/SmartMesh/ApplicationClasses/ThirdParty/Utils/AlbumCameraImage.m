//  Created by R on 18/3/7.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import "AlbumCameraImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation AlbumCameraImage
-(void)showCameraInController:(UIViewController*)controller{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    //picker.allowsEditing=YES;//是否允許編輯
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        //[picker release];
        return;
    }
    [controller presentViewController:picker animated:YES completion:nil];
    //[picker release];
}
-(void)showAlbumInController:(UIViewController*)controller{
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    //picker.allowsEditing=YES;//是否允許編輯
   //相簿
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [controller presentViewController:picker animated:YES completion:^{}];
    //[picker release];
}

//取得随机文件名
- (NSString *)createRandomFileName{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *timestamp_str = [outputFormatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@.png",timestamp_str];
}


#pragma mark -
#pragma mark UIImagePickerController  Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block NSString *fileName=[self createRandomFileName];
    if(picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary){//相册
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            if ([representation filename]&&[[representation filename] length]>0) {
                fileName= [representation filename];
            }
            UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
            if (self.delegate&&[self.delegate respondsToSelector:@selector(photoFromAlbumCameraWithImage:fromFileName:)]) {
                [self.delegate photoFromAlbumCameraWithImage:image fromFileName:fileName];
            }
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:^(NSError *error) {
                          UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
                          if (self.delegate&&[self.delegate respondsToSelector:@selector(photoFromAlbumCameraWithImage:fromFileName:)]) {
                              [self.delegate photoFromAlbumCameraWithImage:image fromFileName:fileName];
                          }
                      }];
    
    }else{//拍照
        UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(photoFromAlbumCameraWithImage:fromFileName:)]) {
            [self.delegate photoFromAlbumCameraWithImage:image fromFileName:fileName];
        }
    }
   
	
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
