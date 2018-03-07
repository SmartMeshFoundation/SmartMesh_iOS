//  Created by R on 18/3/7.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import <Foundation/Foundation.h>

@interface UEReadDataPack : NSObject

@property (nonatomic,assign) NSUInteger totalLen;
@property (nonatomic,assign) NSUInteger readTotalLen;
@property (nonatomic,assign) BOOL isTotalReadFinished;
@property (nonatomic,strong) NSMutableData *readTotalData;

@property (nonatomic,assign) NSUInteger bodyLen;
@property (nonatomic,assign) NSUInteger readBodyLen;
@property (nonatomic,strong) NSMutableData *readBodyData;
@property (nonatomic,assign) BOOL isBodyReadFinished;

@property (nonatomic,assign) BOOL isReadFinished;
@property (nonatomic,readonly) float progress;

@end
