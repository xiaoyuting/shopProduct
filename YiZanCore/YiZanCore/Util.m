//
//  Util.m
//  WeiDianApp
//
//  Created by zzl on 14/12/5.
//  Copyright (c) 2014年 allran.mine. All rights reserved.
//

#import "CustomDefine.h"
#import "Util.h"
#import <CommonCrypto/CommonDigest.h>
#import "RSA.h"

@implementation Util


+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

+ (BOOL)checkNum:(NSString *)numStr{
    
    if( [self isPureInt:numStr] || [self isPureFloat:numStr]){
        
        return YES;
        
    }
    return NO;
}


+(BOOL)checkSFZ:(NSString *)numStr
{
    if( numStr == nil || [numStr length] != 18 )
    {
        return NO;
    }
    
    char string_idnum[19];  // 身份证号码，最后一位留空，一会算出来最后一位
    
    char verifymap[] = "10X98765432";  // 加权乘积求和除以11的余数所对应的校验数
    
    int factor[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1};  // 加权因子
    
    long sum = 0l;  //加权乘积求和
    
    int m = 0;  // 加权乘积求和的模数
    
    char * p = string_idnum;  // 当前位置
    
    memset(string_idnum, 0, sizeof(string_idnum));  // 清零
    
    const char* snum = [numStr cStringUsingEncoding:NSASCIIStringEncoding];
    
    strcpy(string_idnum, snum);  // 本体码，也就是前17位
    string_idnum[17] = '\0';
    
    while(*p)  // 在 '\0' 之前一直成立
        
    {
        
        sum += (*p - '0') * factor[p - string_idnum];  // 加权乘积求和
        
        p++;  // 当前位置增加1
        
    }
    
    m = sum % 11;  // 取模
    
    return verifymap[m] == snum[17];
}
+(NSDate*)dateWithInt:(double)second
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date  dateByAddingTimeInterval: interval];
}
+(NSString*)getTimeStringHourSecond:(double)second
{
    return [Util getTimeStringHour: [Util dateWithInt:second] ];
}

+(NSString *)dateForint:(double)time bfull:(BOOL)bfull
{
    NSDate *date = [Util dateWithInt:time];
   return [Util getTimeString:date bfull:bfull];
}

+(NSDate*)getDataString:(NSString *)str bfull:(BOOL)bfull{

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: bfull ? @"yyyy-MM-dd HH:mm:ss" : @"yyyy-MM-dd HH:mm" ];
    NSDate *Date = [dateFormatter dateFromString:str];
    return Date;
}

+(NSString*)getTimeString:(NSDate*)dat bfull:(BOOL)bfull
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: bfull ? @"yyyy-MM-dd HH:mm:ss" : @"yyyy-MM-dd HH:mm" ];
    NSString *strDate = [dateFormatter stringFromDate:dat];
    if( bfull ) return strDate;
    
  //  NSString *nodatetring = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}
+(NSString*)getTimeStringWithP:(double)time
{
    NSDate *date = [Util dateWithInt:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [dateFormatter stringFromDate:date];
}

+(NSString*)getTimeStringHour:(NSDate*)dat   //date转字符串 2015-03-23 08:00
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:dat];
}

