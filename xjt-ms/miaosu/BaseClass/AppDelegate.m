//
//  AppDelegate.m
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "AppDelegate.h"
#import "JTGuideView.h"
#import "JTLeftViewController.h"
#import "JTMainContentViewController.h"
#import "IQKeyboardManager.h"
#import "JFNewLaunchingViewController.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
@interface AppDelegate ()<RunPageControllerDelegate>
@property (nonatomic, strong)JTGuideView *guideView;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    [NSThread sleepForTimeInterval:2];
    application.statusBarHidden = NO;
    [self xiaojintiao:launchOptions];
    /*键盘*/
    [self keyboardManager];
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [[JFJpushManager shareManager]lsd_registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[JFJpushManager shareManager]lsd_setBadge:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)keyboardManager{
    IQKeyboardManager *keybordManeger = [IQKeyboardManager sharedManager];
    keybordManeger.enable = YES;
    keybordManeger.shouldResignOnTouchOutside = YES;//点击空白区域回收键盘
    keybordManeger.shouldShowToolbarPlaceholder  = NO;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}
-(void)RESideMenuUI{
    JTMainContentViewController *mainVC  = [[JTMainContentViewController alloc] init];
    JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:mainVC];
    JTLeftViewController *leftVC =[[JTLeftViewController alloc]init];
    _sideMenuViewController  =[[RESideMenu alloc]initWithContentViewController:navigationController leftMenuViewController:leftVC rightMenuViewController:nil];
    _sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    _sideMenuViewController.menuPreferredStatusBarStyle = 1;
    _sideMenuViewController.delegate = self;
    _sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    _sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    _sideMenuViewController.contentViewShadowOpacity = 0.6;
    _sideMenuViewController.contentViewShadowRadius = 12;
    _sideMenuViewController.contentViewScaleValue  = 1.0f;
    _sideMenuViewController.contentViewShadowEnabled = YES;
    _sideMenuViewController.parallaxEnabled =  YES;//视差
    _sideMenuViewController.panFromEdge   = NO;//是否在边界有侧滑手势
    _sideMenuViewController.bouncesHorizontally = NO;
    //    _sideMenuViewController.panGestureEnabled =  NO;
    _sideMenuViewController.contentViewInPortraitOffsetCenterX  =OffsetCenter_x;
    _sideMenuViewController.menuViewControllerTransformation =  CGAffineTransformMakeTranslation(-([UIScreen mainScreen].bounds.size.width / 2.f), 0);//平移动画
    self.window.rootViewController = _sideMenuViewController;
    
    //    JFNewLaunchingViewController *launch = [[JFNewLaunchingViewController alloc] init];
    //    [launch setFinishBlock:^{
    //        self.window.rootViewController = sideMenuViewController;
    //    }];
    //    self.window.rootViewController = launch;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
/*禁止横屏*/
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark  - 获取协议地址
-(void)agreementData{
    NSString *agreementUrl  =[NSString stringWithFormat:@"%@/xjt/appConfig",JT_MS_URL];
    [PPNetworkHelper GET:agreementUrl parameters:nil success:^(id responseObject) {
        JTLog(@"协议地址=%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            self.messageArr  = @[responseObject[@"loanApplicationUrl"],responseObject[@"userServiceUrl"],responseObject[@"customQrCodeUrl"],responseObject[@"userMessageQuertUrl"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    //    [NSPropertyListSerialization propertyListFromData:tempData
    //                                     mutabilityOption:NSPropertyListImmutable
    //                                               format:NULL
    //                                     errorDescription:NULL];
    [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}
-(void)xiaojintiao:(NSDictionary *)launchOptions{
    /*第一次启动APP*/
    NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
    if (![TimeOfBootCount valueForKey:@"xiaojintiaotime"]) {
        [TimeOfBootCount setValue:@"guidxiaojintiaoImage" forKey:@"xiaojintiaotime"];
        //初始化存储信息类
        JFUserInfoTool *userInfo  = [[JFUserInfoTool alloc]init];
        [JFUserManager  shareManager].currentUserInfo =userInfo;
        /*抽屉控制器初始化*/
        [self RESideMenuUI];
        /*引导页*/
        [self guidViewUI];
    }else{
        /*抽屉控制器初始化*/
        [self RESideMenuUI];
    }
    /**获取协议地址**/
    [self agreementData];
    
    /*极光推送*/
    [self JPPushService:launchOptions];
    /*新颜SDK初始化*/
    [self XYSDK];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
   
    return NO;
}

#pragma mark  - 小金条的内容
-(void)guidViewUI{
    self.guideView = [[JTGuideView alloc] initWithFrame:self.window.frame];
    self.guideView.guideDelagte = self;
    [self.window addSubview:self.guideView];
}
-(void)OnButtonClick{
    [UIView animateWithDuration:0.6 animations:^{
        self.guideView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.guideView removeFromSuperview];
    }];
}
#pragma mark -  新颜
-(void)XYSDK{
    // 初始化
    XYCrawlerSDK *xySDK  = [XYCrawlerSDK xySDKUser:XY_APIUSER key:XY_APIKEY];
    // 开启SDK日志
    [XYCrawlerSDK unlockLog];
    // 通知地址
    xySDK.xyDataNotifyUrl = @"";
    xySDK.xyReportNotifyUrl = @"";
    /******* 失败退出模式 *******/
    xySDK.xyQuitOnFail = YES;// 失败后退出SDK
    /******* 成功退出模式 *******/
    xySDK.xyQuitOnSuccess = YES;// 授权登陆成功退出SDK
    // 导航栏返回按钮文字（默认为“返回”）
    xySDK.xyBackText = @"";
    // 导航栏颜色
    xySDK.xyThemeColor = [UIColor colorWithHexString:@"#62A7E9"];
    
}
#pragma mark 极光推送
-(void)JPPushService:(NSDictionary *)launchOptions{
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[JFJpushManager shareManager]lsd_setupWithOption:launchOptions appKey:JPUSHAppKey channel:JPUSHChannel apsForProduction:isJPUSHProduction advertisingIdentifier:advertisingId];
    [JFJpushManager shareManager].afterReceiveNoticationHandle = ^(NSDictionary *userInfo){
        JTLog(@"%@",userInfo);
    };
}
@end
