//
//  JFUserInfoTool.h
//  petassistant
//
//  Created by Daisy  on 2018/10/10.
//  Copyright © 2018年 com.wp. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JFUserInfoTool : NSObject <NSCoding>
/*!
登录成功的key
 */
@property (nonatomic, strong)NSString *keyStr;
/*!
 用户id(贷超)
 */
@property (nonatomic, strong)NSString *xuserloginIdStr;
/*!
 用户电话
 */
@property (nonatomic, strong)NSString *xteleNumberStr;
/*!
 用户
 */
@property (nonatomic, strong)NSString *userNameStr;
/*!
 已认证了几项
 */
@property (nonatomic, strong)NSString *certificationNumberStr;
/*!
 身份证
 */
@property (nonatomic, strong)NSString *idCardStr;
//贷超
/*!
 启动密码
 */
@property (nonatomic, strong)NSString *openPW;
/*!
 每月限额
 */
@property (nonatomic, strong)NSString *limitStr;
/*!
 固定开销
 */
@property (nonatomic, strong)NSString *overheadStr;
/*!
 类别管理
 */
@property (nonatomic, strong)NSString *categoryStr;
//固定开销类别
/*!
 其他
 */
@property (nonatomic, strong)NSString *otherPriceStr;
/*!
 交通工具
 */
@property (nonatomic, strong)NSString *trafficPriceStr;
/*!
 健康
 */
@property (nonatomic, strong)NSString *healthPriceStr;
/*!
 空闲
 */
@property (nonatomic, strong)NSString *freePriceStr;
/*!
 食品饮料
 */
@property (nonatomic, strong)NSString *foodPriceStr;
/*!
 固定开销的次数
 */
@property (nonatomic, strong)NSString *countStr;
/*!
 每月限额
 */
@property (nonatomic, strong)NSString *monthPriceStr;
/*!
 类别管理 数组
 */
@property (nonatomic, strong)NSArray *colorArray;
/*!
 类别收入  数组
 */
@property (nonatomic, strong)NSArray *managerPriceArray;
//

/*!
 登录成功之后获取的key
 */
@property (nonatomic, strong)NSString *loginSuccessKey;
/*!
 登录成功之后userid
 */
//@property (nonatomic, strong)NSString *userId;
/*!
 登录成功之后手机号
 */
@property (nonatomic, strong)NSString *teleStr;
/*!
 姓名
 */
@property (nonatomic, strong)NSString *nameStr;
/*!
 身份证
 */
@property (nonatomic, strong)NSString *identityStr;
/*!
 职业信息
 */
@property (nonatomic, strong)NSString *professionalStr;
/*!
 用户头像
 */
@property (nonatomic, strong)NSString *portraintUrl;
/*!
 显示轮播图还是最新口子
 */
@property (nonatomic, strong)NSString *headerModelStr;
//用于神策
/*!
 渠道
 */
@property (nonatomic, strong)NSString *channelCodeStr;
/*!
 useID(小金条)
 */
@property (nonatomic, strong)NSString *userIdStr;

@property (nonatomic, strong)UIImage *portraintImg;
/*!
 性别
 */
@property (nonatomic, strong)NSString *sixStr;
/*!
 birthDaybirthDay
 */
@property (nonatomic, strong)NSString *birthdayStr;
/*!
 时间戳 运营商的
 */
@property (nonatomic, strong)NSString *operatorTimeStr;
@end
