//
//  JFNewAboutMeModel.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/7.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFBaseClassModelEdit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFNewAboutMeModel : JFBaseClassModelEdit
@property (nonatomic, strong)NSString *wechat;
@property (nonatomic, strong)NSString *contactName;
//@property (nonatomic, strong)NSString *appName;
@property (nonatomic, strong)NSString *appDesc;
@property (nonatomic, strong)NSString *companyName;
@property (nonatomic, strong)NSString *companyDesc;
@property (nonatomic, strong)NSString *phoneNumber;
@end

NS_ASSUME_NONNULL_END
