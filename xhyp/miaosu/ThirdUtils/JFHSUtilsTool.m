//
//  JFHSUtilsTool.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/24.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFHSUtilsTool.h"
#import <CommonCrypto/CommonDigest.h>
NSString * const KEY_UDID_INSTEAD = @"com.jbb.xjl.udid";
@implementation JFHSUtilsTool
+ (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (trimedStr.length == 0) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
  
}
/**
 *  正则表达式验证手机号
 *
 *
 */
+ (BOOL)checkTelNumber:(NSString *)telNumber{
    //移动号段
//    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//    //联通号段
//    NSString *CU_NUM =  @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//    //电信号段
//    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
//    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//    BOOL isMatch1 = [pred1 evaluateWithObject:telNumber];
//    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//    BOOL isMatch2 = [pred2 evaluateWithObject:telNumber];
//    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//    BOOL isMatch3 = [pred3 evaluateWithObject:telNumber];
//    if (isMatch1 || isMatch2 || isMatch3) {
//        return YES;
//    } else {
//
//        return NO;
//    }
//    return NO;
    NSString *pattern = @"^1+\\d{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}
+(NSMutableAttributedString *)attributedString:(NSString *)allStr selectedStr:(NSString *)str selctedColor:(NSString *)colorStr haspreStr:(nonnull NSString *)preStr{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:allStr];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:colorStr] range:NSMakeRange(preStr.length , str.length)];
    return att;
}
+(BOOL)validateIdentityCard:(NSString *)identityCard{
    
//    NSString*pattern =@"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
//
//    NSPredicate*pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
//
//    BOOL isMatch = [pred evaluateWithObject:identityCard];
//
//    return isMatch;
    
    if (identityCard.length != 18) return NO;
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityStringPredicate evaluateWithObject:identityCard]) return NO;
  NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
        
    }
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
    {
        return NO;
        
    }
        
    }else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
            
        }
        
    }
    return YES;
    
    
}
+(NSString *)getIdentityCardAge:(NSString *)numberStr{
    NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
     NSDate *date = [NSDate date];
    [formatterTow setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatterTow stringFromDate:date];
    NSString *birdty  = [self birthdayStrFromIdentityCard:numberStr];
    NSString *currentMonth = [dateStr substringWithRange:NSMakeRange(5, 2)];
    NSString *birthMonth   =[birdty substringWithRange:NSMakeRange(5, 2)];
    NSString *currentYear = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *birthYear   =[birdty substringWithRange:NSMakeRange(0, 4)];
    int age;
    if ([currentMonth intValue] >  [birthMonth intValue]) {
    //如果当前月份 比身份上的月份大  年纪直接用年相减
       age  = [currentYear intValue]-[birthYear intValue];
        
    }else{
         age  = [currentYear intValue]-[birthYear intValue] - 1;
    }
    return  [NSString stringWithFormat:@"%d",age];
}


+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr

