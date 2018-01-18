//
//  DDYAudioChange.m
//  DDYProject
//
//  Created by LingTuan on 17/11/28.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "DDYAudioChange.h"
#include "SoundTouch.h"
#include "WaveHeader.h"

@implementation DDYAudioChange

+ (id)changeConfig:(DDYACConfig)config audioData:(NSData *)data target:(id)target action:(SEL)action {
    return [[self alloc] initWithConfig:config audioData:data target:target action:action];
}

- (id)initWithConfig:(DDYACConfig)myConfig audioData:(NSData *)myData target:(id)myTarget action:(SEL)myAction {
    if (self = [super init]) {
        target = myTarget;
        action = myAction;
        config = myConfig;
        data   = myData;
    }
    return self;
}

- (void)main {
    soundtouch::SoundTouch mSoundTouch;
    mSoundTouch.setSampleRate(config.sampleRate);
    mSoundTouch.setChannels(1); 
    mSoundTouch.setTempoChange(config.tempoChange);
    mSoundTouch.setPitchSemiTones(config.pitch);
    mSoundTouch.setRateChange(config.rate);
    mSoundTouch.setSetting(SETTING_SEQUENCE_MS, 40);
    mSoundTouch.setSetting(SETTING_SEEKWINDOW_MS, 15); //寻找帧长
    mSoundTouch.setSetting(SETTING_OVERLAP_MS, 6); //重叠帧长
    
    NSMutableData *soundTouchDatas = [[NSMutableData alloc] init];
    
    if (data) {
        char *pcmData = (char *)data.bytes;
        NSUInteger pcmSize = data.length;
        NSUInteger nSamples = pcmSize/2;
        mSoundTouch.putSamples((short *)pcmData, (unsigned int)nSamples);
        short *samples = new short[pcmSize];
        int numSamples = 0;
        do {
            memset(samples, 0, pcmSize);
            numSamples = mSoundTouch.receiveSamples(samples, (unsigned int)pcmSize);
            [soundTouchDatas appendBytes:samples length:numSamples*2];
        } while (numSamples > 0);
        delete [] samples;
    }
    NSMutableData *wavDatas = [[NSMutableData alloc] init];
    NSUInteger fileLength = soundTouchDatas.length;
    void *header = createWaveHeader((int)fileLength, 1, config.sampleRate, 16);
    [wavDatas appendBytes:header length:44];
    [wavDatas appendData:soundTouchDatas];
    
    BOOL result = [wavDatas writeToFile:[DDYFileTool ddy_SoundTouchPath] atomically:YES];
    [soundTouchDatas release];
    [wavDatas release];
    if (result && !self.isCancelled) {
        [target performSelectorOnMainThread:action withObject:nil waitUntilDone:NO];
    }
}

@end



























