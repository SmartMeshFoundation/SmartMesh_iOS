//  Created by R on 18/3/7.
//  Copyright © 2018年 SmartMesh Foundation rights reserved.
//

#import "UEBaseData.h"
#import "UEReadDataPack.h"

NSString *const EStorageFilePath = @"BLEStorage";

@interface UEBaseData (){
    
    UEReadDataPack *_extDataReadPack; //扩展字段读取
    UEReadDataPack *_bodyDataReadPack; //body字段读取
    NSFileHandle*  outFile;
}

@end


@implementation UEBaseData

- (id)init{

    if (self=[super init]) {
        self.bodyData=[[NSMutableData alloc] initWithCapacity:1024];
    }
    return self;
}

/**
 *  解码处理
 *
 *  @param characteristicValue 需要解码的数据
 *
 *  @return
 */
- (id)initWithData:(NSData *)characteristicValue{
    if (self=[super init]) {
        
        NSUInteger currentTotalLen=characteristicValue.length; //当前总的数据长度
        
        //指令码
        self.packetId=[UEBaseData readByte:characteristicValue];
        characteristicValue=[characteristicValue subdataWithRange:NSMakeRange(1,characteristicValue.length-1)];
        
        NSLog(@"packetId：%lu",(unsigned long)self.packetId);
        
        /***********************************扩展字段读取****************************************/
        if (!_extDataReadPack) {
            _extDataReadPack=[[UEReadDataPack alloc] init];
        }
        //扩展字段长度
        _extDataReadPack.bodyLen=[UEBaseData readShort:characteristicValue];
        _extDataReadPack.totalLen=2;
        _extDataReadPack.readTotalLen=2;
        _extDataReadPack.isTotalReadFinished=YES;
        
        characteristicValue=[characteristicValue subdataWithRange:NSMakeRange(2, characteristicValue.length-2)];
        
        //已读取的字节长度
        NSInteger readLen=currentTotalLen-characteristicValue.length;


        if (_extDataReadPack.bodyLen>0) {
            if (currentTotalLen-readLen>=_extDataReadPack.bodyLen) { //表示刚好读完
                _extDataReadPack.readBodyLen=_extDataReadPack.bodyLen;
                _extDataReadPack.isBodyReadFinished=YES;
                _extDataReadPack.isReadFinished=YES;
            }else{ //表示不够读取
                _extDataReadPack.readBodyLen=_extDataReadPack.bodyLen-(currentTotalLen-readLen);
            }
            
            NSData *part=[characteristicValue subdataWithRange:NSMakeRange(0, _extDataReadPack.readBodyLen)];
            [_extDataReadPack.readBodyData appendData:part];
            
            if (_extDataReadPack.isBodyReadFinished) { //扩展内容已读完
                self.extStr=[[NSString alloc] initWithData:part encoding:NSUTF8StringEncoding];
                NSLog(@"文件名为：%@",self.extStr);
            }

            characteristicValue=[characteristicValue subdataWithRange:NSMakeRange(_extDataReadPack.readBodyLen, characteristicValue.length-_extDataReadPack.readBodyLen)];
            readLen+=part.length;
        }else{
            _extDataReadPack.readBodyLen=_extDataReadPack.bodyLen;
            _extDataReadPack.isBodyReadFinished=YES;
            _extDataReadPack.isReadFinished=YES;
        }
        
        
        if (!self.bodyData) {
            self.bodyData=[[NSMutableData alloc] initWithCapacity:1024];
        }
        
        //body内容读取处理
        if (!_bodyDataReadPack) {
            _bodyDataReadPack=[[UEReadDataPack alloc] init];
        }
        
        if (currentTotalLen-readLen>=4) { //可以读取到长度
            _bodyDataReadPack.bodyLen=[UEBaseData readInt:[characteristicValue subdataWithRange:NSMakeRange(0,4)]];
            characteristicValue=[characteristicValue subdataWithRange:NSMakeRange(4, characteristicValue.length-4)];
            
            if (characteristicValue&&[characteristicValue length]>0) {
                [self.bodyData appendData:characteristicValue];
            }
            
            _bodyDataReadPack.totalLen=4;
            _bodyDataReadPack.readTotalLen=4;
            _bodyDataReadPack.isTotalReadFinished=YES;
            
            _bodyDataReadPack.readBodyLen=characteristicValue.length;
            
            if (_bodyDataReadPack.bodyLen==_bodyDataReadPack.readBodyLen) { //表示数据接收完成
                _bodyDataReadPack.isBodyReadFinished=YES;
                _bodyDataReadPack.isReadFinished=YES;
            }
            
            NSLog(@"bodyLen：%lu",(unsigned long)_bodyDataReadPack.bodyLen);
        }else{ //读取不到长度
            _bodyDataReadPack.totalLen=4;
            _bodyDataReadPack.readTotalLen=currentTotalLen-readLen;
            [_bodyDataReadPack.readTotalData appendData:characteristicValue];
        }
        
        
    }
    
    return self;
}

