//
//  FFAddressListVC.m
//  SmartMesh
//
//  Created by Megan on 2017/12/15.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFAddressListVC.h"
#import "FFFriendCell.h"
#import "FFChatViewController.h"

static NSString *const collectionID = @"collectionID";

@interface FFAddressListVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIBarButtonItem  *completeBtn;

@property (nonatomic, strong) NSMutableArray   *contactArray;       // tableView 联系人数据源
@property (nonatomic, strong) NSMutableArray   *sectionArray;
@property (nonatomic, strong) UIView           *topView;
@property (nonatomic, strong) UICollectionView *bottomCollectionView;// qn新增 底部的view
@property (nonatomic, strong) UIButton         *bottomFinishBtn;
@property (nonatomic, strong) NSMutableArray   *selectorArray;      // 除了固定的(fix),剩下的可以选择中已经选择的 ;collectionView 选择的数据源

@end

@implementation FFAddressListVC

- (NSMutableArray *)contactArray {
    if (!_contactArray) {
        _contactArray = [NSMutableArray array];
    }
    return _contactArray;
}

- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

- (NSMutableArray *)selectorArray {
    if (!_selectorArray) {
        _selectorArray = [NSMutableArray array];
    }
    return _selectorArray;
}

- (UIImage *)getBgImg {
    return [[UIImage imageWithColor:DDYRGBA(235, 235, 235, 1) size:DDYSize(DDYSCREENW-30, 28)] imageCornerRadius:8];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadFriendListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupTopView];
    
    NSArray *temp = [[FFUserDataBase sharedInstance] getMyContacts];
    self.contactArray = [temp ddy_SortWithCollectionStringSelector:@selector(remarkName)];
    self.sectionArray = [self.contactArray ddy_SortWithModel:@"FFUser" selector:@selector(pinYin) showSearch:NO];
    [self.tableView reloadData];
    
    
    self.title = @"Select";
    
    NSString * completeStr = LC_NSSTRING_FORMAT(@"Complete(%zd)",self.selectorArray.count);
    _completeBtn = [[UIBarButtonItem alloc] initWithTitle:completeStr style:UIBarButtonItemStylePlain target:self action:@selector(completeAction)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backClk)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = _completeBtn;
}

- (void)backClk
{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setupTableView {
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.sectionIndexBackgroundColor = DDY_ClearColor;
    self.tableView.sectionIndexTrackingBackgroundColor = DDY_ClearColor;
    self.tableView.sectionIndexColor = DDY_Gray;
    self.tableView.sectionIndexMinimumDisplayRowCount = 5;
}

#pragma mark - 只有创建群聊操作时候, 才会有这个按钮的相关操作
- (void)completeAction
{
    [self backClk];
    
    // 发生回调,给原先的控制器,进行创建群聊.
    if (self.seletedUsersBlock) {
        self.seletedUsersBlock(self.selectorArray);
    }
}

#pragma mark - setupBottomView
- (void)setupTopView
{
    _topView = [[UIView alloc] init];
    _topView.frame = CGRectMake(0, 49, ScreenWidth, 65);
    _topView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = _topView;
    
    UIView * line = [[UIView alloc] initWithFrame:LC_RECT(0, 64, DDYSCREENW, 1)];
    line.backgroundColor = LC_RGB(235, 235, 235);
    [_topView addSubview:line];
    
    [self setupCollectionView];
}

#pragma mark - 初始化底部的展示选中用户的效果
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 49);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 5;
    
    _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 49) collectionViewLayout:layout];
    _bottomCollectionView.dataSource = self;
    _bottomCollectionView.delegate = self;
    
    [_topView addSubview:_bottomCollectionView];
    _bottomCollectionView.backgroundColor = [UIColor whiteColor];
    
    [_bottomCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionID];
    
}

#pragma mark - DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.contactArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFFriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    if (!cell) {
        cell = [[FFFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FFUser * user = self.contactArray[indexPath.section][indexPath.row];
    
    BOOL isSelect = NO;
    BOOL isFixed  = NO;
    
    if ([self.groupMembers objectForKey:user.localid]) {
        
        isFixed = YES;
    }else {
        
        isFixed = NO;
    }
    
    for (FFUser *inUser in self.selectorArray) {
        
        if ([user.localid isEqualToString:inUser.localid]) {
            isSelect = YES;
            break;
        }
    }
        
    [cell reloadCellUser:user selected:isSelect isFixed:isFixed];
    
    [self.bottomCollectionView reloadData];
    
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollToTop];
        return -1;
    }
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

