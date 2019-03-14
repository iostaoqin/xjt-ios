//
//  JTBaseViewController.h
//  xiaojintiao
//
//  Created by Daisy  on 2019/2/14.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTBaseViewController : UIViewController
/**
 *  左边导航栏
 *
 *  @param name         正常状态下图片名
 *  @param nameSelected 选择状态下图片名
 */
- (void)addLeftButtonItemWithImage:(NSString *)name slected:(NSString *)nameSelected;
- (void)leftBarButtonItemEvent:(id)sender;
/**
 *  导航栏右边按钮
 */
- (void)addRightButtonItemWithImage:(NSString *)name selected:(NSString *)nameSel;

/**
 *  导航栏右边按钮触发
 */
- (void)rightBarButtonItemEvent:(id)sender;
/**
 * 获取验证码
 */
-(void)getCodeBtn:(UIButton *)codeBtn;
/**
 *续期还款的UI
 */
-(void)renewalUI:(NSArray *)nameArr showType:(NSString *)type tele:(NSString *)xteleNumberStr;
/**
 *关闭弹窗
 */
-(void)closeWindsEventClick;
/**
 *获取验证码
 */
-(void)getCodeEventClick:(UIButton *)codeBtn;
/**
 *第一个弹窗的点击事件
 */
-(void)firstRenewalBtnEventClick:(UIButton  *)codebtn;
/**
 * 稍后 点击去掉弹框
 */
-(void)RenewalCancelBtnEventClick;
/**
 *第2个弹窗的点击事件
 */
-(void)secondRenewalBtnEventClick:(NSString *)codeStr;
/**
 *提示框
 */
-(void)alertCerticationMsg:(NSString *)msg tipsStr:(NSString *)tips sureStr:(NSString *)sureStr cancelStr:(NSString *)cancel;
/**
 *提示框点击事件
 */
-(void)alertSureBtnEvent;
/**
 *当检测到用户在其他的设备登录时 key 失效  重新请求数据接口
 */
-(void )againLogin;
@end

NS_ASSUME_NONNULL_END