+(NSString*)getTimeStringDay:(double)time   //转字符串 2015-03-23
{
    NSDate *date = [Util dateWithInt:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+(NSString *) FormartTime:(NSDate*) compareDate 
{
    
    if( compareDate == nil ) return @"";
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = timeInterval;
    NSString *result;
    
    if (timeInterval < 60) {
        if( temp == 0 )
            result = @"刚刚";
        else
            result = [NSString stringWithFormat:@"%d秒前",(int)temp];
    }
    else if(( timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",(int)temp/60];
    }
    
    else if(( temp/86400) <30){
        
        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setDateFormat:@"dd"];
        NSString *str = [date stringFromDate:[NSDate date]];
        int nowday = [str intValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd"];
        NSString *strDate = [dateFormatter stringFromDate:compareDate];
        int day = [strDate intValue];
        if (nowday-day==0) {
            [dateFormatter setDateFormat:@"今天 HH:mm"];
            result =    [dateFormatter stringFromDate:compareDate];
        }
        else if(nowday-day==1)
        {
            
            [dateFormatter setDateFormat:@"昨天 HH:mm"];
            result =  [dateFormatter stringFromDate:compareDate];
            
            
        }
        
        
        else if( temp < 8 )
        {
            if (temp==1) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"昨天HH:mm"];
                NSString *strDate = [dateFormatter stringFromDate:compareDate];
                result = strDate;
            }
            else if(temp == 2)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"前天HH:mm"];
                NSString *strDate = [dateFormatter stringFromDate:compareDate];
                result = strDate;
            }
            
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            NSString *strDate = [dateFormatter stringFromDate:compareDate];
            result = strDate;
            
        }
    }
    else
    {//超过一个月的就直接显示时间了
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *strDate = [dateFormatter stringFromDate:compareDate];
        result = strDate;
    }
    
    /*
     else if((temp = (temp/(3600*24))/30) <12){
     result = [NSString stringWithFormat:@"%d个月前",(int)temp];
     }
     else{
     temp = temp/12;
     result = [NSString stringWithFormat:@"%d年前",(int)temp];
     }
     */
    
    return  result;
}

+(UIImage*)scaleImg:(UIImage*)org maxsizeW:(CGFloat)maxW //缩放图片,,最大多少
{
    
    UIImage* retimg = nil;
    
    CGFloat h;
    CGFloat w;
    
    if( org.size.width > maxW )
    {
        w = maxW;
        h = (w / org.size.width) * org.size.height;
    }
    else
    {
        w = org.size.width;
        h = org.size.height;
        return org;
    }
    
    UIGraphicsBeginImageContext( CGSizeMake(w, h) );
    
    [org drawInRect:CGRectMake(0, 0, w, h)];
    retimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return retimg;
}


//缩放图片
+(UIImage*)scaleImg:(UIImage*)org maxsize:(CGFloat)maxsize
{
    
    UIImage* retimg = nil;
    
    CGFloat h;
    CGFloat w;
    if( org.size.width > org.size.height )
    {
        if( org.size.width > maxsize )
        {
            w = maxsize;
            h = (w / org.size.width) * org.size.height;
        }
        else
        {
            w = org.size.width;
            h = org.size.height;
            return org;
        }
    }
    else
    {
        if( org.size.height > maxsize )
        {
            h = maxsize;
            w = (h / org.size.height) * org.size.width;
        }
        else
        {
            w = org.size.width;
            h = org.size.height;
            return org;
        }
    }
    
    UIGraphicsBeginImageContext( CGSizeMake(w, h) );
    
    [org drawInRect:CGRectMake(0, 0, w, h)];
    retimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return retimg;
}


