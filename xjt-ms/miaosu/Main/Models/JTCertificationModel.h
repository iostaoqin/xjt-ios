//
//  JTCertificationModel.h
//  miaosu
//
//  Created by Daisy  on 2019/2/25.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTCertificationModel : JTBaseModel
//0--未认证  1 --认证成功  2--认证失败 3 --已经过期 4--认证中 
@property (nonatomic,  strong)NSString  *basicInfoVerified;//基本信息是否认证
@property (nonatomic,  strong)NSString  *maillistVerified;//通讯录
@property (nonatomic,  strong)NSString  *bankCardVerified;
@property (nonatomic,  strong)NSString  *mobileVerified;//运营商
@property (nonatomic,  strong)NSString  *realnameVerified;//
@property (nonatomic,  strong)NSString  *userName;//
@property (nonatomic,  strong)NSString  *idCardNo;//
//实名认证信息
@property (nonatomic,  strong)NSString  *idName;//
@property (nonatomic,  strong)NSString  *idNumber;//
@property (nonatomic,  strong)NSString  *notifyDate;//
@property (nonatomic,  strong)NSString  *creationDate;//
@property (nonatomic,  strong)NSString  *realnameVerifiedDate;//
@property (nonatomic,  strong)NSString  *validityPeriod;//
@property (nonatomic,  strong)NSString  *failReason;//失败原因
//运营商认证
@property (nonatomic,  strong)NSString  *mobileVerifiedDate;//
@property (nonatomic,  strong)NSString  *phoneNumber;//
@property (nonatomic,  strong)NSString  *maillistVerifiedDate;//
//提交银行卡认证
@property (nonatomic,  strong)NSString  *bankBin;//
@property (nonatomic,  strong)NSString  *bankCode;//
@property (nonatomic,  strong)NSString  *bank;//遍历bank拿到对应的银行卡内型
//获取银行卡认证成功x的信息
@property (nonatomic,  strong)NSString  *cardNo;//
@property (nonatomic,  strong)NSString  *bankColor;//
@property (nonatomic,  strong)NSString  *bankName;//
@property (nonatomic,  strong)NSString  *bankLogo;//
@property (nonatomic,  strong)NSString  *cardType;//
@property (nonatomic,  strong)NSString  *payProductId;//
@end

NS_ASSUME_NONNULL_END