{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    
    NSString *year = nil;
    
    NSString *month = nil;
    BOOL isAllNumber = YES;
    
    NSString *day = nil;
    
    if([numberStr length]<14)
        
        return result;
    
    if (numberStr.length == 18) {
        
        //**截取前14位
        
        NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
        //**检测前14位否全都是数字;
        
        const char *str = [fontNumer UTF8String];
        
        const char *p = str;
        
        while (*p!='\0') {
            
            if(!(*p>='0'&&*p<='9'))
                
                isAllNumber = NO;
            
            p++;
            
        }
        if(!isAllNumber)
            
            return result;
        year = [numberStr substringWithRange:NSMakeRange(6, 4)];
        
        month = [numberStr substringWithRange:NSMakeRange(10, 2)];
        
        day = [numberStr substringWithRange:NSMakeRange(12,2)];
        [result appendString:year];
        
        [result appendString:@"-"];
        
        [result appendString:month];
        
        [result appendString:@"-"];
        
        [result appendString:day];
        
        return result;
    }else{
        
        NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 11)];
        //**检测前14位否全都是数字;
        
        const char *str = [fontNumer UTF8String];
        
        const char *p = str;
        
        while (*p!='\0') {
            
            if(!(*p>='0'&&*p<='9'))
                
                isAllNumber = NO;
            
            p++;
            
        }
        if(!isAllNumber)
            
            return result;
        year = [numberStr substringWithRange:NSMakeRange(6, 2)];
        
        month = [numberStr substringWithRange:NSMakeRange(8, 2)];
        
        day = [numberStr substringWithRange:NSMakeRange(10,2)];
        NSString* resultAll = [NSString stringWithFormat:@"19%@-%@-%@",year,month,day];
        
        return resultAll;
    }
}
+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
+(NSString *)conectUrl:(NSMutableDictionary *)params url:(NSString *)urlLink{
    //初始化参数变量
    NSString  *str = @"?";
    //遍历参数数组
    for (id key in params) {
        str  = [str stringByAppendingString:key];
        str = [str stringByAppendingString:@"="];
        str  = [str stringByAppendingString:[params objectForKey:key]];
        str= [str stringByAppendingString:@"&"];
    }
    //x处理u多余的&以及返回含参数URL
    if (str.length > 1) {
        //去除末尾的&
        str= [str  substringToIndex:str.length -1];
        //返回含参数URL
        NSString * encodedString = [[urlLink stringByAppendingString:str] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return encodedString;
        
    }
    
    return Nil;
}
+(void)submitSensorsAnalytics:(NSString *)typeStr parameter:(NSDictionary *)parameterDic{
     [[SensorsAnalyticsSDK sharedInstance]track:typeStr withProperties:parameterDic];
}
+ (NSString*)iphoneType {
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])return@"iPhone 2G";
    
    else if([platform isEqualToString:@"iPhone1,2"])return@"iPhone 3G";
    
    else if([platform isEqualToString:@"iPhone2,1"])return@"iPhone 3GS";
    
    else  if([platform isEqualToString:@"iPhone3,1"])return@"iPhone 4";
    
    else if([platform isEqualToString:@"iPhone3,2"])return@"iPhone 4";
    
    else if([platform isEqualToString:@"iPhone3,3"])return@"iPhone 4";
    
    else if([platform isEqualToString:@"iPhone4,1"])return@"iPhone 4S";
    
    else if([platform isEqualToString:@"iPhone5,1"])return@"iPhone 5";
    
    else if([platform isEqualToString:@"iPhone5,2"])return@"iPhone 5";
    
    else if([platform isEqualToString:@"iPhone5,3"])return@"iPhone 5c";
    
    else  if([platform isEqualToString:@"iPhone5,4"])return@"iPhone 5c";
    
    else if([platform isEqualToString:@"iPhone6,1"])return@"iPhone 5s";
    
    else if([platform isEqualToString:@"iPhone6,2"])return@"iPhone 5s";
    
    else if([platform isEqualToString:@"iPhone7,1"])return@"iPhone 6 Plus";
    
    else if([platform isEqualToString:@"iPhone7,2"])return@"iPhone 6";
    
    else if([platform isEqualToString:@"iPhone8,1"])return@"iPhone 6s";
    
    else if([platform isEqualToString:@"iPhone8,2"])return@"iPhone 6s Plus";
    
    else  if([platform isEqualToString:@"iPhone8,4"])return@"iPhone SE";
    
    else if([platform isEqualToString:@"iPhone9,1"])return@"iPhone 7";
    
    else  if([platform isEqualToString:@"iPhone9,2"])return@"iPhone 7 Plus";
    
    else  if([platform isEqualToString:@"iPhone10,1"])return@"iPhone 8";
    
    else  if([platform isEqualToString:@"iPhone10,4"])return@"iPhone 8";
    
    else if([platform isEqualToString:@"iPhone10,2"])return@"iPhone 8 Plus";
    
    else  if([platform isEqualToString:@"iPhone10,5"])return@"iPhone 8 Plus";
    
    else  if([platform isEqualToString:@"iPhone10,3"])return@"iPhone X";
    
    else if  ([platform isEqualToString:@"iPhone10,6"])return@"iPhone X";
    else if([platform isEqualToString:@"i386"])return@"iPhone Simulator";
    
    else if([platform isEqualToString:@"x86_64"])return@"iPhone Simulator";
    
    return platform;
    
}