//相对布局 base基准控件 dif间隔距离 tag要移动的控件 tagatdic tag在base的哪个位置
+(void)relPosUI:(UIView*)base dif:(CGFloat)dif tag:(UIView*)tag tagatdic:(RelDic)dic
{
    CGRect bf = base.frame;
    CGRect f = tag.frame;
    switch ( dic ) {
        case E_dic_l:
            f.origin.x = bf.origin.x - dif - f.size.width;
            break;
        case E_dic_r:
            f.origin.x = bf.origin.x + bf.size.width + dif;
            break;
        case E_dic_t:
            f.origin.y = bf.origin.y - f.size.height  - dif;
            break;
        case E_dic_b:
            f.origin.y = bf.origin.y + bf.size.height + dif;
            break;
            
        default:
            break;
    }
    
    tag.frame = f;
    
}
+(BOOL)checkPasswdPre:(NSString *)passwd
{
    if (passwd.length<6||passwd.length>20) {
        return NO;
    }
    return YES;
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{

    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * newMOBILE = @"^1(7[7])\\d{8}$";
    
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[23478])\\d)\\d{7}$";
    
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|4[57]|5[256]|76|8[156])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|7[0678]|8[019])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    //    NSString *yidong = @"10086";
    //    NSString *yidong1 = @"1008611";
    //
    //    NSString *liantong = @"10010";
    //    NSString *liantong1 = @"10011";
    //
    //    NSString *dianxin = @"10000";
    //    NSString *jijiu = @"120";
    //    NSString *baojing = @"110";
    //    NSString *huojing = @"119";
    //    NSString *baishitong = @"114";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestgh = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    //    NSPredicate *regextestyd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", yidong];
    //    NSPredicate *regextestyd1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", yidong1];
    //
    //    NSPredicate *regextestlt = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", liantong];
    //    NSPredicate *regextestlt1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", liantong1];
    //
    //    NSPredicate *regextestdx = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", dianxin];
    //    NSPredicate *regextestjj = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", jijiu];
    //    NSPredicate *regextestbj = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", baojing];
    //    NSPredicate *regextesthj = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", huojing];
    NSPredicate *regextestbs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", newMOBILE];
    
    
    //    NSPredicate *newregextestbs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", baishitong];
    
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestgh evaluateWithObject:mobileNum] == YES)
        
        //        || ([regextestyd evaluateWithObject:mobileNum] == YES)
        //        || ([regextestyd1 evaluateWithObject:mobileNum] == YES)
        
        //        || ([regextestlt evaluateWithObject:mobileNum] == YES)
        //        || ([regextestlt1 evaluateWithObject:mobileNum] == YES)
        
        //        || ([regextestdx evaluateWithObject:mobileNum] == YES)
        //        || ([regextestjj evaluateWithObject:mobileNum] == YES)
        //        || ([regextestbj evaluateWithObject:mobileNum] == YES)
        //        || ([regextesthj evaluateWithObject:mobileNum] == YES)
        || ([regextestbs evaluateWithObject:mobileNum] == YES)
        
        //        || ([newregextestbs evaluateWithObject:mobileNum] == YES)
        
        )
    {
        return YES;
    }
    else
    {
        return NO;
    }


}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)md5_16:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0+4], result[1+4], result[2+4], result[3+4],
            result[4+4], result[5+4], result[6+4], result[7+4]
            ];
}

+(void)md5_16_b:(NSString*)str outbuffer:(char*)outbuffer
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    memcpy(outbuffer, &result[4], 8);
}


+(NSDictionary*)delNUll:(NSDictionary*)dic
{
    NSArray* allk = dic.allKeys;
    NSMutableDictionary* tmp = NSMutableDictionary.new;
    for ( NSString* onek in allk ) {
        id v = [dic objectForKey:onek];
        if( [v isKindOfClass:[NSNull class] ] )
        {//如果是nsnull 不要
            continue;
        }
        
        if( [v isKindOfClass:[NSArray class]] || [v isKindOfClass: [NSMutableArray class]] )
        {
            NSArray* ta = [Util delNullInArr:v] ;
            [tmp setObject:ta forKey:onek];
            continue;
        }
        if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* td = [Util delNUll:v];
            [tmp setObject:td forKey:onek];
            continue;
        }
        [tmp setObject:v forKey:onek];
    }
    return tmp;
}
+(NSArray*)delNullInArr:(NSArray*)arr
{
    NSMutableArray* tmp = NSMutableArray.new;
    for ( id v in arr ) {
        if( [v isKindOfClass:[NSNull class] ] )
        {//如果是nsnull 不要
            continue;
        }
        if( [v isKindOfClass:[NSArray class]] || [v isKindOfClass: [NSMutableArray class]] )
        {
            NSArray* ta = [Util delNullInArr:v] ;
            [tmp addObject:ta];
            continue;
        }
        if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* td = [Util delNUll:v];
            [tmp addObject:td];
            continue;
        }
        [tmp addObject:v];
    }
    return tmp;
}

