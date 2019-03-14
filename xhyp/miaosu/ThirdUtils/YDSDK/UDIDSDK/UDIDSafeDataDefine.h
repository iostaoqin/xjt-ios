//
//  UDIDSafeDataDefine.h
//  UD_IDShield
//
//  Created by jwtong on 16/7/21.
//  Copyright © 2016年 com.udcredit. All rights reserved.
//
// SDK 版本号 V4.0.LL190117.20190124


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UDIDSafeAuthResult) {
    UDIDSafeAuthResult_Done,                //认证完成，商户可根据返回码进行自己的业务逻辑操作
    UDIDSafeAuthResult_Error,               //认证异常，如网络异常等
    UDIDSafeAuthResult_Cancel,              //用户取消认证操作
    UDIDSafeAuthResult_UserNameError,       //商户传入的姓名不合法
    UDIDSafeAuthResult_UserIdNumberError,   //商户传入的身份证号码不合法
    UDIDSafeAuthResult_BillNil              //订单为空
};

typedef NS_ENUM(NSUInteger, UDIDSafeMode) {
    UDIDSafeMode_High,
    UDIDSafeMode_Medium,
    UDIDSafeMode_Low
};

typedef NS_ENUM(NSUInteger, UDIDSafePhotoType) {
    UDIDSafePhotoTypeNormal,                // 正常图片
    UDIDSafePhotoTypeGrid                   // 网格照片
};


// 身份证OCR清晰度阈值枚举
typedef NS_ENUM(NSUInteger, UDIDOCRClearness) {
    UDIDOCRClearness_Normal,                // 清晰度阈值-中清晰度(默认)
    UDIDOCRClearness_High,                  // 清晰度阈值-较高清晰度
    UDIDOCRClearness_Low                    // 清晰度阈值-较低清晰度
};

// 身份证OCR扫描边框枚举
typedef NS_ENUM(NSInteger, UDIDOCREdge) {
    UDIDOCREdge_Normal    = 0,             // 正常-四条边对齐（默认）
    UDIDOCREdge_LeftRight = 1,             // 左右两条边对齐
    UDIDOCREdge_TopBottom = 2,             // 上线两条边对齐
    UDIDOCREdge_AnyThree  = 3,             // 任意三条边对齐
    UDIDOCREdge_AnyTwo    = 4,             // 任意两条边对齐
    UDIDOCREdge_AnyOne    = 5              // 任意一条边对齐
};
