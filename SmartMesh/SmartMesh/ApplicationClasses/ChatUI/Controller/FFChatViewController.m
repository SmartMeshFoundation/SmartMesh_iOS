//
//  FFChatViewController.m
//  SmartMesh
//
//  Created by Rain on 17/11/28.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFChatViewController.h"
#import "FFMessageTipCell.h"
#import "FFMessageBaseCell.h"
#import "FFMessageTextCell.h"
#import "FFMessageImageCell.h"
#import "FFMessageVoiceCell.h"
#import "FFMessageCardCell.h"
#import "FFChatBox.h"
#import "XMPPStream.h"
#import "FFChatManager.h"
#import "FFChatDetailsVC.h"
#import "FFChatRoomMemberVC.h"
#import "FFContactVC.h"
#import "FFNavigationController.h"
#import "FFAddressListVC.h"
#import "FFChatRoomMemberVC.h"

@interface FFChatViewController ()<UITableViewDelegate, UITableViewDataSource, FFChatBoxDelegate, FFMessageBaseCellDelegate, DDYAudioManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FFChatBox *chatBox;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString *chatUID;

@property (nonatomic, strong) NSString *groupName;

@property (nonatomic, assign) FFChatType chatType;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableDictionary *noDuplicateDict;

@end

@implementation FFChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    _dataArray = [NSMutableArray array];
    _noDuplicateDict = [NSMutableDictionary dictionary];
    [FFFileManager createAllDirectory];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatBox];
    [self getListWithPage:(self.page=0) isUP:NO];
    [self observeNotification:FFNewMsgRefreshChatPageNotification];
    [self observeNotification:FFNoNetImageReceiveFinishNoti];
    
    self.title = _groupName;
    
    if (_chatType == FFChatTypeGroup || _chatType == FFChatTypeDiscuss || _chatType == FFChatTypeSingle) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"setting" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonOnClicked)];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DDYSCREENW, DDYSCREENH-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = UIViewNew.viewSetFrame(0,0,DDYSCREENW,10);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = DDYRGBA(230, 230, 230, 1);
        
        [_tableView addTapTarget:self action:@selector(handleTapTableView)];
        [_tableView registerClass:[FFMessageTipCell class] forCellReuseIdentifier:DDYStrFormat(@"cell_%ld",(long)FFMessageTypeSystemTime)];
        [_tableView registerClass:[FFMessageTextCell class]  forCellReuseIdentifier:DDYStrFormat(@"cell_%ld",(long)FFMessageTypeText)];
        [_tableView registerClass:[FFMessageImageCell class] forCellReuseIdentifier:DDYStrFormat(@"cell_%ld",(long)FFMessageTypeImg)];
        [_tableView registerClass:[FFMessageVoiceCell class] forCellReuseIdentifier:DDYStrFormat(@"cell_%ld",(long)FFMessageTypeVoice)];
        [_tableView registerClass:[FFMessageCardCell class] forCellReuseIdentifier:DDYStrFormat(@"cell_%ld",(long)FFMessageTypeCard)];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOlderChatMsg)];
        _tableView.mj_header = header;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header.arrowView.hidden = YES;
    }
    return _tableView;
}

- (FFChatBox *)chatBox {
    if (!_chatBox) {
        _chatBox = [FFChatBox chatBoxWithVC:self];
        _chatBox.delegate = self;
        _chatBox.chatItems = @[FFChatBoxItemVoice,FFChatBoxItemPic,FFChatBoxItemTakePhoto,FFChatBoxItemCard,FFChatBoxItemEmoji,FFChatBoxItemTransfer];
        _tableView.ddy_h = DDYSCREENH-64-_chatBox.ddy_h;
    }
    return _chatBox;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFMessageCellModel *cellModel = self.dataArray[indexPath.row];
    FFMessageBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:DDYStrFormat(@"cell_%ld",(long)cellModel.message.messageType)];
    cell.delegate = self;
    cell.cellModel = cellModel;
    return cell;
}