/**
 异或加密
 
 @param plainText 要加密的字符串
 @param secretKey 秘钥
 @return 加密后返回的字符传
 */
+ (NSString *)stringXOREncryptWithPlainText:(NSString *)plainText secretKey:(NSString *)secretKey {
    
    NSData *codeKeyData =  [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    Byte codeKeyByteAry[codeKeyData.length];
    for (int i = 0 ; i < codeKeyData.length; i++) {
        NSData *idata = [codeKeyData subdataWithRange:NSMakeRange(i, 1)];
        codeKeyByteAry[i] =((Byte*)[idata bytes])[0];
    }
    
    NSMutableData *returnData = [[NSMutableData alloc] init];
    
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    // 对需要加密的数据进行转义
    plainText = [plainText stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    NSData *strData =  [plainText dataUsingEncoding:NSUTF8StringEncoding];
    for (int i = 0 ; i < strData.length; i++) {
        NSData *idata = [strData subdataWithRange:NSMakeRange(i, 1)];
        Byte byte =((Byte*)[idata bytes])[0];
        Byte byte2 = codeKeyByteAry[i%codeKeyData.length];
        Byte returnbyte = byte^byte2;
        Byte returnbyteAry[1];
        returnbyteAry[0] = returnbyte;
        [returnData appendBytes:returnbyteAry length:1];
    }
    NSString *returnStr =  [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return returnStr;
}

/**
 异或解密
 */
+(NSString *)stringXORDeocodeWithPlainText:(NSString *)plaintext secretKey:(NSString *)secretKey {
    
    NSData *codeKeyData =  [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    Byte codeKeyByteAry[codeKeyData.length];
    for (int i = 0 ; i < codeKeyData.length; i++) {
        NSData *idata = [codeKeyData subdataWithRange:NSMakeRange(i, 1)];
        codeKeyByteAry[i] =((Byte*)[idata bytes])[0];
    }
    
    NSData *strData =  [plaintext dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *returnData = [[NSMutableData alloc] init];
    for (int i = 0 ; i < strData.length; i++) {
        NSData *idata = [strData subdataWithRange:NSMakeRange(i, 1)];
        Byte byte =((Byte*)[idata bytes])[0];
        Byte byte2 = codeKeyByteAry[i%codeKeyData.length];
        Byte returnbyte = byte^byte2;
        Byte returnbyteAry[1];
        returnbyteAry[0] = returnbyte;
        [returnData appendBytes:returnbyteAry length:1];
    }
    NSString *returnStr =  [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    // 要移除转义
    returnStr = [returnStr stringByRemovingPercentEncoding];
    return returnStr;
}
//url编码
+ (NSString *)UrlValueEncode:(NSString *)str{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)str,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    
    return result;
}
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark - 获取path路径下文件夹大小
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path{
    
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    
    for (NSString *subPath in subPathArr){
        
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}
#pragma mark - 清除path文件夹下缓存大小
+ (BOOL)clearCacheWithFilePath:(NSString *)path{
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}


//获取通讯录数组

+(NSArray *)getIOS9BeforeAddressBooks
{
    
    NSMutableArray *peopleArray = [NSMutableArray array];
    
    int __block tip = 0;
    
    ABAddressBookRef addBook = nil;
    
    addBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error){
        if (!greanted) {
            tip = 1;
        }
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (tip) {
        //        ChooseAlertShow(@"请您设置允许APP访问您的通讯录\n设置>通用>隐私");
        return nil;
    }
    
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    
    CFIndex number = ABAddressBookGetPersonCount(addBook);
    
    for (int i = 0; i < number; i++) {
        
        ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
        
        CFTypeRef abName = ABRecordCopyValue(people, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(people, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(people);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        //读取电话多值
        NSString *phoneStr = @"";
        ABMultiValueRef phone = ABRecordCopyValue(people, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            //            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            
            phoneStr = [phoneStr stringByAppendingFormat:@"%@ ",personPhone];
        }
        
        NSString * note = (__bridge NSString*)(ABRecordCopyValue(people, kABPersonNoteProperty));
        
        NSString *email = @"";
        //获取email多值
        ABMultiValueRef emailRef = ABRecordCopyValue(people, kABPersonEmailProperty);
        
        for (int x = 0; x < ABMultiValueGetCount(emailRef); x++)
        {
            //获取email Label
            //            NSString* emailLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(emailRef, x));
            //获取email值
            email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emailRef, x);
            
            
        }
        //读取jobtitle工作
        NSString *jobtitle = (__bridge NSString*)ABRecordCopyValue(people, kABPersonJobTitleProperty);
        
        //读取nickname呢称
        NSString *nickname = (__bridge NSString*)ABRecordCopyValue(people, kABPersonNicknameProperty);
        
        NSString * organization = (__bridge NSString*)(ABRecordCopyValue(people, kABPersonOrganizationProperty));
        
        NSDate *birthDate = (__bridge NSDate *)(ABRecordCopyValue(people, kABPersonBirthdayProperty));
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        NSString *birthday = @"";
        if (birthDate) {
            birthday = [dateFormatter stringFromDate:birthDate];
        }
        
        //第一次添加该条记录的时间
        NSDate *createDate = (__bridge NSDate*)ABRecordCopyValue(people, kABPersonCreationDateProperty);
        NSString *createTime = @"";
        if (createDate) {
            createTime = [dateFormatter stringFromDate:createDate];
        }
        
        //最后一次修改該条记录的时间
        NSDate *modifyDate = (__bridge NSDate*)ABRecordCopyValue(people, kABPersonModificationDateProperty);
        
        NSString *modifyTime = @"";
        if (modifyDate) {
            modifyTime = [dateFormatter stringFromDate:modifyDate];
        }
        //读取地址多值
        ABMultiValueRef address = ABRecordCopyValue(people, kABPersonAddressProperty);
        NSString *addressStr = @"";
        for(int j = 0; j < ABMultiValueGetCount(address); j++)
        {
            //获取地址Label
            //            NSString* addressLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, j);
            
            //获取該label下的地址6属性
            NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
            if(country != nil)
                addressStr = [addressStr stringByAppendingFormat:@"%@ ",country];
            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
            if(city != nil)
                addressStr = [addressStr stringByAppendingFormat:@"%@ ",city];
            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
            if(state != nil)
                addressStr = [addressStr stringByAppendingFormat:@"%@ ",state];
            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            if(street != nil)
                addressStr = [addressStr stringByAppendingFormat:@"%@ ",street];
            //            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
            //            if(zip != nil)
            //                addressStr = [addressStr stringByAppendingFormat:@"邮编：%@",zip];
            
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:nameString.length != 0 ? nameString : @"" forKey:@"contact_name"];
        
        [dict setObject:phoneStr forKey:@"phone_no"];
        
        [dict setObject:email forKey:@"email"];
        
        [dict setObject:organization.length != 0 ? organization : @"" forKey:@"organization"];
        
        [dict setObject:addressStr forKey:@"address"];
        
        [dict setObject:birthday != nil ? birthday :@"" forKey:@"birthday"];
        
        [dict setObject:jobtitle.length != 0 ? jobtitle : @"" forKey:@"job_title"];
        
        [dict setObject:nickname.length != 0 ? nickname : @"" forKey:@"nickname"];
        
        [dict setObject:note.length != 0 ? note : @"" forKey:@"note"];
        
        [dict setObject:createTime forKey:@"create_time"];
        
        [dict setObject:modifyTime forKey:@"modify_time"];
        
        [peopleArray addObject:dict];
        
        if(abName) CFRelease(abName);
        if(abLastName) CFRelease(abLastName);
        if(abFullName) CFRelease(abFullName);
        if(people) CFRelease(people);
    }
    if(allLinkPeople) CFRelease(allLinkPeople);
    
    return peopleArray;
    
}
//查看是否有权限读取通讯录

+(void)CheckAddressBookIOS9BeforeAuthorization:(void (^)(bool isAuthorized))block

{
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
        
    {
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 
                                                 {
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         if (!granted){
                                                             
                                                             block(NO);
                                                             
                                                         }else{
                                                             
                                                             block(YES);
                                                             
                                                         }
                                                         
                                                     });
                                                     
                                                 });
        
    }
    
    else{
        
        block(YES);
        
    }
    
}

//ios 9 以后 使用block 返回 联系人数组

+(void)getIOS9AfterContactsSuccess:(void (^)(NSArray *))block

{
    
    NSMutableArray *contacts = [NSMutableArray array];
    
    if (@available(iOS 9.0, *)) {
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
            
            CNContactStore *store = [[CNContactStore alloc] init];
            
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    
                    CNContactStore * store = [[CNContactStore alloc] init];
                    //这里写要获取的内容的key
                    NSArray * keys = @[CNContactGivenNameKey, CNContactFamilyNameKey,CNContactNicknameKey, CNContactOrganizationNameKey,CNContactBirthdayKey,CNContactNoteKey,CNContactJobTitleKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactDatesKey];
                    
                    CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
                    
                    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                        
                        NSString *nameString = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
                        
                        NSString *phoneStr = @"";
                        
                        for (CNLabeledValue * labelValue in contact.phoneNumbers) {
                            
                            CNPhoneNumber * number = labelValue.value;
                            
                            phoneStr  = [phoneStr stringByAppendingFormat:@"%@ ",number.stringValue];
                        }
                        
                        NSString *email = @"";
                        
                        for (CNLabeledValue * valueStr in contact.emailAddresses) {
                            
                            NSString * emailStr = valueStr.value;
                            
                            email  = [email stringByAppendingFormat:@"%@",emailStr];
                        }
                        
                        NSString *addressStr = @"";
                        
                        for (CNLabeledValue * labelValue in contact.postalAddresses) {
                            
                            CNPostalAddress * postalAddress = labelValue.value;
                            
                            addressStr = [NSString stringWithFormat:@"%@ %@ %@ %@",postalAddress.country,postalAddress.city,postalAddress.state,postalAddress.street];
                        }
                        
                        NSString *nickname = contact.nickname;
                        
                        NSString *note = contact.note;
                        
                        NSString *jobtitle = contact.jobTitle;
                        
                        NSString *organization = contact.organizationName;
                        NSString *birthday = @"";
                        if (contact.birthday) {
                            NSDateComponents *dateCom = contact.birthday;
                            birthday = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)dateCom.year,(long)dateCom.month,(long)dateCom.day];
                        }
                        
                        
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        
                        [dict setObject:nameString.length != 0 ? nameString : @"" forKey:@"contact_name"];
                        
                        [dict setObject:phoneStr forKey:@"phone_no"];
                        
                        [dict setObject:email forKey:@"email"];
                        
                        [dict setObject:organization.length != 0 ? organization : @"" forKey:@"organization"];
                        
                        [dict setObject:addressStr forKey:@"address"];
                        
                        [dict setObject:birthday.length != 0 ? birthday : @"" forKey:@"birthday"];
                        
                        [dict setObject:jobtitle.length != 0 ? jobtitle : @"" forKey:@"job_title"];
                        
                        [dict setObject:nickname.length != 0 ? nickname : @"" forKey:@"nickname"];
                        
                        [dict setObject:note.length != 0 ? note : @"" forKey:@"note"];
                        
                        [dict setObject:@"" forKey:@"create_time"];
                        
                        [dict setObject:@"" forKey:@"modify_time"];
                        
                        [contacts addObject:dict];
                        
                        
                    }];
                }
                
                block(contacts);
            }];
            
        }else{//没有权限
            
            block(contacts);
        }
    } else {
        // Fallback on earlier versions
    }
}

