/**
 *  MIT License
 *
 *  Copyright (c) 2017 Richard Moore <me@ricmoo.com>
 *
 *  Permission is hereby granted, free of charge, to any person obtaining
 *  a copy of this software and associated documentation files (the
 *  "Software"), to deal in the Software without restriction, including
 *  without limitation the rights to use, copy, modify, merge, publish,
 *  distribute, sublicense, and/or sell copies of the Software, and to
 *  permit persons to whom the Software is furnished to do so, subject to
 *  the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included
 *  in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 *  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 *  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS IN THE SOFTWARE.
 */

/**
 *  Wallet
 *
 *  This is the entire encapsulation of the Ethereum Wallet. No private keys
 *  exist or accessible outside this class. The ModalViewController class is
 *  used extensively to interact with the user.
 *
 *  User Interactions
 *    - Approve signing (and sending) transactions
 *    - Adding or removing accounts
 *    - Viewing account backup mnemonic phrases
 *    - Setting user settings
 */

#import <Foundation/Foundation.h>

#import <ethers/Address.h>
#import <ethers/BigNumber.h>
#import <ethers/Payment.h>
#import <ethers/Provider.h>
#import <ethers/Transaction.h>
#import <ethers/TransactionInfo.h>
#import <ethers/Account.h>

@class Account;

#pragma mark - Notifications

extern const NSNotificationName WalletAddedAccountNotification;
extern const NSNotificationName WalletRemovedAccountNotification;
extern const NSNotificationName WalletReorderedAccountsNotification;
extern const NSNotificationName WalletChangedNicknameNotification;

// If the balance for any account changes
extern const NSNotificationName WalletBalanceChangedNotification;

// If the active account transactions change (including confirmation count)
extern const NSNotificationName WalletTransactionChangedNotification;
extern const NSNotificationName WalletAccountTransactionsUpdatedNotification;

extern const NSNotificationName WalletChangedActiveAccountNotification;

extern const NSNotificationName WalletDidSyncNotification;

extern const NSNotificationName WalletDidChangeNetwork;


#pragma mark - Errors

extern NSErrorDomain WalletErrorDomain;

#define kWalletErrorNetwork                         -1
#define kWalletErrorUnknown                         -5

#define kWalletErrorSendCancelled                   -11
#define kWalletErrorSendInsufficientFunds           -12


#pragma mark -

@interface Wallet : NSObject

+ (instancetype)walletWithKeychainKey: (NSString*)keychainKey;

@property (nonatomic, readonly) NSString *keychainKey;

@property (nonatomic, strong) Address *activeAccount;

/** 当前登陆的账户 */
@property (nonatomic, strong) Account *currentAccount;

@property (nonatomic, readonly) Provider *provider;

@property (nonatomic, readonly) NSTimeInterval syncDate;

@property (nonatomic, readonly) float etherPrice;
@property (nonatomic, readonly) BlockTag blockNumber;
@property (nonatomic, readonly) BigNumber *gasPrice;

- (void)refresh: (void (^)(BOOL))callback;


#pragma mark - 执行转账的操作;
- (NSString *)executeTransaction:(Transaction *)transaction;

#pragma mark - Ordered Access operations

@property (nonatomic, readonly) NSUInteger numberOfAccounts;

- (void)exchangeAccountAtIndex: (NSUInteger)fromIndex withIndex: (NSUInteger)toIndex;
- (void)moveAccountAtIndex: (NSUInteger)fromIndex toIndex: (NSUInteger)toIndex;
- (Address*)addressAtIndex: (NSUInteger)index;
- (NSUInteger)indexForAddress: (Address*)address;


#pragma mark - Locked

// Locked Accounts - Unlocked accounts keep the private key in memory, and can send transactions with only the Touch ID

- (BOOL)isAccountUnlocked: (Address*)address;
- (BOOL)lockAccount: (Address*)address;
//- (void)unlockAccount: (Address*)address callback:(void (^)(BOOL unlocked))callback;


#pragma mark - Queries

- (BOOL)containsAddress: (Address*)address;

- (NSString*)nicknameForAccount: (Address*)address;
- (void)setNickname: (NSString*)nickname address: (Address*)address;

- (BigNumber*)balanceForAddress: (Address*)address;

- (NSUInteger)transactionCountForAddress: (Address*)address;
- (TransactionInfo*)transactionForAddress: (Address*)address index: (NSUInteger)index;


#pragma mark - Account Management (these present their own modal UI)

- (void)addAccountCallback: (void (^)(Address *address))callback;
- (void)manageAccount: (Address*)address callback: (void (^)())callback;

- (void)addAccount: (Account*)account json: (NSString*)json;

// 通过address进行观察钱包
- (void)addAddress: (Address*)address json: (NSString*)json;

- (BOOL)removeAccount: (Account*)account;

// 通过address进行删除观察钱包
- (BOOL)removeAccountWithAddress: (Address *)address;

#pragma mark - Transactions (these present their own modal UI)

- (void)sendPayment: (Payment*)payment callback: (void (^)(Hash*, NSError*))callback;

- (void)sendTransaction: (Transaction*)transaction callback:(void (^)(Hash*, NSError*))callback;


#pragma mark - Debug

- (void)showDebuggingOptionsCallback: (void (^)())callback;


- (Account *)exportAccount:(Address*)address password:(NSString *)password;
- (NSString*)getJSON: (Address*)address;



// fft转账
//- (void)sendTTFTransaction:(Transaction *)transaction password:(NSString *)pwd callback:(void(^)(NSString *dataString))callback;


extern NSErrorDomain NAErrorDomain;

#define NAErrorUnknown              -1  // 未知错误
#define NAErrorKeyStore             -2  // 无效的keyStore
#define NAErrorMnemonic             -3  // 无效的助记词
#define NAErrorPrivateKey           -4  // 无效的私钥
#define NAErrorPassword             -5  // 密码错误
#define NAErrorNotPassword
#define NAError
#define NAError

/** 创建账户 */
- (void)createAccount:(NSString *)name password:(NSString *)password callback:(void (^)(NSString *json, Account *account))callback;

/** keyStore 导入 */
- (void)inputWithKeyStore:(NSString *)jsonStr password:(NSString *)password callback:(void (^)(Account *account, NSError *error))callback;

/** 助记词导入 */
- (void)inputWithMnemonicPhrase:(NSString *)mnemonicPhrase password:(NSString *)password callback:(void (^)(Account *account, NSError *error))callback;

/** 私钥导入 */
- (void)inputWithPrivateKey:(NSString *)privateKey password:(NSString *)password callback:(void (^)(Account *account, NSError *error))callback;

/** 通过已存在账户地址Address 反推账户Account */
- (void)getAccountWithAddresss:(Address *)address password:(NSString *)password callback:(void (^)(Account *account, NSError *error))callback;

/** 导出keyStore */
- (void)outputKeyStoreWithAddress:(Address *)address password:(NSString *)password callback:(void (^)(NSString *keyStoreJson, NSError *error))callback;

/** 导出助记词 */
- (void)outputMnemonicPhraseWithAddress:(Address *)address password:(NSString *)password callback:(void (^)(NSString *mnemonicPhrase, NSError *error))callback;

/** 导出私钥 */
- (void)outputPrivateKeyWithAddress:(Address *)address password:(NSString *)password callback:(void (^)(NSString *privateKey, NSError *error))callback;



@end