+(UIColor*)stringToColor:(NSString*)str
{
    if( str.length != 7 ) return nil;
    //#54fd13
    NSString* r = [str substringWithRange:NSMakeRange(1, 2)];
    unsigned long rv = strtoul( [r UTF8String] , NULL, 16);
    
    NSString* g = [str substringWithRange:NSMakeRange(3, 2)];
    unsigned long gv = strtoul( [g UTF8String] , NULL, 16);
    
    NSString* b = [str substringWithRange:NSMakeRange(5, 2)];
    unsigned long bv = strtoul( [b UTF8String] , NULL, 16);
    
    return ColorRGB(rv,gv,bv);
}

+(NSString*)getDistStr:(int)dist
{
    if( dist < 1000 )
        return [NSString stringWithFormat:@"%dm",dist];
    else if( dist < 1000*1000 )
        return [NSString stringWithFormat:@"%.2fkm",(float)dist/1000];
    else
        return @">1000km";
}

//MARK: sign
+ (NSString *)genWxSign:(NSDictionary *)signParams parentkey:(NSString*)parentkey
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    [sign appendFormat:@"key=%@",parentkey];
    
    return  [[Util md5:sign] uppercaseString];
}

//MARK: sign
+ (NSString *)genWXClientSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    return [Util sha1:signString];;
}

+ (NSString *)sha1:(NSString *)input
{
    const char *ptr = [input UTF8String];
    
    int i =0;
    int len = strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}


//requrl http://api.fun.com/getxxxx
//
+(NSString*)makeURL:(NSString*)requrl param:(NSDictionary*)param
{
    if( param.count == 0 ) return requrl;
    
    NSArray* allk = param.allKeys;
    NSMutableString* reqstr = NSMutableString.new;
    for ( NSString* onek in allk ) {
        [reqstr appendFormat:@"%@=%@&",onek,param[onek]];
    }
    return [NSString stringWithFormat:@"%@?%@",requrl,[reqstr substringToIndex:reqstr.length-2]];
}

//生成XML
+(NSString*)makeXML:(NSDictionary*)param
{
    if( param.count == 0 ) return @"";
    
    NSArray* allk = param.allKeys;
    NSMutableString* reqstr = NSMutableString.new;
    [reqstr appendString:@"<xml>\n"];
    for ( NSString* onek in allk ) {
        [reqstr appendFormat:@"<%@>%@</%@>\n",onek,param[onek],onek];
    }
    [reqstr appendString:@"</xml>"];
    return reqstr;
}

+(NSString*)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}



/*
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    
    // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
    return [addresses count] ? addresses : nil;
}

*/

+(int)gettopestV:(int)v
{
    int r = v;
    while ( r > 10 )
    {
        r  = r/10;
    }
    return r;
}


+(NSString*)URLEnCode:(NSString*)str
{
    NSString *resultStr = str;
    
    CFStringRef originalString = (__bridge CFStringRef) str;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if( escapedStr )
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}