/**
 *  蓝牙解码处理
 *
 *  @param characteristicValue 需要解码的数据
 *
 *  @return
 */
+ (id)decodeWithData:(NSData *)characteristicValue{
    if (characteristicValue&&[characteristicValue length]>0) {
        
        NSUInteger bleId=[UEBaseData readByte:characteristicValue];
        if (bleId==1||bleId==2) {
            return [[self alloc] initWithData:characteristicValue];
        }
    }
    return nil;
}


/**
 *  蓝牙编码处理
 *
 *  @return
 */
- (NSData *)encodeData{

    NSMutableData *mulData=[NSMutableData dataWithCapacity:1024];
    //指令码
    [UEBaseData writeByte:mulData value:self.packetId];
    //扩展内容
    [UEBaseData writetring:mulData str:self.extStr];
    //body长度
    [UEBaseData writeInt:mulData value:self.bodyData.length];
    //body内容
    if (self.bodyData&&[self.bodyData length]>0) {
        [mulData appendData:self.bodyData];
    }
    
    return mulData;
}

/**
 *  添加接收或者发送数据内容
 *
 *  @param data
 */
- (void)addReadData:(NSData *)data{
    
    if (data.length==0||data==nil) {
        return;
    }
    
    //扩展内容未读取完成
    if (!_extDataReadPack.isReadFinished) {
        
        if (!_extDataReadPack.isBodyReadFinished) {
            NSUInteger len=_extDataReadPack.bodyLen-_extDataReadPack.readBodyLen;
            if (len<=data.length) { //读取完成
                _extDataReadPack.readBodyLen+=len;
                _extDataReadPack.isBodyReadFinished=YES;
                _extDataReadPack.isReadFinished=YES;
                [_extDataReadPack.readBodyData appendData:[data subdataWithRange:NSMakeRange(0, len)]];
                data=[data subdataWithRange:NSMakeRange(len, data.length-len)];
                
                self.extStr=[[NSString alloc] initWithData:_extDataReadPack.readBodyData encoding:NSUTF8StringEncoding];
                
            }else{
                _extDataReadPack.readBodyLen+=data.length;
                [_extDataReadPack.readBodyData appendData:data];
            }
        }
    }
    
    if (data.length==0) {
        return;
    }
    
    
    //body内容长度未读取完成
    if (!_bodyDataReadPack.isReadFinished) {
        
        //表示body长度未读取到
        if (!_bodyDataReadPack.isTotalReadFinished) {
            NSUInteger len=_bodyDataReadPack.totalLen-_bodyDataReadPack.readTotalLen;
            if (len<=data.length) {
                _bodyDataReadPack.readTotalLen+=len;
                _bodyDataReadPack.isTotalReadFinished=YES;
                [_bodyDataReadPack.readTotalData appendData:[data subdataWithRange:NSMakeRange(0, len)]];
                
                _bodyDataReadPack.bodyLen=[UEBaseData readInt:_bodyDataReadPack.readTotalData];
                
                data=[data subdataWithRange:NSMakeRange(len, data.length-len)];
            }else{
                _bodyDataReadPack.readTotalLen+=data.length;
                [_bodyDataReadPack.readTotalData appendData:data];
            }
            
        }
    }
    
    if (data.length==0) {
        return;
    }
    
    //body内容读取完成
    if (!_bodyDataReadPack.isReadFinished){
        if (_bodyDataReadPack.isTotalReadFinished&&!_bodyDataReadPack.isBodyReadFinished) {
            _bodyDataReadPack.readBodyLen+=data.length;
            [self.bodyData appendData:data];
            if (_bodyDataReadPack.readBodyLen==_bodyDataReadPack.bodyLen) {
                _bodyDataReadPack.isBodyReadFinished=YES;
                _bodyDataReadPack.isReadFinished=YES;
                if (self.packetId==2) {
                    [self writeDataToFile:self.bodyData];
                }
                NSLog(@"接收或者发送数据data完成");
            }
            
        }
    }
}


/**
 *  取得扩展内容
 *
 *  @return
 */
- (NSString *)getExtString{

    if (self.extStr&&[self.extStr isKindOfClass:[NSString class]]&&[self.extStr length]>0) {
        return self.extStr;
    }
    return @"";
}

