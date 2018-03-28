//  Created by R on 18/3/19.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import "BleSelectView.h"
#import "BLECentralManager.h"

@interface BleSelectView ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *bgView;
    UIView *headView;
    UIView *footView;
    UITableView *bleView;
    NSArray *bleArr;
    UIButton *confirmBtn;
    NSInteger _currentIndex;
}

@end

@implementation BleSelectView

+ (BleSelectView *)shareInstance
{
    static dispatch_once_t pred = 0;
    __strong static BleSelectView *_bleView = nil;
    dispatch_once(&pred, ^{
        _bleView = [[self alloc] init]; // or some other init method
    });
    return _bleView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentIndex=-1;
        self.frame = CGRectMake(60, 100, [UIScreen mainScreen].bounds.size.width-120, [UIScreen mainScreen].bounds.size.height-200);
        [self setUp];
    }
    return self;
}

- (void)dealloc{
    //移除通知处理
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUp
{
    //监听扫描到多个蓝牙设备
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBleList:) name:kBLEScanCompletedNotification object:nil];
    
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 30)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(headView.frame), CGRectGetHeight(headView.frame))];
    [headView addSubview:title];
    title.text = @"蓝牙设备";
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18.0];
    [self addSubview:headView];
    
    
    bleView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-30-50) style:UITableViewStylePlain];
    bleView.delegate = self;
    bleView.dataSource = self;
    bleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bleView];
    
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bleView.frame), CGRectGetWidth(self.frame), 50)];
    footView.backgroundColor = [UIColor whiteColor];
    [self addSubview:footView];
    
    UIImage *confirmImgNor = [UIImage imageNamed:@"btn_n.png"];
    confirmImgNor = [confirmImgNor stretchableImageWithLeftCapWidth:confirmImgNor.size.width/2 topCapHeight:confirmImgNor.size.height/2];
    UIImage *confirmImgSel = [UIImage imageNamed:@"btn_s.png"];
    confirmImgSel = [confirmImgSel stretchableImageWithLeftCapWidth:confirmImgSel.size.width/2 topCapHeight:confirmImgSel.size.height/2];
    confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.frame) - 20, 40)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:confirmImgNor forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:confirmImgSel forState:UIControlStateHighlighted];
    [confirmBtn addTarget:self action:@selector(connectBlueTooth:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:confirmBtn];
    
}

- (void)updateBleList:(NSNotification *)notify
{
    [self show];
    bleArr = notify.object;
    [bleView reloadData];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    BLEDeviceInfo *info =bleArr[indexPath.row];
    cell.textLabel.text = info.peripheral.name;
    cell.accessoryType=_currentIndex==indexPath.row?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger newRow = [indexPath row];
    if (newRow != _currentIndex)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                    indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSIndexPath *lastIndexPath=[NSIndexPath indexPathForRow:_currentIndex inSection:0];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
                                    lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        _currentIndex=indexPath.row;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)connectBlueTooth:(UIButton *)sender
{
    [self dismiss];
}

- (void)dismiss{
    [bgView removeFromSuperview];
    [self removeFromSuperview];
    
    if (_currentIndex>=0&&_currentIndex<bleArr.count) {
        BLEDeviceInfo *info = [bleArr objectAtIndex:_currentIndex];
        //蓝牙连接处理
        [[BLECentralManager shareInstance] beginConnectWithPeripheral:info.peripheral];
    }
    _currentIndex=-1;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (![window.subviews containsObject:self]) {
        bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [window addSubview:bgView];
        [window addSubview:self];
    }
}

@end
