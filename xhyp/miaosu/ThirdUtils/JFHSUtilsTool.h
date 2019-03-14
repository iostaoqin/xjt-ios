//
//  JFHSUtilsTool.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/24.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <Security/Security.h>
NS_ASSUME_NONNULL_BEGIN


@interface JFHSUtilsTool : NSObject

/**
 !判断 字符串是否为空
 */
+(BOOL)isBlankString:(NSString *)aStr;
/**
 !判断手机号格式是否正确
 */
+(BOOL)checkTelNumber:(NSString *)telNumber;
+(NSMutableAttributedString *)attributedString:(NSString *)allStr selectedStr:(NSString *)str selctedColor:(NSString *)colorStr haspreStr:(NSString *)preStr;
/**
 !判断用户身份证格式是否正确 
 */
+(BOOL)validateIdentityCard:(NSString *)identityCard;
/**
 !获取身份证的年龄
 */
+(NSString *)getIdentityCardAge:(NSString *)numberStr;
/**
 !字典转字符串
 */
+(NSString *)convertToJsonData:(NSDictionary *)dict;
/**
 拼接请求 的URL地址
 */
+(NSString *)conectUrl:(NSMutableDictionary *)params url:(NSString  *)urlLink;
/**
 神策提交的参数
 * typeStr 追踪类型
 *parameterDic  追踪携带的参数
 */
+(void)submitSensorsAnalytics:(NSString *)typeStr parameter:(NSDictionary *)parameterDic;
/**
 *获取 当前手机型号
 *
 */
+(NSString*)iphoneType;
/**
 *中文加密
 *
 */
+ (NSString *)stringXOREncryptWithPlainText:(NSString *)plainText secretKey:(NSString *)secretKey;
/**
 *解密
 *
 */
+(NSString *)stringXORDeocodeWithPlainText:(NSString *)plaintext secretKey:(NSString *)secretKey;
+ (NSString *)UrlValueEncode:(NSString *)str;
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;

/*s*
 *  获取path路径下文件夹的大小
 *
 *  @param path 要获取的文件夹 路径
 *
 *  @return 返回path路径下文件夹的大小
 */
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;

/**
 *  清除path路径下文件夹的缓存
 *
 *  @param path  要清除缓存的文件夹 路径
 *
 *  @return 是否清除成功
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;
// ios 9 以前 获取通讯录数组

+(NSArray *)getIOS9BeforeAddressBooks;
//ios 9 以前 查看是否有权限读取通讯录

+(void)CheckAddressBookIOS9BeforeAuthorization:(void (^)(bool isAuthorized))block;

//ios 9 以后 使用block 返回 联系人数组

+(void)getIOS9AfterContactsSuccess:(void (^)(NSArray *contacts))block;
//ios 9以后查看是否有权限读取通讯录

+ (void)checkAddressBookIOS9AfterAuthorization:(void (^)(bool isAuthorized))block;
//密码不能包含特殊字符
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;
+ (NSString *)md5HexDigest:(NSString *)inputPassword;
//验证手机号是不是11位的 座机号c排除
+(BOOL) isValidateMobile:(NSString *)mobile;
//时间戳转时间
+(NSString *)getDateStringWithTimeStr:(NSString *)str showType:(NSString  *)type;
//判断字符串是否为空
+(BOOL) isOtherBlankString:(NSString *)string;
//价格四舍五入并保留两位小数
+(float)roundFloat:(float)price;
//银行格式转换
+ (NSString *)groupedString:(NSString *)string;

/**
 本方法是得到 UUID 后存入系统中的 keychain 的方法
 不用添加 plist 文件
 程序删除后重装,仍可以得到相同的唯一标示
 但是当系统升级或者刷机后,系统中的钥匙串会被清空,此时本方法失效
 */
+(NSString *)getDeviceIDInKeychain;

@end

NS_ASSUME_NONNULL_END
