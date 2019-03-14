//
//  JFGiveModel.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/5.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFBaseClassModelEdit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFGiveModel : JFBaseClassModelEdit
@property (nonatomic, strong)NSString *platformId;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *shortName;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *logo;
@property (nonatomic, strong)NSString *adImgUrl;
@property (nonatomic, strong)NSString *desc1;
@property (nonatomic, strong)NSString *minAmount;
@property (nonatomic, strong)NSString *maxAmount;
@property (nonatomic, strong)NSString *loanPeriod;
//
@property (nonatomic, strong)NSString *interestRate;
@property (nonatomic, strong)NSString *approvalTime;
@property (nonatomic, strong)NSString *creator;
@property (nonatomic, strong)NSString *applyCnt;
@property (nonatomic, strong)NSString *cpaPrice;
//@property (nonatomic, strong)NSString *newStr;
@property (nonatomic, strong)NSString *hot;
@property (nonatomic,  strong)NSDictionary *platforms;

@end

NS_ASSUME_NONNULL_END
