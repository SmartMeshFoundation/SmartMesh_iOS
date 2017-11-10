//
//  FFMacroTool.h
//  SmartMesh
//
//  Created by Rain on 17/9/14.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#ifndef FFMacroTool_h
#define FFMacroTool_h

// MCService
static NSString *const FFService  = @"SmartMeshChat";
// localID of system
static NSString *const SystemLocalID = @"SystemLocalID";
// localID of everyoneChatRoom
static NSString *const EveryoneLocalID = @"EveryoneLocalID";
// i18N
static NSString *const FFLanguage  = @"FFLanguage";
//
static NSString *const t_FriendRequest  = @"FriendRequestTable";



////////////////////////// File Type //////////////////////////
// Image
static NSString *const FFSendImage  = @"<image>";
// Avatar
static NSString *const FFSendAvatar = @"<avatar>";
// Voice
static NSString *const FFSendVoice  = @"<voice>";
// Video
static NSString *const FFSendVideo  = @"<video>";


////////////////////////// Noti //////////////////////////

// LoginSucc
static NSString *const FFLoginSuccessdNotification = @"FFLoginSuccessdNotification";
// Token Invalid
static NSString *const FFTokenInvalidNotification = @"FFTokenInvalidNotification";
// Offline
static NSString *const FFUserOffLineNotification = @"FFUserOffLineNotification";

// new Message
static NSString *const FFNewMessageNotification = @"FFNewMessageNotification";
// refreshChatPage
static NSString *const FFNewMsgRefreshChatPageNotification = @"FFNewMsgRefreshChatPageNotification";
// new MCUser
static NSString *const FFNoNetUserJoinedNotification = @"FFNoNetUserJoinedNotification";
// MCUserAvatarReceived
static NSString *const FFNoNetAvatarReceiveFinishNoti = @"FFNoNetAvatarReceiveFinishNoti";
// MCImageReceived
static NSString *const FFNoNetImageReceiveFinishNoti = @"FFNoNetImageReceiveFinishNoti";
// refreshHomeList
static NSString *const FFRefreshHomePageNotification = @"FFRefreshHomePageNotification";


static NSString *const FFAddFriendRequestNotification = @"FFAddFriendRequestNotification";

static NSString *const NALoginNotification = @"NALoginNotification";

static NSString *const NAExitLoginNotification = @"NAExitLoginNotification";


////////////////////////// Msg Enum ///////////////////////////

typedef NS_ENUM(NSInteger, FFChatType) {
    FFChatTypeSingle = 0,
    FFChatTypeDiscuss,
    FFChatTypeGroup,
    FFChatTypeEveryOne,
    FFChatTypeSystem,
};


typedef NS_ENUM(NSInteger, FFMessageType) {
    FFMessageTypeText = 0,
    FFMessageTypeImg,
    FFMessageTypeVoice,
    FFMessageTypeGif,
    FFMessageTypeLocation,
    FFMessageTypeImgGroup,
    FFMessageTypeCard,
    FFMessageTypeFileDoc,
    FFMessageTypeFilePdf,
    FFMessageTypeFilePpt,
    FFMessageTypeFileXls,
    FFMessageTypeFileTxt,
    FFMessageTypeFileMp3,
    FFMessageTypeFileZip,
    FFMessageTypeFileRar,
    FFMessageTypeFile,
    FFMessageTypeExecutive,
    FFMessageTypeShare,
    
    FFMessageTypeSystemTime,
    FFMessageTypeFriendRequest,
    FFMessageTypeFriendAccept,
    FFMessageTypeForcedOffline,
    FFMessageTypeOfflineMessage,
    FFMessageTypeNotSupportMessage,
    
};


typedef NS_ENUM(NSInteger, FFMessageSendState) {
    FFMessageSendStatePending = 0,
    FFMessageSendStateSending,
    FFMessageSendStateSuccess,
    FFMessageSendStateFailure,
};


typedef NS_ENUM(NSInteger, FFMessageReadState) {
    FFMessageReadStateUnread = 0,
    FFMessageReadStateRead,
};



typedef NS_ENUM(NSInteger, FFKeyBoardState) {
    FFKeyBoardStateDefault = 0,
    FFKeyBoardStateVoice,
    FFKeyBoardStateFace,
    FFKeyBoardStateVideo,
};


#define ADDRESS_TEMP @"123456789012345678912345678901234567891234567890123456789"

/** String with format */
#define LC_NSSTRING_FORMAT(s,...) [NSString stringWithFormat:s,##__VA_ARGS__]

/** String is invalid */
#define LC_NSSTRING_IS_INVALID(s) ( !s  || [s isKindOfClass:[NSNull class]]|| s.length <= 0 || [s isEqualToString:@"(null)"])

// BgColor
#define FFBackColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]
// MainColor
#define FF_MAIN_COLOR DDYRGBA(220, 190, 50, 1)


#define ChatMargin 10

#define ChatHeadWH 28

#define ChatHeadToBubble 3

#define ChatTriangleW 7

#define ChatTextMaxW  (DDYSCREENW-2*ChatHeadWH-2*ChatMargin-2*ChatHeadToBubble-4*ChatTriangleW)

#define ChatImgWH  200

#define chatNameFont [UIFont systemFontOfSize:10]

#define ChatTimeFont [UIFont systemFontOfSize:11]

#define ChatTextFont [UIFont systemFontOfSize:14]


#define rgba(r, g, b, a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]

#define LC_KEYWINDOW ([UIApplication sharedApplication].keyWindow)

#define SCREENBOUNDS [UIScreen mainScreen].bounds

#define WALLET [(FFAppDelegate *)[UIApplication sharedApplication].delegate wallet]


// --------------------- QRCode ------------------

#define NORMAL_QCCODE @"%@"

//2.ETH：0x185da3e1f6f981659e67122ad0b1b1e05c602ac4?amount=1&token=ETH
#define ETH_QCCODE @"%@?amount=%@&token=ETH"

//3.FFT：0x185da3e1f6f981659e67122ad0b1b1e05c602ac4?amount=1&token=FFT
#define FFT_QCCODE @"%@?amount=%@&token=FFT"





#define FFChatBoxFunctionViewH 253


#define FFCreateTable(tb, field) DDYStrFormat(@"CREATE TABLE IF NOT EXISTS %@ %@", tb, field)

#endif