#pragma mark - FFMessageBaseCellDelegate
- (void)messageCell:(FFMessageBaseCell *)messageCell withMessage:(FFMessage *)message {
    if (message.messageType == FFMessageTypeImg) {
        [self handleTapImage:message];
    } else if (message.messageType == FFMessageTypeVoice) {
        [self handleTapVoice:message];
    }
}

- (void)handleTapImage:(FFMessage *)message {
    DDYPreviewController *vc = [[DDYPreviewController alloc] initWithImage:[FFFileManager chatImgWithMsgID:message.messageID uidTo:message.remoteID] finishBtnTitle:DDYLocalStr(@"Save") delegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ddy_PreviewController:(UIViewController *)vc image:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        [DDYAuthorityMaster albumAuthSuccess:^{
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            if (![vc.navigationController popViewControllerAnimated:YES]) {
                [vc dismissViewControllerAnimated:YES completion:^{ }];
            }
        } fail:^{
            if (![vc.navigationController popViewControllerAnimated:YES]) {
                [vc dismissViewControllerAnimated:YES completion:^{ }];
            }
        } alertShow:YES];
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    error ? [self showErrorText:DDYLocalStr(@"Save failed")] : [self showSuccessText:DDYLocalStr(@"Save Success")] ;
}

- (void)handleTapVoice:(FFMessage *)message {
    [DDYAuthorityMaster audioAuthSuccess:^{
        [[DDYAudioManager sharedManager] ddy_PlayAudio:[FFFileManager chatVoiceWithMsgID:message.messageID uidTo:message.remoteID]];
        [DDYAudioManager sharedManager].delegate = self;
    } fail:^{ } alertShow:YES];
}

#pragma mark - DDYAudioManagerDelegate
- (void)audioPlayDidFinish {
    DDYInfoLog(@"rdp");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFMessageCellModel *cellModel = self.dataArray[indexPath.row];
    return cellModel.cellHeight;
}

#pragma mark chatBoxDelegate
#pragma mark sendText
- (void)chatBox:(FFChatBox *)chatBox sendText:(NSString *)text {
    FFMessage *msg = [self messageWithType:FFMessageTypeText];
    msg.textContent = text;
    [self sendMessage:msg];
}

#pragma mark - 发送语音
- (void)chatBox:(FFChatBox *)chatBox sendVoicePath:(NSString *)path seonds:(NSInteger)second {
    
    FFMessage *msg = [self messageWithType:FFMessageTypeVoice];

    NSString *amrPath = [FFFileManager saveSendVoiceWithmsgID:msg.messageID uidTo:msg.remoteID];
    [VoiceConverter ConvertWavToAmr:path amrSavePath:amrPath];
    msg.voiceDuration = LC_NSSTRING_FORMAT(@"%li", (long)second);

    [[FFChatManager sharedManager] uploadFileWithType:@"1" source:amrPath callBack:^(BOOL isSuccess, NSDictionary *fileSource) {
        
        if (isSuccess) {
            NSString *fileUrl = [fileSource objectForKey:@"fileUrl"];
            msg.fileURL = fileUrl;
            [self sendMessage:msg];
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        msg.isFromNoNet = @"1";
        [self sendMessage:msg];
        if (msg.chatType == FFChatTypeSingle) {
            [[FFMCManager sharedManager] sendVoiceToUser:msg.remoteID url:[NSURL fileURLWithPath:amrPath] result:^(BOOL success) {}];
        } else if (msg.chatType == FFChatTypeEveryOne) {
            [[FFMCManager sharedManager] sendVoiceToAll:[NSURL fileURLWithPath:amrPath] result:^(BOOL success) { }];
        }
    });
}

#pragma mark 发送图片
- (void)chatBox:(FFChatBox *)chatBox sendImages:(NSArray<UIImage *> *)imgArray {
    
    if (imgArray) {
        for (UIImage *image in imgArray) {
            
            FFMessage *msg = [self messageWithType:FFMessageTypeImg];
            NSString *path = [FFFileManager saveSendImage:image msgID:msg.messageID uidTo:_chatUID];
            
            [[FFChatManager sharedManager] uploadFileWithType:@"2" source:image callBack:^(BOOL isSuccess, NSDictionary *fileSource) {
                
                if (isSuccess) {
                    NSString *fileUrl = [fileSource objectForKey:@"fileUrl"];
                    NSString *cover = [fileSource objectForKey:@"cover"];
                    
                    msg.fileURL = fileUrl;
                    msg.imgBase64Data = cover;
                    [self sendMessage:msg];
                }
            }];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                msg.isFromNoNet = @"1";
                [self sendMessage:msg];
                if (msg.chatType == FFChatTypeSingle) {
                    [[FFMCManager sharedManager] sendImgToUser:msg.remoteID url:[NSURL fileURLWithPath:path] result:^(BOOL success) {}];
                } else if (msg.chatType == FFChatTypeEveryOne) {
                    [[FFMCManager sharedManager] sendImgToAll:[NSURL fileURLWithPath:path] result:^(BOOL success) { }];
                }
            });
        }
    }
}

