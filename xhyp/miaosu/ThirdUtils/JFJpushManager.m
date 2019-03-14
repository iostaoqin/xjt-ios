//
//  JFJpushManager.m
//  miaosu
//
//  Created by Daisy  on 2019/3/6.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFJpushManager.h"

@implementation JFJpushManager
+(instancetype)shareManager{
    
    static JFJpushManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[JFJpushManager alloc]init];
        }
    });
    return _instance;
}

//初始化推送
-(void)lsd_setupWithOption:(NSDictionary *)launchingOption
                    appKey:(NSString *)appKey
                   channel:(NSString *)channel
          apsForProduction:(BOOL)isProduction
     advertisingIdentifier:(NSString *)advertisingId{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        //        __IPHONE_10_0
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchingOption appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

// 在appdelegate注册设备处调用
- (void)lsd_registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    return;
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (self.afterReceiveNoticationHandle) {
        self.afterReceiveNoticationHandle(userInfo);
    }
    
    NSLog(@"iOS6及以下系统，收到通知");
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (self.afterReceiveNoticationHandle) {
        self.afterReceiveNoticationHandle(userInfo);
    }
    NSLog(@"iOS7及以上系统，收到通知");
    completionHandler(UIBackgroundFetchResultNewData);
}


//设置角标
- (void)lsd_setBadge:(int)badge
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    [JPUSHService setBadge:badge];
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        if (self.afterReceiveNoticationHandle) {
            self.afterReceiveNoticationHandle(userInfo);
        }
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
#endif
@end
