//
//  JTOperatorViewController.h
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    operator_success =1,//审核成功
    operator_fail,//审核失败
    operator_review,//审核中
    certication_success,//实名认证成功
} showOperatorType;
@interface JTOperatorViewController : JTBaseViewController
@property (nonatomic, assign)showOperatorType type;
@end

NS_ASSUME_NONNULL_END