#pragma mark 发送名片
- (void)chatBox:(FFChatBox *)chatBox sendCard:(NSString *)uName image:(NSString *)imgURL uid:(NSString *)uid sign:(NSString *)sign {
    FFMessage *msg = [self messageWithType:FFMessageTypeCard];
    msg.cardName = uName;
    msg.cardImage = imgURL;
    msg.cardID = uid;
    msg.cardSign = sign;
    [self sendMessage:msg];
}

#pragma mark 键盘
- (void)chatBox:(FFChatBox *)chatBox chatBoxHeight:(CGFloat)kbh {
    _tableView.ddy_h = DDYSCREENH-64-kbh;
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    
    NSInteger sections = [self.tableView numberOfSections];
    if (sections>0) {
        NSInteger rows = [self.tableView numberOfRowsInSection:sections - 1];
        if (rows>0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rows-1 inSection:sections-1];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    }
}

- (void)handleTapTableView {
    [_chatBox hideKeyBoard];
}

- (void)settingButtonOnClicked {
    if (_chatType == FFChatTypeSingle) {
        FFChatDetailsVC *singleDetailVC = [[FFChatDetailsVC alloc] initWithUid:_chatUID];
        [self.navigationController pushViewController:singleDetailVC animated:YES];
    } else if (_chatType == FFChatTypeDiscuss || _chatType == FFChatTypeGroup) {
        FFChatRoomMemberVC * controller = [[FFChatRoomMemberVC alloc] initWithChatUID:_chatUID];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)sendMessage:(FFMessage *)message {
    [[FFChatManager sharedManager] sendMsg:message];
    [self scrollToBottomAnimated:YES];
}

- (FFMessage *)messageWithType:(FFMessageType)messageType {
    FFMessage *msg = [[FFMessage alloc] init];
    msg.chatType = _chatType;
    msg.messageType = messageType;
    msg.uidFrom = [FFLoginDataBase sharedInstance].loginUser.localID;
    msg.nickName = [FFLoginDataBase sharedInstance].loginUser.remarkName;
    msg.messageID = [XMPPStream generateUUID];
    msg.remoteID = _chatUID;
    msg.groupName = _groupName;
    msg.timeStamp = round([[NSDate date] timeIntervalSince1970]);
    return msg;
}

- (void)chatUID:(NSString *)chatUID chatType:(FFChatType)chatType groupName:(NSString *)groupName {
    _chatUID = chatUID;
    _chatType = chatType;
    _groupName = groupName;
    [[FFChatManager sharedManager] startChat:chatType remoteID:chatUID];
}

#pragma mark 处理通知事件
- (void)handleNotification:(NSNotification *)notification {
    if ([notification is:FFNewMsgRefreshChatPageNotification]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            FFMessageCellModel *cellModel = [[FFMessageCellModel alloc] init];
            cellModel.message = (FFMessage *)notification.object;
            if (cellModel.message.messageID && !_noDuplicateDict[cellModel.message.messageID]) {
                [self.dataArray addObject:cellModel];
                _noDuplicateDict[cellModel.message.messageID] = cellModel;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadDataAndScrollTableView) object:nil];
                [self performSelector:@selector(reloadDataAndScrollTableView) withObject:nil afterDelay:0.2];
            });
        });
    } else if ([notification is:FFNoNetImageReceiveFinishNoti]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadDataAndScrollTableView) object:nil];
        [self performSelector:@selector(reloadDataAndScrollTableView) withObject:nil afterDelay:0.2];
    }
}

