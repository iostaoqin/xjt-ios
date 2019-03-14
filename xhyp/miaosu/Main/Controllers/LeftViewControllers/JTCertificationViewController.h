//
//  JTCertificationViewController.h
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    certificationRealNameSucess =1,//实名认证
    certificationMobilSucess,//运营商 认证
    certificationBasicInfoSucess,//基本信息 认证
    certificationBankSucess,//银行卡 认证
} certificationType;
@interface JTCertificationViewController : JTBaseViewController
@property (nonatomic, assign)certificationType type;
@end

NS_ASSUME_NONNULL_END
