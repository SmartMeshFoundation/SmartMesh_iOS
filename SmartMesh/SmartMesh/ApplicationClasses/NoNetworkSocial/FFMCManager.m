//
//  FFMCManager.m
//  SmartMesh
//
//  Created by Rain on 15/9/11.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//


#import "FFMCManager.h"

@interface FFMCManager ()<MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) NSLock *sessionLock;
@property (nonatomic, strong) FFUser *localUser;
@property (nonatomic, strong) NSMutableDictionary *usersInfoCache;

@end

@implementation FFMCManager



static FFMCManager *_instance;

+ (instancetype)sharedManager {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (NSMutableArray *)onlineUsersArray {
    if (!_onlineUsersArray) {
        _onlineUsersArray = [NSMutableArray array];
    }
    return _onlineUsersArray;
}


- (void)initWithUser:(FFUser *)user
{
    _localUser = user;
    _sessionLock = [[NSLock alloc] init];
    [self restart];
    [self addObserverActive];
}


- (void)initLocalUser
{
    if (_peerID) {
        _peerID = nil;
    }
    _usersInfoCache = [NSMutableDictionary dictionary];
    _onlineUsersArray = [NSMutableArray array];
    _peerID = [[MCPeerID alloc] initWithDisplayName:_localUser.localID];
    [_usersInfoCache setObject:_localUser forKey:_localUser.localID];
}


- (void)startSession
{
    [self stopSession];
    _session = [[MCSession alloc] initWithPeer:_peerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
    _session.delegate = self;
}


- (void)stopSession
{
    if (_session) {
        [_session disconnect];
        _session.delegate = nil;
        _session = nil;
    }
}


- (void)startAdvertise
{
    [self stopAdvertise];
    _localUser.timeStamp_NoNet = DDYStrFormat(@"%lf",[[NSDate date] timeIntervalSince1970]);
    _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID discoveryInfo:_localUser.userInfo serviceType:FFService];
    _advertiser.delegate = self;
    [_advertiser startAdvertisingPeer];
    DDYInfoLog(@"timeStamp_NoNet %@ \ninfo:%@",_localUser.timeStamp_NoNet, _localUser.userInfo);
}


- (void)stopAdvertise
{
    if (_advertiser) {
        [_advertiser stopAdvertisingPeer];
        _advertiser.delegate = nil;
        _advertiser = nil;
    }
}

- (void)startBrowse
{
    [self stopBrowse];
    _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:FFService];
    _browser.delegate = self;
    [_browser startBrowsingForPeers];
}

- (void)stopBrowse
{
    if (_browser) {
        [_browser stopBrowsingForPeers];
        _browser.delegate = nil;
        _browser = nil;
    }
}

- (void)restart
{
    [self initLocalUser];
    [self startSession];
    [self startBrowse];
    [self startAdvertise];
}

- (void)inviteUser:(MCPeerID *)peerID
{
    if (_browser) {
        [_browser invitePeer:peerID toSession:_session withContext:nil timeout:0];
    }
}

- (void)userJoin:(MCPeerID *)peerID
{
    if ([_onlineUsersArray containsObject:_usersInfoCache[peerID.displayName]]) {
        [_onlineUsersArray removeObject:_usersInfoCache[peerID.displayName]];
    }
    if (_usersInfoCache[peerID.displayName]) {
        [_onlineUsersArray addObject:_usersInfoCache[peerID.displayName]];
    }
    if (self.usersArrayChangeBlock) {
        self.usersArrayChangeBlock(_onlineUsersArray);
    }
}


- (void)userConnecting:(MCPeerID *)peerID
{

}

- (void)userLeave:(MCPeerID *)peerID
{
    if ([_onlineUsersArray containsObject:_usersInfoCache[peerID.displayName]]) {
        [_onlineUsersArray removeObject:_usersInfoCache[peerID.displayName]];
        [self performSelectorOnMainThread:@selector(inviteUser:) withObject:peerID waitUntilDone:NO];
    }
    if (self.usersArrayChangeBlock) {
        self.usersArrayChangeBlock(_onlineUsersArray);
    }
}

- (BOOL)sendMessageToAll:(NSData *)message
{
    return [_session sendData:message toPeers:_session.connectedPeers withMode:MCSessionSendDataReliable error:nil];
}

- (BOOL)sendMessageToUser:(NSString *)localID message:(NSData *)message
{
    MCPeerID *realPeerID = nil;
    for (MCPeerID *peerID in _session.connectedPeers) {
        if ([peerID.displayName isEqualToString:localID]) {
            realPeerID = peerID;
        }
    }
    return realPeerID ? [_session sendData:message toPeers:@[realPeerID] withMode:MCSessionSendDataReliable error:nil] : NO;
}


