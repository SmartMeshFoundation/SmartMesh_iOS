//
//  NAShortVideo.m
//  FireFly
//
//  Created by Rain on 17/11/29.
//  Copyright © 2017年 SmartMesh Foundation. All rights reserved.
//

#import "FFShortVideo.h"

@implementation FFShortVideo

-(instancetype) initWithDictionary:(NSDictionary *)dic{

    if (self = [super init]) {
        
        self.videoName = [dic objectForKey:@"name"];
        self.imageUrl = [dic objectForKey:@"image"];
        self.localVideoUrl = [dic objectForKey:@"videourl"];
        self.isLocal = [[dic objectForKey:@"local"] integerValue];
        self.remotingurl = [dic objectForKey:@"remotingurl"];
        self.time = [[dic objectForKey:@"timestamp"] integerValue];
    }

    return self;
}


@end
