//
//  DDYVoiceChangePlayView.m
//  DDYProject
//
//  Created by LingTuan on 17/11/27.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYVoiceChangePlayView.h"
#import "DDYVoiceChangePlayCell.h"
#import "DDYRecordModel.h"
#import "DDYAudioChange.h"

static NSString *cellID = @"cellID";

static inline UIImage* strectchImg(NSString *imgName) { return [voiceImg(imgName) resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 1, 1)];}

@interface DDYVoiceChangePlayView ()<UICollectionViewDataSource, UICollectionViewDelegate>
/** 取消按钮 */
@property (nonatomic, strong) DDYButton *cancelBtn;
/** 发送按钮 */
@property (nonatomic, strong) DDYButton *sendBtn;
/** 声音转换线程 */
@property (nonatomic, strong) NSOperationQueue *soundTouchQueue;
/** 展示选项collection */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DDYVoiceChangePlayView

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self setupSendBtnAndCancelBtn];
    }
    return self;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSArray *items = @[@{@"title":@"ChangeEffect0",@"pitch":@"0"},
                           @{@"title":@"ChangeEffect1",@"pitch":@"12"},
                           @{@"title":@"ChangeEffect2",@"pitch":@"-7"},
                           @{@"title":@"ChangeEffect3",@"pitch":@"-12"},
                           @{@"title":@"ChangeEffect4",@"pitch":@"3"},
                           @{@"title":@"ChangeEffect5",@"pitch":@"7"}];
        for (NSDictionary *dict in items) {
            [_dataSource addObject:[DDYVoiceChangeModel modelWithDict:dict]];
        }
    }
    return _dataSource;
}

#pragma mark 声音转换线程
- (NSOperationQueue *)soundTouchQueue {
    if (!_soundTouchQueue) {
        _soundTouchQueue = [[NSOperationQueue alloc] init];
        _soundTouchQueue.maxConcurrentOperationCount = 1;
    }
    return _soundTouchQueue;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:DDYRect(0, 0, self.ddy_w, self.ddy_h-40) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = DDY_White;
        
        [_collectionView registerClass:[DDYVoiceChangePlayCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

- (void)setupSendBtnAndCancelBtn {
    _cancelBtn = DDYButtonNew.btnFrame(0,self.ddy_h-40,self.ddy_w/2,40).btnTitleN(DDYLocalStr(@"Cancel")).btnTitleColorN(kSelectColor);
    _cancelBtn.btnFont(DDYFont(17)).btnAction(self,@selector(btnClick:)).btnBgImageN(strectchImg(@"PlayCancelN"));
    _cancelBtn.btnBgImageH(strectchImg(@"PlayCancelH")).btnSuperView(self);
    
    _sendBtn = DDYButtonNew.btnFrame(self.ddy_w/2,self.ddy_h-40,self.ddy_w/2,40).btnTitleN(DDYLocalStr(@"Send")).btnTitleColorN(kSelectColor);
    _sendBtn.btnFont(DDYFont(17)).btnAction(self,@selector(btnClick:)).btnBgImageN(strectchImg(@"PlaySendN"));
    _sendBtn.btnImageH(strectchImg(@"PlaySendH")).btnSuperView(self);
}

#pragma mark - UICollectionViewDataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

#pragma mark   cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDYVoiceChangePlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.item];
    return cell;
}

- (void)btnClick:(DDYButton *)sender {
    
    
}

#pragma mark 变声功能
- (void)soundChangeWithPitch:(int)pitch {
    NSData *data = [NSData dataWithContentsOfFile:[DDYFileTool ddy_RecordPath]];
    DDYACConfig config = DDYACMake(11025, 0, pitch, 0);
    DDYAudioChange *change = [DDYAudioChange changeConfig:config audioData:data target:self action:@selector(playChange)];
    [_soundTouchQueue cancelAllOperations];
    [_soundTouchQueue addOperation:change];
}

- (void)playChange {
    [[DDYAudioManager sharedManager] ddy_PlayAudio:[DDYFileTool ddy_SoundTouchPath]];
}

@end
