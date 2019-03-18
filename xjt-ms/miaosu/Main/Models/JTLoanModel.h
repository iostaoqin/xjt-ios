//
//  JTLoanModel.h
//  miaosu
//
//  Created by Daisy  on 2019/2/27.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTLoanModel : JTBaseModel
@property (nonatomic,  strong)NSString  *minMount;//最小额度
@property (nonatomic,  strong)NSString  *maxAmount;//最大额度
@property (nonatomic,  strong)NSString  *interest;//
/**0-没有订单 1,2,3,4,5审核中- 5-已拒绝 7审核通过,放款中 8 审核通过,放款失败 9已逾期 10 今天到期 12 明日到期 13 待还款****/
@property (nonatomic,  strong)NSString  *orderVostatus;//
@property (nonatomic,  strong)NSString  *fee;//
@property (nonatomic,  strong)NSString  *repaymentNeedAmount;//需要还款的钱数
@property (nonatomic,  strong)NSString  *repaymentNeedDate;//需要还款的时间
@property (nonatomic,  strong)NSString  *periodDays;//周期
@property (nonatomic,  strong)NSString  *periodNum;//期数
@property (nonatomic,  strong)NSString  *name;//
@property (nonatomic,  strong)NSString  *value;//
@property (nonatomic,  strong)NSString  *nameGroup;//
@property (nonatomic,  strong)NSMutableArray  *propertys;//
@property (nonatomic,  strong)NSDictionary  *userCard;//
//借款订单
@property (nonatomic,  strong)NSString  *orderId;//订单id
@property (nonatomic,  strong)NSString  *applyDate;//申请日期
@property (nonatomic,  strong)NSString  *applyAmount;//申请金额
@property (nonatomic,  strong)NSString  *bankName;//银行名称
@property (nonatomic,  strong)NSString  *cardNo;//银行卡
@property (nonatomic,  strong)NSString  *feeAmount;//手续费
@property (nonatomic,  strong)NSString  *recentRepaymentDate;//应还日期
@property (nonatomic,  strong)NSString  *renewNeedAmount;//应还--元
@property (nonatomic,  strong)NSString  *interestAmount;//利息率
@property (nonatomic,  strong)NSString  *lateFeeAmount;//滞纳金
//续还记录
@property (nonatomic,  strong)NSString  *recordType;//1还款记录/2续期记录
@property (nonatomic,  strong)NSString  *repaymentType;//还款方式 0 自动 1 手动
@property (nonatomic,  strong)NSString  *repaymentAmount;
@property (nonatomic,  strong)NSString  *repaymentDate;//还款日期

@property (nonatomic,  strong)NSString  *userName;//借款人姓名
@property (nonatomic,  strong)NSString  *phoneNumber;//预留银行手机号
@property (nonatomic,  strong)NSString  *idCardNo;//借款人账户
@property (nonatomic,  strong)NSString  *loanAmount;//i借款金额
@property (nonatomic,  strong)NSString  *repaymentPlanId;//还款订单id
//放款之后的银行卡号和 名字
@property (nonatomic,  strong)NSString  *bankAccountNumber;//卡号
@property (nonatomic,  strong)NSString  *bankName2;//银行名字
@end

NS_ASSUME_NONNULL_END