/**
 *  取得发送或者接收进度
 *
 *  @return
 */
- (float)progress{
    if (_bodyDataReadPack) {
        return _bodyDataReadPack.progress;
    }
    return 0.0;
}

/**
 *  接收或者发送是否完成
 *
 *  @return
 */
- (BOOL)isFinished{
    if (_bodyDataReadPack){
    
        return _bodyDataReadPack.isReadFinished;
    }
    return NO;
}

/**
 *  取得保存的文件
 *
 *  @return
 */
- (NSString *)getCacheFilePath{
    NSString *path=[self getReceiveFilePath];
    NSString* targetFile = [path stringByAppendingPathComponent:self.extStr];
    return targetFile;
}

/**
 *  接收文件保存路径
 *
 *  @return 接收文件路径
 */
- (NSString*)getReceiveFilePath{
    //获取用户域覆径信息
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:EStorageFilePath];
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        //创建一个新的目录
        BOOL res=[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        
        if (res) {
            NSLog(@"文件夹创建成功");
        }else{
            NSLog(@"文件夹创建失败");
        }
    }
    return path;
}

/**
 *  将数据写入文件中
 *  @param data  要保存的数据
 */
- (void)writeDataToFile:(NSData *)data{
    
    if(!outFile){
        //获取用户域覆径信息
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *path = [documentsDirectory stringByAppendingPathComponent:EStorageFilePath];
        
        NSFileManager *fileManager =[NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path]) {
            //创建一个新的目录
            BOOL res=[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            
            if (res) {
                NSLog(@"文件夹创建成功");
            }else{
                NSLog(@"文件夹创建失败");
            }
        }
        
        NSString* targetFile = [path stringByAppendingPathComponent:self.extStr];
        {
            BOOL res=[fileManager createFileAtPath:targetFile contents:nil attributes:nil];
            if (res) {
                NSLog(@"文件创建成功: %@" ,targetFile);
            }else{
                NSLog(@"文件创建失败");
            }
        }
        
        //写入文件
        outFile = [NSFileHandle fileHandleForWritingAtPath:targetFile];
        //将文件的字节设置为0，因为他可能包含数据
        [outFile truncateFileAtOffset:0];
        
        // NSString* targetFile = [NSString initWithFormat:@"%@%@", , string2
    }
    
    
    {
        
        if(outFile!=nil){
            
            //将读取的内容内容写到outFile.txt中
            [outFile writeData:data];
            
            //关闭输出
            //[outFile closeFile];
        }
    }
    
}



#pragma mark -辅助方法
+ (NSUInteger)readByte:(NSData *)data{
    Byte *b = (Byte *)[data bytes];
    NSUInteger value = b[0]&0xff;
    return value;
}

+ (NSUInteger)readShort:(NSData *)data{
    Byte *b = (Byte *)[data bytes];
    NSUInteger value = (int) (((int)(b[0]&0xff))|(((int)(b[1]&0xff))<<8));
    return value;
}

+ (NSUInteger)readInt:(NSData *)data{
    Byte *b = (Byte *)[data bytes];
    NSUInteger value = (int) (((int)(b[0]&0xff))|(((int)(b[1]&0xff))<<8)|(((int)(b[2]&0xff))<<16)|(((int)(b[3]&0xff))<<24));
    return value;
}

+ (NSString*)readString:(NSData *)data{
    return nil;
}

+ (void)writeByte:(NSMutableData *)data value:(NSUInteger)aValue{
    Byte b[1];
    b[0] = (Byte) (aValue & 0xff);
    [data appendBytes:b length:1];
}

+ (void)writeShort:(NSMutableData *)data value:(NSUInteger)aValue{
    Byte b[2];
    b[0] = (Byte) (aValue & 0xff);
    b[1] = (Byte) ((aValue >> 8) & 0xff);
    [data appendBytes:b length:2];
}

+ (void)writeInt:(NSMutableData *)data value:(NSUInteger)aValue{
    
    Byte b[4];
    b[0] = (Byte) (aValue & 0xff);
    b[1] = (Byte) ((aValue >> 8) & 0xff);
    b[2] = (Byte) ((aValue >> 16) & 0xff);
    b[3] = (Byte) ((aValue >> 24) & 0xff);
    [data appendBytes:b length:4];
     
    
}

+ (void)writetring:(NSMutableData *)data str:(NSString*)aStr{
    if (aStr == nil || aStr.length == 0) {
        [self writeShort:data value:0];
        return;
    }
    NSData *buf = [aStr dataUsingEncoding:NSUTF8StringEncoding];
    [self writeShort:data value:buf.length];
    [data appendData:buf];
}

@end
