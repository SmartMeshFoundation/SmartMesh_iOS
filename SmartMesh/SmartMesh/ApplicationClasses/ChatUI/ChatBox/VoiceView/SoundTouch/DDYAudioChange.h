//
//  DDYAudioChange.h
//  DDYProject
//
//  Created by LingTuan on 17/11/28.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct ACConfig {
    int sampleRate;     // 采样率 <这里使用8000 原因: 录音是采样率:8000>
    int tempoChange;    // 速度 <变速不变调> [-50, 100]
    int pitch;          // 音调 <男:-8 女:8> [-12, 12]
    int rate;           // 声音速率 [-50, 100]
} DDYACConfig;

CG_INLINE DDYACConfig
DDYACMake(int sampleRate, int tempoChange, int pitch, int rate)
{
    DDYACConfig config;
    config.sampleRate = sampleRate;
    config.tempoChange = tempoChange;
    config.pitch = pitch;
    config.rate = rate;
    return config;
}

@interface DDYAudioChange : NSOperation
{
    id target;
    SEL action;
    NSData *data;
    DDYACConfig config;
}

+ (id)changeConfig:(DDYACConfig)config audioData:(NSData *)data target:(id)target action:(SEL)action;

@end
