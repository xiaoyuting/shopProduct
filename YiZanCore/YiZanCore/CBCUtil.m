//
//  CBCUtil.m
//  YiZanService
//
//  Created by zzl on 15/4/1.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "CBCUtil.h"
#import "Util.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"




@implementation CBCUtil


+ (NSString*)addPadding:(NSString*)orgdata
{
    NSUInteger sss = orgdata.length;
    NSUInteger pad = 16 - ( sss % 16  );
    NSMutableString* strret = NSMutableString.new;
    [strret appendString:orgdata];
    for ( int j = 0 ; j < pad; j++) {
        [strret appendFormat:@"%c",(char)pad];
    }
    return strret;
}
+(char*)addPaddingbyte:(const char*)orgptr
{
    NSUInteger sss = strlen(orgptr);
    int pad = 16 - ( sss % 16  );
    char* tempbuff = malloc( sss +17);
    memset(tempbuff, 0, sss + 17);
    memcpy(tempbuff, orgptr, sss);
    for( int j = 0 ;j < pad;j++)
        tempbuff[sss+j] = pad;
    
    return tempbuff;
}
+(NSString*)stripPading:(NSString*)data
{
    //$pad = ord($value[($len = strlen($value)) - 1]);
    char pad = [data characterAtIndex: data.length-1];
    BOOL bvalidPading = [CBCUtil paddingIsValid:pad value:data];
    
    //return $this->paddingIsValid($pad, $value) ? substr($value, 0, $len - $pad) : $value;
    return bvalidPading ? [data substringToIndex: data.length- pad ] : data;
}
+(BOOL)paddingIsValid:(char)pad value:(NSString*)value
{
    NSInteger beforePad = value.length - (unsigned short)pad;
    NSString* as = [value substringFromIndex:beforePad];
    char bc = [value characterAtIndex:value.length-1];
    NSMutableString* strret = NSMutableString.new;
    for ( int j = 0 ; j < pad; j++) {
        [strret appendFormat:@"%c",bc];
    }
    
    return [as isEqualToString:strret];
    
    //return substr($value, $beforePad) == str_repeat(substr($value, -1), $pad);
}

+(NSString*)getIV:(NSString*)key index:(int)index
{
    NSString* rando = [key substringWithRange:NSMakeRange(index, 16)];
    rando = [rando stringByAppendingString:key];
    rando = [Util md5:rando];
    return [rando substringWithRange:NSMakeRange(index, 16)];
}
+ (NSString*) CBCEncrypt:(NSString *)plainText key:(NSString*)ptKey index:(int)index
{
    char keyPtr[kCCKeySizeAES256+1] ={0};
    memset(keyPtr, 0, sizeof(keyPtr));
    [ptKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1] = {0};
    NSString* striv = [CBCUtil getIV:ptKey index:index];
    [striv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    
    char* dataPtr = [CBCUtil addPaddingbyte:[plainText UTF8String]];
    NSUInteger dataLength = strlen( dataPtr);
    
    //[padingstr getCString:dataPtr maxLength:dataLength encoding:NSUTF8StringEncoding];
    //memcpy(dataPtr, [data bytes], dataLength);
   
    
    size_t bufferSize = dataLength*10;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0,               //No padding
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          ivPtr,
                                          dataPtr,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    free(dataPtr);
    if ( cryptStatus == kCCSuccess ) {
        
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString* strret = [GTMBase64 stringByEncodingData:resultData];
       
        NSString* string2 = strret;//[Util URLEnCode:strret];
        
        return string2;
    }
    free(buffer);
    return nil;
}


+ (NSString*) CBCDecrypt:(NSString *)encryptText key:(NSString*)ptKey index:(int)index
{
    char keyPtr[kCCKeySizeAES256 + 1] ={0};
    memset(keyPtr, 0, sizeof(keyPtr));
    [ptKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1] ={0};
    memset(ivPtr, 0, sizeof(ivPtr));
    [[CBCUtil getIV:ptKey index:index] getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSString *durldecode = encryptText;//[Util URLDeCode:encryptText];
    
    NSData *data = [GTMBase64 decodeData:[durldecode dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString* str = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        str =  [CBCUtil stripPading:str];
        
        return str;
    }
    free(buffer);
    return nil;
}



@end
