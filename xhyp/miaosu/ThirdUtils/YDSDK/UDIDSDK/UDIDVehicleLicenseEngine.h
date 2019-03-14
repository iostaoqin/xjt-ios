//
//  UDIDVehicleLicenseEngine.h
//  UubeeSuperReal
//
//  Created by JiMac on 2018/10/22.
//  Copyright © 2018年 Hydra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDIDSafeDataDefine.h"

@protocol UDIDVehicleLicenseEngineDelegate <NSObject>

/**
 * 返回结果，cancel是用户取消操作，Done 是完成检测 ，userInfo是完成检测之后的返回信息
 **/

- (void)vehicleLicenseFinishedWithResult:(NSInteger)result userInfo:(id)userInfo; // swift

- (void)vehicleLicenseFinishedWithResult:(UDIDSafeAuthResult)result UserInfo:(id)userInfo; //oc

@end

@interface UDIDVehicleLicenseEngine : NSObject

@property (weak, nonatomic) id <UDIDVehicleLicenseEngineDelegate> delegate;

/**
 * 商户认证key，必传
 **/
@property (copy, nonatomic) NSString * authKey;


/**
 商户签名
 */
@property (copy, nonatomic) NSString * sign;


/**
 签名时间
 */
@property (copy, nonatomic) NSString * signTime;

/**
 * 商户外部订单号，必传
 **/
@property (copy, nonatomic) NSString * outOrderId;


@property (copy, nonatomic) NSString * partnerOrderId;

/**
 * 异步通知地址
 **/
@property (copy, nonatomic) NSString * notificationUrl;

/**
 是否单独正面驾驶证扫描（默认为否）
 */
@property (assign, nonatomic) BOOL isSingleFront;

/**
 * 作为备用的业务字段（预留字段，json格式，非必传）
 **/
@property (copy, nonatomic) NSString * extInfo;

/**
 *  行驶证OCR开始方法
 *
 *  @param aViewController 当前viewcontroller
 */
- (void)startVehicleLicenseAuthInViewController:(UIViewController *)viewController;

@end
