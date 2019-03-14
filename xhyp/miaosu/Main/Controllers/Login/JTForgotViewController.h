//
//  JTForgotViewController.h
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    forgotpw_login =1,//登录界面进入
    forgotpw_change,//修改密码界面进入
   
} showPwType;
@interface JTForgotViewController : JTBaseViewController
@property (nonatomic, assign)showPwType pwType;
@end

NS_ASSUME_NONNULL_END