- (NSString *)localPathWithImg:(UIImage *)img
{
    NSURL *imageURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@temp.png", NSTemporaryDirectory()]];
    NSData *scaledImageData = UIImagePNGRepresentation(img);
    [[NSFileManager defaultManager] createFileAtPath:imageURL.path contents:scaledImageData attributes:nil];
    return imageURL.absoluteString;
}

- (void)sendSourceToPeer:(MCPeerID *)peerID url:(NSURL *)url fileID:(NSString *)fileID result:(void (^)(BOOL success))result
{
    DDYInfoLog(@"url:\n%@\n%@",url.absoluteString,[url lastPathComponent]);
    NSString *imgName = DDYStrFormat(@"%@<#>%@", fileID, [url lastPathComponent]);
    NSError *error;
    if ( [[NSFileManager defaultManager] copyItemAtURL:url toURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@temp2.png", NSTemporaryDirectory()]] error:&error]) {
    } else {
    }
    if (error) {
        DDYInfoLog(@"copy faile::: %@",error.localizedDescription);
    }
    [_session sendResourceAtURL:url withName:imgName toPeer:peerID withCompletionHandler:^(NSError *error) {
        if (result) result(!error);
    }];
}

- (void)sendImgToAll:(NSURL *)url result:(void (^)(BOOL success))result
{
    if (_session.connectedPeers && _session.connectedPeers.count) {
        for (MCPeerID *peerID in _session.connectedPeers) {
            [self sendSourceToPeer:peerID url:url fileID:FFSendImage result:nil];
        }
        if (result) result(YES);
    } else {
        if (result) result(NO);
    }
}

- (void)sendImgToUser:(NSString *)localID url:(NSURL *)url result:(void (^)(BOOL success))result
{
    MCPeerID *realPeerID = nil;
    for (MCPeerID *peerID in _session.connectedPeers) {
        if ([peerID.displayName isEqualToString:localID]) {
            realPeerID = peerID;
        }
    }
    if (realPeerID) {
        
        UIImage *img = [UIImage imageWithContentsOfFile:url.absoluteString];
        if (img) {
            NSURL *imgURL = [NSURL URLWithString:[self localPathWithImg:img]];
            [self sendSourceToPeer:realPeerID url:[NSURL fileURLWithPath:url.absoluteString] fileID:FFSendImage result:^(BOOL success) {
                if (result) result(success);
            }];
        }
    } else {
        if (result) result(NO);
    }
}

- (void)sendAvatarToAll
{
    for (MCPeerID *peerID in _session.connectedPeers) {
        [self sendSourceToPeer:peerID url:DDYURLStr(_localUser.avatarPath) fileID:FFSendAvatar result:nil];
    }
}

- (void)sendVoiceToAll:(NSURL *)url result:(void (^)(BOOL success))result
{
    if (_session.connectedPeers && _session.connectedPeers.count) {
        for (MCPeerID *peerID in _session.connectedPeers) {
            [self sendSourceToPeer:peerID url:url fileID:FFSendVoice result:nil];
        }
        if (result) result(YES);
    } else {
        if (result) result(NO);
    }
}

- (void)sendVoiceToUser:(NSString *)localID url:(NSURL *)url result:(void (^)(BOOL success))result
{
    MCPeerID *realPeerID = nil;
    for (MCPeerID *peerID in _session.connectedPeers) {
        if ([peerID.displayName isEqualToString:localID]) realPeerID = peerID;
    }
    if (realPeerID) {
        [self sendSourceToPeer:realPeerID url:url fileID:FFSendVoice result:^(BOOL success) {
            if (result) result(success);
        }];
    } else {
        if (result) result(NO);
    }
}

- (void)sendVideoToAll:(NSURL *)url result:(void (^)(BOOL success))result
{
    if (_session.connectedPeers && _session.connectedPeers.count) {
        for (MCPeerID *peerID in _session.connectedPeers) {
            [self sendSourceToPeer:peerID url:url fileID:FFSendVideo result:nil];
        }
        if (result) result(YES);
    } else {
        if (result) result(NO);
    }
}


- (void)sendVideoToUser:(NSString *)localID url:(NSURL *)url result:(void (^)(BOOL success))result
{
    MCPeerID *realPeerID = nil;
    for (MCPeerID *peerID in _session.connectedPeers) {
        if ([peerID.displayName isEqualToString:localID]) realPeerID = peerID;
    }
    if (realPeerID) {
        [self sendSourceToPeer:realPeerID url:url fileID:FFSendVideo result:^(BOOL success) {
            if (result) result(success);
        }];
    } else {
        if (result) result(NO);
    }
}

#pragma mark - MCNearbyServiceBrowserDelegate
#pragma mark Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(nullable NSDictionary<NSString *, NSString *> *)info
{
    if (info) {
        DDYInfoLog(@"发现用户：%@\nmyinfo:%@",info,_localUser.userInfo);
        [_usersInfoCache setObject:(FFUser *)[FFUser userWithDict:info] forKey:peerID.displayName];
        if ([info[@"timeStamp_NoNet"] doubleValue] > [_localUser.userInfo[@"timeStamp_NoNet"] doubleValue]) {
            [self performSelectorOnMainThread:@selector(inviteUser:) withObject:peerID waitUntilDone:NO];
        }
    }
}

#pragma mark A nearby peer has stopped advertising
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    
}