+(NSString*)URLDeCode:(NSString*)str
{
    return [[str      stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


+ (NSString *)getAPPName{
    
    NSString *AppName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    
    return AppName;
    
}
+(void)autoExtendH:(UIView*)tagview dif:(CGFloat)dif
{//寻找所有子view,最底部的那个
    
    CGFloat offset = 0.0f;
    BOOL b = NO;
    for( UIView* one in tagview.subviews )
    {
        if( one.hidden ) continue;
        b = YES;
        CGFloat t   = one.frame.origin.y + one.frame.size.height;
        offset = t > offset ? t :offset;
    }
    
    if( !b ) return;
    
    CGRect f = tagview.frame;
    f.size.height = offset + dif;
    tagview.frame = f;
}
+(void)autoExtendH:(UIView*)tagview blow:(UIView*)subview dif:(CGFloat)dif
{
    CGRect f = tagview.frame;
    
    f.size.height = subview.frame.origin.y + subview.frame.size.height + dif;
    
    tagview.frame = f;
}

+ (NSString *)makeImgUrl:(NSString *)bigUrl w:(CGFloat)w h:(CGFloat)h{

    return [bigUrl stringByAppendingString:[NSString stringWithFormat:@"@%dw_%dh_1e_1c_1l.jpg",(int)w,(int)h]];
}

+ (NSString *)makeImgUrl:(NSString *)bigUrl tagImg:(UIView *)imgV{

    float scale = [UIScreen mainScreen].scale;
    if( scale == 0.0f )
        scale = 2.0f;
    return [self makeImgUrl:bigUrl w:imgV.bounds.size.width*scale h:imgV.bounds.size.height*scale];
}

+ (NSString *)makeImgUrl:(NSString *)bigUrl fixw:(CGFloat)fixw
{
    /*
     
     其他限制可以参考文档其他参数的详细描述。
     访问域名
     IMG开通Region和Endpoint对照表
     目前,IMG有以下几个数据中心(Region)对公众提供服务,各区域的访问域名(Endpoint)设置如下:
     1. 保存的最终格式只支持jpg, png, bmp, webp (注意gif默认保存成jpg)。
     2. 文件的大小限制在20MB。
     3. 对缩略后的图片的大小有限制,目标缩略图的宽与高的乘积不能超过4096 * 4096, 而且单边的长度
     不能超过4096 * 4。
     4. 管道目前限制在4个。
     
     
     这些是废话,没什么用,,
     */
    float scale = [UIScreen mainScreen].scale;
    if( scale == 0.0f )
        scale = 2.0f;
    
    CGFloat itw = fixw*scale;
    CGFloat ith = 0;
    if( itw > 4096 )
    {
        itw = 4096;
    }
    
    ith = 4096;
    
    return [Util makeImgUrl:bigUrl w:itw h:ith];
}




+ (NSString *) readPublicKey:(NSString *) keyName
{
    if (keyName == nil || [keyName isEqualToString:@""]) return nil;
    
    NSMutableArray *filenameChunks = [[keyName componentsSeparatedByString:@"."] mutableCopy];
    NSString *extension = filenameChunks[[filenameChunks count] - 1];
    [filenameChunks removeLastObject]; // remove the extension
    NSString *filename = [filenameChunks componentsJoinedByString:@"."]; // reconstruct the filename with no extension
    
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    
    NSString *keyStr = [NSString stringWithContentsOfFile:keyPath encoding:NSUTF8StringEncoding error:nil];
    
    return keyStr;
}

+(BOOL) verify:(NSString *) resultStr {
    
    //从NSString转化为NSDictionary
    NSData *resultData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    
    //获取生成签名的数据
    NSString *sign = data[@"sign"];
    NSString *signElements = data[@"data"];
    //NSString *pay_result = signElements[@"pay_result"];
    //NSString *tn = signElements[@"tn"];
    //转换服务器签名数据
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:sign options:0];
    //生成本地签名数据，并生成摘要
    //    NSString *mySignBlock = [NSString stringWithFormat:@"pay_result=%@tn=%@",pay_result,tn];
    NSData *dataOriginal = [[Util sha1:signElements] dataUsingEncoding:NSUTF8StringEncoding];
    //验证签名
    //TODO：此处如果是正式环境需要换成public_product.key
    NSString *pubkey =[Util readPublicKey:@"public_product.key"];
    OSStatus result=[RSA verifyData:dataOriginal sig:nsdataFromBase64String publicKey:pubkey];
    
    
    
    //签名验证成功，商户app做后续处理
    if(result == 0) {
        //支付成功且验签成功，展示支付成功提示
        return YES;
    }
    else {
        //验签失败，交易结果数据被篡改，商户app后台查询交易结果
        return NO;
    }
    
    return NO;
}

@end







