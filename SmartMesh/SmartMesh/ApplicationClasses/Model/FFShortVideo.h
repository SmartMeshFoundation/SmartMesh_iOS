//
//  NAShortVideo.h
//  FireFly
//
//  Created by Rain on 17/11/29.
//  Copyright © 2017年 SmartMesh Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFShortVideo : NSObject


@property(nonatomic,strong) NSString * videoName;
@property(nonatomic,assign) NSString * imageUrl;
@property(nonatomic,strong) NSString * localVideoUrl;
@property(nonatomic,assign) NSInteger  isLocal;
@property(nonatomic,strong) NSString * remotingurl;
@property(nonatomic,strong) NSString * oldName; 
@property(nonatomic,assign) NSInteger time;

-(instancetype) initWithDictionary:(NSDictionary *)dic;


@end
