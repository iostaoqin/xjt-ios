//
//  JFJpushManager.h
//  miaosu
//
//  Created by Daisy  on 2019/3/6.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <Foundation/Foundation.h>
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define JPUSHAppKey  @""

#define JPUSHChannel  @"Publish channel"

#ifdef DEBUG // 开发

#define isJPUSHProduction  FALSE // 极光FALSE为开发环境

#else  // 生产

#define isJPUSHProduction  TRUE // 极光true为生产环境

#endif

NS_ASSUME_NONNULL_BEGIN
typedef void(^AfterReceiveNoticationHandle)(NSDictionary *userInfo);
@interface JFJpushManager : NSObject<JPUSHRegisterDelegate>
//单例
+(instancetype)shareManager;

//初始化推送
-(void)lsd_setupWithOption:(NSDictionary *)launchingOption
                    appKey:(NSString *)appKey
                   channel:(NSString *)channel
          apsForProduction:(BOOL)isProduction
     advertisingIdentifier:(NSString *)advertisingId;

// 在appdelegate注册设备处调用
- (void)lsd_registerDeviceToken:(NSData *)deviceToken;

//设置角标
- (void)lsd_setBadge:(int)badge;

//接收到消息后的处理
@property(copy,nonatomic)AfterReceiveNoticationHandle afterReceiveNoticationHandle;


@end

NS_ASSUME_NONNULL_END