//ios 9以后查看是否有权限读取通讯录

+ (void)checkAddressBookIOS9AfterAuthorization:(void (^)(bool isAuthorized))block

{
    if (@available(iOS 9.0, *)) {
    CNContactStore *addressBook = [[CNContactStore alloc]init];
    
    CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];;
    
    if (authStatus != CNAuthorizationStatusAuthorized){
        
        [addressBook requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (error){
                    
                    NSLog(@"ios9以后Error: %@",error);
                    
                    if (error.code == 100) {//ios 9 以后第一次被用户拒绝访问之后就走 error 的方法
                        
                        block(NO);
                        
                    }
                    
                }else if (!granted){
                    
                    block(NO);
                    
                }else{
                    
                    block(YES);
                    
                }
                
            });
            
        }];
        
    }else{
        
        block(YES);
        
    }
    }
}
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content{
    //提示标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
        
    }
    return NO;
    
}
+ (NSString *)md5HexDigest:(NSString *)inputPassword{
    const char *cStr = [inputPassword UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
    
}
+(BOOL) isValidateMobile:(NSString *)mobile
{
    /*
     //手机号以13， 15，18开头，八个 \\d 数字字符
     NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\\\D])|(18[0,0-9]))\\\\d{8}$";
     NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
     return [phoneTest evaluateWithObject:mobile];
     */
    
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1[34578]([0-9]){9}"];
    return [phoneTest evaluateWithObject:mobile];
}
+(NSString *)getDateStringWithTimeStr:(NSString *)str showType:(NSString  *)type{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:type];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
+(BOOL) isOtherBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}
+(float)roundFloat:(float)price{
    
    NSString *temp = [NSString stringWithFormat:@"%.7f",price];
    
    NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:temp];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO
                                       raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    return [[numResult decimalNumberByRoundingAccordingToBehavior:roundUp] floatValue];
    
}
// 给定字符串根据指定的个数进行分组，每一组用空格分隔
+ (NSString *)groupedString:(NSString *)string {
    
    NSString *str = [string stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, string.length)];
    
    // 根据长度计算分组的个数
    NSInteger groupCount = (NSInteger)ceilf((CGFloat)str.length /4);
    NSMutableArray *components = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < groupCount; i++) {
        if (i*4 + 4 >= str.length) {
            [components addObject:[str substringFromIndex:i*4]];
        } else {
            NSString * secureStr = [str substringWithRange:NSMakeRange(i*4, 4)];
            secureStr = [secureStr stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"****"];
            [components addObject:secureStr];
        }
    }
    NSString *groupedString = [components componentsJoinedByString:@"   "];
    return groupedString;
}
+(NSString *)getDeviceIDInKeychain
{
    NSString *getUDIDInKeychain = (NSString *)[JFHSUtilsTool load:KEY_UDID_INSTEAD];
 
    if (!getUDIDInKeychain ||[getUDIDInKeychain isEqualToString:@""]||[getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
      
        [JFHSUtilsTool save:KEY_UDID_INSTEAD data:result];
        getUDIDInKeychain = (NSString *)[JFHSUtilsTool load:KEY_UDID_INSTEAD];
    }
    
    return getUDIDInKeychain;
}

#pragma mark - private

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
@end
