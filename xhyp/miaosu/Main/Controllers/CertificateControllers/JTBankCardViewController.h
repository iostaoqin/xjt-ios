//
//  JTBankCardViewController.h
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    showApplyCard,//申请银行卡
    showSucess,//成功界面
} showType;
@interface JTBankCardViewController : JTBaseViewController
@property (nonatomic, assign)showType showType;
@property (nonatomic, strong)NSString *xyType;
@end

NS_ASSUME_NONNULL_END
