//
//  FFChatBoxPic.m
//  SmartMesh
//
//  Created by Rain on 17/11/16.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFChatBoxPic.h"
#import "FFChatBoxPicCell.h"
#import "FFAppDelegate.h"

static NSString *cellID = @"FFChatBoxPicCellID";

@interface FFChatBoxPic ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) DDYButton *albumBtn;

@property (nonatomic, strong) DDYButton *orignBtn;

@property (nonatomic, strong) DDYButton *sendBtn;

@property (nonatomic, strong) UIViewController *currentVC;

@end

@implementation FFChatBoxPic

+ (instancetype)picBoxWithCurrentVC:(UIViewController *)vc {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DDYSCREENW, FFChatBoxFunctionViewH) currentVC:vc];
}

- (instancetype)initWithFrame:(CGRect)frame currentVC:(UIViewController *)vc {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:FFBackColor];
        [self setupContentView];
        [self loadData];
        self.currentVC = vc;
    }
    return self;
}

- (void)setupContentView {
    
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:DDYRect(0, 0, self.ddy_w, self.ddy_h-40) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = DDY_White;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[FFChatBoxPicCell class] forCellWithReuseIdentifier:cellID];
        [self addSubview:collectionView];
        collectionView;
    });
    
    
    [self addSubview:UIViewNew.viewSetFrame(0, self.ddy_h-40, self.ddy_w, 1).viewBGColor(DDYRGBA(100, 100, 100, 0.2))];
    
    _albumBtn = ({
        DDYButton *button = DDYButtonNew.btnFrame(10, self.ddy_h-39, 52, 39).btnTitleN(DDYLocalStr(@"Album"));
        button.btnAction(self, @selector(selectFromAlbum:)).btnTitleColorN(DDY_Blue).btnFont(DDYFont(17)).btnSuperView(self);
    });
    
    _orignBtn = ({
        UIImage *imgN = [UIImage circleBorderWithColor:DDY_Blue radius:8];
        UIImage *imgS = [UIImage circleImageWithColor :DDY_Blue radius:8];
        DDYButton *button = DDYButtonNew.btnFrame(_albumBtn.ddy_right+15,_albumBtn.ddy_y, 52, 39).btnFont(DDYFont(17));
        button.btnTitleN(DDYLocalStr(@"Album")).btnTitleColorN(DDY_Blue).btnImageN(imgN).btnImageS(imgS);
        button.btnAction(self, @selector(selectOriginalPhoto:)).btnSuperView(self).btnLayoutStyle(DDYBtnStyleImgLeft).btnPadding(3);
    });
    _orignBtn.hidden = YES; // 暂时不需要
    
    _sendBtn = ({
        DDYButton *button = DDYButtonNew.btnBgColor(FF_MAIN_COLOR).btnTitleN(DDYLocalStr(@"Send")).btnTitleColorN(DDY_White).btnFont(DDYFont(16));
        button.btnAction(self, @selector(handleSend:)).btnSuperView(self).btnFrame(DDYSCREENW-50-10,_albumBtn.ddy_y+8,50,26);
    });
    _sendBtn.enabled = NO;
    [_sendBtn setBackgroundImage:[UIImage imageWithColor:FF_MAIN_COLOR size:CGSizeMake(50, 26)] forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:[UIImage imageWithColor:DDY_LightGray size:CGSizeMake(50, 26)] forState:UIControlStateDisabled];
    DDYBorderRadius(_sendBtn, 3, 0, DDY_ClearColor);
}

- (void)selectFromAlbum:(DDYButton *)sender {
    NSInteger maxCount = 9;
    TZImagePickerController * imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:nil];
    imagePickerVc.isSelectOriginalPhoto = YES; 
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    __weak __typeof__(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (weakSelf.selectedBlock) {
            weakSelf.selectedBlock(photos);
        }
    }];
    
    [[FFAppDelegate rootViewController] presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)selectOriginalPhoto:(DDYButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - UICollectionViewDataSource Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FFChatBoxPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    __weak __typeof__(self) weakSelf = self;
    cell.selectBlock = ^(BOOL isSelected) {
        [weakSelf.collectionView reloadData];
    };
    cell.swipeToSendBlock = ^(UIImage *image) {
        [weakSelf sendImg:image];
    };
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
#pragma mark   定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FFchatBoxPicModel *model = self.dataArray[indexPath.row];
    [self judgeSelected];
    return CGSizeMake([self getWidthWithAsset:model.asset], collectionView.ddy_h);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 预览
    FFchatBoxPicModel *model = self.dataArray[indexPath.row];
    DDYPreviewController *vc = [[DDYPreviewController alloc] initWithImage:model.image finishBtnTitle:DDYLocalStr(@"Send") delegate:self];
    [self.currentVC.navigationController pushViewController:vc animated:YES];
}

- (void)loadData {
    
    NSMutableArray *assetArray = [PHAsset latestAsset:10];
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (PHAsset *asset in assetArray)
    {
        FFchatBoxPicModel *model = [[FFchatBoxPicModel alloc] init];
        model.selected = NO;
        model.asset = asset;
        [modelArray addObject:model];
    }
    
    self.dataArray = modelArray;
    [self.collectionView reloadData];
}

- (void)reloadData {
    [self loadData];
}

#pragma mark 私有方法
#pragma mark 获取图片及图片尺寸的相关方法
- (CGFloat)getWidthWithAsset:(PHAsset *)asset
{
    CGFloat width  = (CGFloat)asset.pixelWidth;
    CGFloat height = (CGFloat)asset.pixelHeight;
    CGFloat scale = MAX(0.5, width/height);
    return MIN(_collectionView.ddy_h*scale, DDYSCREENW*3/4);
}

- (void)handleSend:(DDYButton *)sender {
    NSMutableArray *imgArray = [NSMutableArray array];
    for (FFchatBoxPicModel *model in self.dataArray) {
        if (model.selected) {
            [imgArray addObject:model.image];
        }
    }
    if (self.selectedBlock) {
        self.selectedBlock(imgArray);
    }
    for (FFchatBoxPicModel *model in self.dataArray) {
        if (model.selected) {
            model.selected = NO;
        }
    }
    [self.collectionView reloadData];
}

- (void)judgeSelected {
    _sendBtn.enabled = NO;
    for (FFchatBoxPicModel *model in self.dataArray) {
        if (model.selected) {
            _sendBtn.enabled = YES;
        }
    }
}

#pragma mark DDYPreviewDelegate
- (void)ddy_PreviewController:(UIViewController *)vc image:(UIImage *)image {
    [self sendImg:image];
    if (![vc.navigationController popViewControllerAnimated:YES]) {
        [vc dismissViewControllerAnimated:YES completion:^{ }];
    }
}

- (void)sendImg:(UIImage *)image {
    NSMutableArray *imgArray = [NSMutableArray array];
    [imgArray addObject:image];
    
    if (self.selectedBlock) {
        self.selectedBlock(imgArray);
    }
    for (FFchatBoxPicModel *model in self.dataArray) {
        if (model.selected) {
            model.selected = NO;
        }
    }
    [self.collectionView reloadData];
}

@end