- (void)reloadDataAndScrollTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    if (fabs(_tableView.contentSize.height - _tableView.ddy_h-_tableView.contentOffset.y)<DDYSCREENH || _tableView.contentSize.height < _tableView.ddy_h) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollToBottomAnimated:YES];
        });
    }
}

- (void)dealloc {
    [[FFChatManager sharedManager] endChat];
    [self unobserveAllNotifications];
}

- (void)setTitle:(NSString *)title {
    MarqueeLabel *roomNameLab = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, DDYSCREENW/3, 40)];
    roomNameLab.marqueeType = MLContinuous;
    roomNameLab.scrollDuration = 8.0f;
    roomNameLab.rate = 60.0f;
    roomNameLab.fadeLength = 50.0f;
    roomNameLab.animationCurve = UIViewAnimationOptionCurveEaseInOut;
    roomNameLab.leadingBuffer = 0.0f;
    roomNameLab.trailingBuffer = 20.0f;
    roomNameLab.textAlignment = NSTextAlignmentCenter;
    roomNameLab.textColor = DDY_Black;
    roomNameLab.text = title;
    self.navigationItem.titleView = roomNameLab;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_chatBox hideKeyBoard]; // 可以不用UIScrollViewKeyboardDismissModeOnDrag
}

#pragma mark 获取聊天记录
- (void)getListWithPage:(NSInteger)page isUP:(BOOL)isUP {
    NSRange range = NSMakeRange(page*10, 10);DDYInfoLog(@"checkToIndexPage %ld\n%@",(long)page,NSStringFromRange(range));
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *selectArray = [[FFChatDataBase sharedInstance] selectRange:range chatType:_chatType remoteID:_chatUID];
        [_tableView.mj_header endRefreshing];
        if (selectArray && selectArray.count)
        {
            self.page++;
            for (FFMessage *message in selectArray) {
                FFMessageCellModel *cellModel = [[FFMessageCellModel alloc] init];
                cellModel.message = message;
                if (cellModel.message.messageID && !_noDuplicateDict[cellModel.message.messageID]) {
                    [self.dataArray insertObject:cellModel atIndex:0];
                    self.noDuplicateDict[message.messageID] = cellModel;
                }
            }
            if (_chatType == FFChatTypeEveryOne && page==0) {
                if (self.dataArray && self.dataArray.count) {
                    FFMessageCellModel *cellModel = [self.dataArray lastObject];
//                    [[FFXMPPManager sharedManager] enterEveryoneChatWithLastMsgTime:cellModel.message.timeStamp];
                    [[FFXMPPManager sharedManager] enterEveryoneChatWithLastMsgTime:[[NSDate date] timeIntervalSince1970]];//暂时不接受历史消息
                } else {
                    [[FFXMPPManager sharedManager] enterEveryoneChatWithLastMsgTime:[[NSDate date] timeIntervalSince1970]];
                }
                [FFMCManager sharedManager].canRreceiveEveryoneMsg = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{ DDYInfoLog(@"结束查询得到最近聊天列表");
                [self.tableView reloadData];
                if (isUP) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectArray.count inSection:0];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                } else {
                    [self scrollToBottomAnimated:NO];
                }
            });
        }
    });
}

- (void)loadOlderChatMsg {
    [self getListWithPage:self.page isUP:YES];
}

@end