#pragma mark TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFUser * user = self.contactArray[indexPath.section][indexPath.row];

    if (self.selectType == FFGroupChatType) {
        
        if ([self.groupMembers objectForKey:user.localid]) {
            // 如果是群成员,不可进行点击操作
            
        }else {
            
            //如果存在 从selectorPatnArray删除
            for (FFUser *inUser in self.selectorArray) {
                
                if ([user.localid integerValue] == [inUser.localid integerValue] ) {
                    
                    [self.selectorArray removeObject:inUser];
                    
                    [self.tableView reloadData];
                    
                    return;
                }
            }
            
            //不存在,添加到 selectorPatnArray
            [self.selectorArray addObject:user];
            
            [self.tableView reloadData];
        }
        
    }
    else if (self.selectType == FFChatUserCardType)
    {
        [self.selectorArray addObject:user];
        if (self.seletedUsersBlock) {
            self.seletedUsersBlock(self.selectorArray);
        }
        if (![self.navigationController popViewControllerAnimated:YES]) {
            [self dismissViewControllerAnimated:YES completion:^{ }];
        }
    }
}


- (void)scrollToTop
{
    CGFloat yOffset = 0;
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    }
    [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
}



#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.tableView reloadData];
}

#pragma mark - qn新增
#pragma mark - UICollectionView -> dataSource , -> delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [_completeBtn setTitle:LC_NSSTRING_FORMAT(@"Complete(%zd)",self.selectorArray.count)];
    return self.selectorArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionID forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(3, 3, cell.viewFrameWidth - 6, cell.viewFrameHeight - 6);
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    FFUser *user = self.selectorArray[indexPath.row];
    [imageView sd_setImageWithURL:[NSURL URLWithString:user.userImage] placeholderImage:[UIImage imageNamed:@"icon_head_defaul"]];
    [cell.contentView addSubview:imageView];
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FFUser *friend = self.selectorArray[indexPath.row];
//    [self removeSelectedObject:friend];
    [self.selectorArray removeObject:friend];
    [self.tableView reloadData];
}

#pragma mark - 移除选中的内容
- (void)removeSelectedObject:(FFUser *)friend
{
    [self.selectorArray removeObject:friend];
    
    // 从bottomview的数据源中移除
    for (FFUser *bottomUser in self.selectorArray) {
        if ([bottomUser.localid isEqualToString:friend.localID]) {
            
            [self.selectorArray removeObject:bottomUser];
            break;
        }
    }

    [self.bottomCollectionView reloadData];
}

- (void)addSelectedObject:(FFUser *)friend
{
    [self.selectorArray setValue:friend forKey:friend.localID];
    
    [self.selectorArray addObject:friend];
    
    if (self.selectorArray.count) {
        _bottomFinishBtn.enabled = YES;
        _bottomFinishBtn.backgroundColor = APP_MAIN_COLOR;
    }
    
    [self.bottomCollectionView reloadData];
}

-(void)loadFriendListData
{
    [FFLocalUserInfo LCInstance].isUser = YES;
    [NANetWorkRequest na_postDataWithService:@"friend" action:@"friend_list" parameters:nil results:^(BOOL status, NSDictionary *result) {
        
        if (status) {
            
            NSArray * data = [result objectForKey:@"data"];
            NSMutableArray * temp = [NSMutableArray array];
            for (NSDictionary * dict in data) {
                
                FFUser * user = [FFUser userWithDict:dict];
                [temp addObject:user];
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                for (FFUser *user in temp) {
                    
                    // 缓存本地好友关系
                    [[FFUserDataBase sharedInstance] saveUser:user];
                    
                    [[FFUserDataBase sharedInstance] changeRelationShip:@"1" localID:user.localid];
                    
                }
            });
            
            self.contactArray = [temp ddy_SortWithCollectionStringSelector:@selector(remarkName)];
            self.sectionArray = [self.contactArray ddy_SortWithModel:@"FFUser" selector:@selector(pinYin) showSearch:NO];
            
            
            NSLog(@"==通讯录请求成功==");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
        else
        {
            NSLog(@"==网络异常==");
        }
    }];
}

@end
