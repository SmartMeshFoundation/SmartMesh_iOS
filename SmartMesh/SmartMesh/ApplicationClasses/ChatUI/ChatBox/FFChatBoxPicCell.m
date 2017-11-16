//
//  FFChatBoxPicCell.m
//  SmartMesh
//
//  Created by Rain on 17/11/16.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFChatBoxPicCell.h"

//------------------- 模型 -------------------//
@implementation FFchatBoxPicModel

+ (PHImageRequestOptions *)imageRequestOptions {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    imageRequestOptions.synchronous = NO;
    return imageRequestOptions;
}

+ (void)cacheImagesForAssets:(NSArray<PHAsset *> *)assets {
    PHCachingImageManager *cachingImageManager = [[PHCachingImageManager alloc] init];
    [cachingImageManager startCachingImagesForAssets:assets
                                          targetSize:PHImageManagerMaximumSize
                                         contentMode:PHImageContentModeAspectFill
                                             options:[FFchatBoxPicModel imageRequestOptions]];
}

+ (void)requestImageForAsset:(PHAsset *)asset callback:(void (^)(UIImage *image))callback {
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:[FFchatBoxPicModel targetSize:asset]
                                              contentMode:PHImageContentModeAspectFill
                                                  options:[FFchatBoxPicModel imageRequestOptions]
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if (callback) callback(result);
                                                });
                                            }];
}

+ (CGSize)targetSize:(PHAsset *)asset {
    return CGSizeMake(ceilf(FFChatBoxFunctionViewH*asset.pixelWidth/asset.pixelHeight), FFChatBoxFunctionViewH);
}

#pragma mark 请求得到规定大小图片
+ (void)requestImageForAsset:(PHAsset *)asset size:(CGSize)size callback:(void (^)(UIImage *image))callback {
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                      targetSize:size
                                                     contentMode:PHImageContentModeAspectFit
                                                         options:imageRequestOptions
                                                   resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
        // 不要该判断，即如果该图片在iCloud上时候，会先显示一张模糊的预览图，待加载完毕后会显示高清图
        // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]
        if (downloadFinined && callback) {
            callback(image);
        }}];
}

@end

//------------------- cell -------------------//
@interface FFChatBoxPicCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) DDYButton *selectBtn;

@property (nonatomic, assign) CGFloat relationWindowY;

@end

@implementation FFChatBoxPicCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.selectBtn.frame = CGRectMake(self.ddy_w-28, 6, 24, 24);
    
    self.relationWindowY = [self.imageView relationToWindow].origin.y;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageView addLongGestureTarget:self action:@selector(longPress:) minDuration:0.1];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (DDYButton *)selectBtn {
    if (!_selectBtn) {
        UIImage *imgN = [UIImage circleBorderWithColor:DDY_Blue radius:11];
        UIImage *imgS = [UIImage circleImageWithColor :DDY_Blue radius:11];
        _selectBtn = [DDYButton customDDYBtn].btnImageN(imgN).btnImageS(imgS).btnAction(self,@selector(handleSelect:));
        DDYBorderRadius(_selectBtn, 12, 1, DDY_White);
        [self.contentView addSubview:_selectBtn];
    }
    return _selectBtn;
}

- (void)setModel:(FFchatBoxPicModel *)model {
    _model = model;
    __weak __typeof__(self) weakSelf = self;
    _selectBtn.selected = model.isSelected;
    
    if (model.image) {
        self.imageView.image = model.image;
    } else {
        [FFchatBoxPicModel requestImageForAsset:model.asset size:CGSizeMake(self.ddy_w*2.5, self.ddy_h*2.5) callback:^(UIImage *image) {
            weakSelf.imageView.image = image;
            model.image = image;
        }];
    }
}

- (void)handleSelect:(DDYButton *)sender {
    sender.selected = !sender.selected;
    _model.selected = sender.selected;
    if (self.selectBlock) {
        self.selectBlock(sender.selected);
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    if (!keyWindow) keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        CGRect rect = [self.imageView relationToWindow];
        [keyWindow addSubview:self.imageView];
        self.imageView.frame = rect;
        self.selectBtn.hidden = YES;
        
    } else if (longPress.state == UIGestureRecognizerStateChanged) {
    
        self.imageView.ddy_centerY = [longPress locationInView:keyWindow].y;
        
    } else if (longPress.state == UIGestureRecognizerStateEnded) {
        
        if (self.relationWindowY-self.imageView.ddy_y>FFChatBoxFunctionViewH/2 && self.swipeToSendBlock) {
            self.swipeToSendBlock(self.model.image);
        }
        [self.imageView removeFromSuperview];
        [self.contentView addSubview:self.imageView];
        self.imageView.ddy_y = 0;
        self.imageView.ddy_x = 0;
        self.selectBtn.hidden = NO;
        [self.contentView bringSubviewToFront:self.selectBtn];
    }
}

@end
