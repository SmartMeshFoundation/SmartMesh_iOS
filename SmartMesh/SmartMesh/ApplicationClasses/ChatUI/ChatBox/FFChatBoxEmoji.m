//
//  FFChatBoxEmoji.m
//  SmartMesh
//
//  Created by Rain on 17/11/16.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFChatBoxEmoji.h"
#import "FFEmotion.h"
#import "FFEmotionManager.h"

static NSString *FFEmojiCellID = @"FFEmojiCellID";
static NSString *FFEmojiHeadID = @"FFEmojiHeadID";

//----------------------------- 表情cell -----------------------------//
@interface FFEmojiCell : UICollectionViewCell

@property (nonatomic, strong) FFEmotion *emotion;

@property (nonatomic, strong) UILabel *emojiLabel;

@end

@implementation FFEmojiCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.emojiLabel];
    }
    return self;
}

- (UILabel *)emojiLabel {
    if (!_emojiLabel) {
        _emojiLabel = [[UILabel alloc] init];
        _emojiLabel.font = DDYSCREENW>320. ? DDYFont(30) : DDYFont(25);
        _emojiLabel.textAlignment = NSTextAlignmentCenter;
        _emojiLabel.frame = self.bounds;
    }
    return _emojiLabel;
}

- (void)setEmotion:(FFEmotion *)emotion {
    _emotion = emotion;
    if (![NSString ddy_blankString:emotion.code]) {
        self.emojiLabel.attributedText = [FFEmotionManager transferMessageString:emotion.code.emoji
                                                                        font:self.emojiLabel.font
                                                                  lineHeight:self.emojiLabel.font.lineHeight];
    } else {
        self.emojiLabel.attributedText = [FFEmotionManager transferMessageString:emotion.face_name
                                                                            font:DDYSCREENW>320. ? DDYFont(27) : DDYFont(25)
                                                                      lineHeight:DDYSCREENW>320. ? DDYFont(27).lineHeight : DDYFont(25).lineHeight];
    }
}

@end


//----------------------------- 表情视图 -----------------------------//

@interface FFChatBoxEmoji ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
/** 自定义表情切换按钮 */
@property (nonatomic, strong) DDYButton *customBtn;
/** emoji表情切换按钮 */
@property (nonatomic, strong) DDYButton *emojiBtn;

@property (nonatomic, strong) DDYButton *deleteBtn;

@end


@implementation FFChatBoxEmoji

+ (instancetype)emojiBox {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DDYSCREENW, FFChatBoxFunctionViewH)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:FFBackColor];
        [self setupContentView];
        [self loadData:0];
    }
    return self;
}

- (void)setupContentView {
    [self addSubview:self.collectionView];
    [self addSubview:self.customBtn];
    [self addSubview:self.emojiBtn];
    [self addSubview:self.deleteBtn];
    [self addSubview:UIViewNew.viewSetFrame(0, _collectionView.ddy_bottom, self.ddy_w, 1).viewBGColor(DDYRGBA(200, 200, 200, 0.2))];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 15, 20);
        layout.minimumInteritemSpacing = 5;
        layout.headerReferenceSize = CGSizeMake(DDYSCREENW, 15);
        layout.itemSize = DDYSCREENW>320 ? CGSizeMake(((DDYSCREENW-10)-15*8)/7., ((DDYSCREENW-10)-15*8)/7.) : CGSizeMake(((DDYSCREENW-10)-15*7)/6., ((DDYSCREENW-10)-15*7)/6.);
        _collectionView = [[UICollectionView alloc] initWithFrame:DDYRect(0, 0, self.ddy_w, self.ddy_h-40) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = DDY_White;
        [_collectionView registerClass:[FFEmojiCell class] forCellWithReuseIdentifier:FFEmojiCellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:FFEmojiHeadID];
    }
    return _collectionView;
}

- (DDYButton *)customBtn {
    if (!_customBtn) {
        _customBtn = DDYButtonNew.btnFrame(0,self.collectionView.ddy_bottom,60,40).btnImgNameN(@"[微笑]").btnAction(self,@selector(handleCustom:));
        [_customBtn setBackgroundImage:[UIImage imageWithColor:DDYRGBA(230, 230, 230, 1) size:CGSizeMake(60, 40)] forState:UIControlStateSelected];
        [_customBtn setBackgroundImage:[UIImage imageWithColor:DDY_White size:CGSizeMake(60, 40)] forState:UIControlStateNormal];
        _customBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 16, 6, 16);
        _customBtn.selected = YES;
    }
    return _customBtn;
}

- (DDYButton *)emojiBtn {
    if (!_emojiBtn) {
        NSString *emoji = @"0x1f603";
        _emojiBtn = DDYButtonNew.btnFrame(_customBtn.ddy_right,self.collectionView.ddy_bottom,60,40).btnTitleN(emoji.emoji).btnFont(DDYFont(28)).btnAction(self,@selector(handleEmoji:));
        [_emojiBtn setBackgroundImage:[UIImage imageWithColor:DDYRGBA(230, 230, 230, 1) size:CGSizeMake(60, 40)] forState:UIControlStateSelected];
        [_emojiBtn setBackgroundImage:[UIImage imageWithColor:DDY_White size:CGSizeMake(60, 40)] forState:UIControlStateNormal];
        _emojiBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 16, 6, 16);
        _emojiBtn.selected = NO;
    }
    return _emojiBtn;
}

- (DDYButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = DDYButtonNew.btnImgNameN(@"EmojiDelete").btnSuperView(self);
        _deleteBtn.btnAction(self, @selector(handleDelete:)).btnFrame(self.ddy_w-45-15, self.collectionView.ddy_bottom, 55, 40);
    }
    return _deleteBtn;
}

#pragma mark - UICollectionViewDataSource Delegate
#pragma mark 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}
#pragma mark 每组item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}

#pragma mark   cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FFEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FFEmojiCellID forIndexPath:indexPath];
    cell.emotion = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark   头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                   UICollectionElementKindSectionHeader withReuseIdentifier:FFEmojiHeadID forIndexPath:indexPath];
    [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(18, 2, DDYSCREENW, 16)];
    lab.textColor = DDY_Small_Black;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = DDYFont(14);
    lab.text = (self.customBtn.selected)?@"普通表情":@"emoji表情";
    [headerView addSubview:lab];
    return headerView;
}

#pragma mark - UICollectionViewDelegate
#pragma mark   UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FFEmotion *emotion = self.dataArray[indexPath.section][indexPath.row];
    NSLog(@"选择%@",[NSString ddy_blankString:emotion.code] ? emotion.face_name : emotion.code.emoji);
    if (self.selectEmojiBlock) {
        self.selectEmojiBlock([NSString ddy_blankString:emotion.code] ? emotion.face_name : emotion.code.emoji);
    }
}

- (void)loadData:(NSInteger)index {
    self.dataArray = [NSMutableArray array];
    if (index == 0) {
        self.customBtn.selected = YES;
        self.emojiBtn.selected = NO;
        [self.dataArray addObject:[FFEmotionManager customEmotion]];
    } else {
        self.customBtn.selected = NO;
        self.emojiBtn.selected = YES;
        [self.dataArray addObject:[FFEmotionManager emojiEmotion]];
    }
    [self.collectionView reloadData];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)handleCustom:(DDYButton *)sender {
    [self loadData:0];
}

- (void)handleEmoji:(DDYButton *)sender {
    [self loadData:1];
}

- (void)handleDelete:(DDYButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

@end