#pragma mark Browsing did not start due to an error
- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    
}

#pragma mark - MCNearbyServiceAdvertiserDelegate
#pragma mark Receive Invitation
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(nullable NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler
{
    invitationHandler(YES, _session);
}

#pragma mark Advertising did not start due to an error.
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    
}

#pragma mark - MCSessionDelegate
#pragma mark Remote peer changed state.
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state)
    {
        case MCSessionStateNotConnected:
            [self performSelectorOnMainThread:@selector(userLeave:) withObject:peerID waitUntilDone:NO];
            break;
        case MCSessionStateConnecting:
            [self performSelectorOnMainThread:@selector(userConnecting:) withObject:peerID waitUntilDone:NO];
            break;
        case MCSessionStateConnected:
            [self performSelectorOnMainThread:@selector(userJoin:) withObject:peerID waitUntilDone:NO];
            break;
    }
}

#pragma mark Received data from remote peer.
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    FFUser *user = _usersInfoCache[peerID.displayName];
    if (user)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        FFMessage *msg  = [[FFMessage alloc] init];
        msg.timeStamp   = [dict[@"timeStamp"] integerValue];
        msg.chatType    = (FFChatType)([dict[@"chatType"] intValue]);
        msg.uidFrom     = dict[@"uidFrom"];
        msg.nickName    = dict[@"nickName"];
        msg.messageID   = dict[@"messageID"];
        msg.content     = dict[@"content"];
        if (msg.chatType == FFChatTypeSingle) {
            msg.remoteID = peerID.displayName;
            msg.groupName = user.remarkName;
        } else {
            msg.remoteID = dict[@"remoteID"];
            msg.groupName =  dict[@"groupName"];
        }
        if ([msg.remoteID isEqualToString: [FFLoginDataBase sharedInstance].loginUser.localID]) {
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postNotification:FFNewMessageNotification withObject:msg];
        });
    }
}

#pragma markReceived a byte stream from remote peer.
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

#pragma mark Start receiving a resource from remote peer.
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(nullable NSError *)error
{
    if ([resourceName containsString:@"<#>"]) {
        NSArray *result = [resourceName componentsSeparatedByString:@"<#>"];
        if (result.count>=2) {
            NSString *type = result[0];
            if ([type isEqualToString:FFSendImage]) {
                if ([FFFileManager saveReceiveImage:localURL uidTo:peerID.displayName resourceName:resourceName]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self postNotification:FFNoNetImageReceiveFinishNoti withObject:peerID.displayName];
                    });
                }
            } else if ([type isEqualToString:FFSendVideo]) {
                
            } else if ([type isEqualToString:FFSendVoice]) {
               
            } else if ([type isEqualToString:FFSendAvatar]) {
                
                if ([FFFileManager saveAvatarImage:localURL uidTo:peerID.displayName]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self postNotification:FFNoNetAvatarReceiveFinishNoti withObject:peerID.displayName];
                    });
                }
            }
        }
    }
}

#pragma mark Made first contact with peer and have identity information about the remote peer (certificate may be nil).
- (void)session:(MCSession *)session didReceiveCertificate:(nullable NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    if (certificateHandler) {
        certificateHandler(YES);
    }
}

- (void)addObserverActive
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DDYInfoLog( @"[LC_UIApplication] Application did become active." );
    _canInvite = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    DDYInfoLog( @"[LC_UIApplication] Application will resign active." );
    _canInvite = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopAdvertise];
}

@end
