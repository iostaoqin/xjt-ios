//
//  JFThirdNewModel.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/5.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFBaseClassModelEdit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFThirdNewModel : JFBaseClassModelEdit
@property (nonatomic, strong)NSString *categoryId;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *detailMessage;
@property (nonatomic, strong)NSString *iconUrl;
@property (nonatomic, strong)NSString *descColor;
//全部creditCard的
@property (nonatomic, strong)NSString *creditId;
@property (nonatomic, strong)NSString *bankCode;
@property (nonatomic, strong)NSString *bankName;
@property (nonatomic, strong)NSString *bankUrl;
@property (nonatomic, strong)NSString *cardImgUrl;
@property (nonatomic, strong)NSString *tagName;
@property (nonatomic, strong)NSString *tagColor;
@property (nonatomic, strong)NSString *creditShortName;
@property (nonatomic, strong)NSString *creditName;
@property (nonatomic, strong)NSString *creditDesc;
@property (nonatomic, strong)NSString *giftLogo;
@property (nonatomic, strong)NSString *giftDesc;
@property (nonatomic, strong)NSString *applyCnt;

@property (nonatomic, strong)NSString *detailedDesc;

@end

NS_ASSUME_NONNULL_END
