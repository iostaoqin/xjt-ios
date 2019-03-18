//
//  JTLoanOrderViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTLoanOrderViewController.h"
#import "JTLoanOrderTableViewCell.h"
#import "JTLoanDetailViewController.h"
#import "JTDetailOrderTableViewCell.h"
#import "JTLoanHeaderView.h"
@interface JTLoanOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,  strong)UITableView *orderTb;
@property (nonatomic,  strong)NSMutableArray *orderArr;
@property (nonatomic, strong)NSArray *nameArr;
@property (nonatomic, strong)NSString *orderVostatusStr;//借款状态
@property (nonatomic, strong)JTLoanHeaderView *loanHeaderView;
@property (nonatomic,  strong)NSMutableArray *bouncedArr;//用于续期或者还款弹框数组
@property (nonatomic, strong)NSString *payorderId;//续还订单id 或者还款订单id
@property (nonatomic,  strong)NSMutableArray *feedArr;//用于罚息数组
@property (nonatomic, strong)NSString *lateFee1;//
@property (nonatomic, strong)NSString *lateFee2;
@property (nonatomic, strong)NSString *lateFee3;
@property (nonatomic, assign)NSInteger payType;//续期or还款
@end

@implementation JTLoanOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)leftBarButtonItemEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [JFHSUtilsTool decodeFromPercentEscapeString:main_loan_text];
    self.view.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
    self.orderArr =[NSMutableArray array];
    self.bouncedArr = [NSMutableArray array];
    self.feedArr  =  [NSMutableArray array];
    [self orderTbUI];
    
    [self requestLoanData];
    if (@available(iOS 11.0, *)) {
        _orderTb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}
#pragma mark - 请求借款订单接口
-(void)requestLoanData{
    
    NSString *orderUrl =[NSString stringWithFormat:@"%@/xjt/user/latestLoan",JT_MS_URL];
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    [PPNetworkHelper setValue:userInfo.keyStr forHTTPHeaderField:@"API_KEY"];
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [PPNetworkHelper GET:orderUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            [self.orderArr removeAllObjects];
            [self.bouncedArr removeAllObjects];
            [self.feedArr  removeAllObjects];
            //请求成功 判断是否有订单数据orderVostatus  -0咩有订单
            self.orderVostatusStr  =[NSString stringWithFormat:@"%@",responseObject[@"orderVostatus"]];
            if ([ self.orderVostatusStr  isEqualToString:@"0"]) {
                //显示展位图
                [self emptyUI];
            }else{
                //正常解析数据
               
                NSDictionary *dic = responseObject[@"applyOrder"];
                JTLoanModel *loanModel  =[JTLoanModel mj_objectWithKeyValues:dic];
                [self.bouncedArr addObject:loanModel];
                for (NSDictionary *feeddic in responseObject[@"propertys"]) {
                    JTFeeModel *model =[JTFeeModel mj_objectWithKeyValues:feeddic];
                    [self.feedArr addObject:model];
                }
                if ([self.orderVostatusStr isEqualToString:@"1"]||[self.orderVostatusStr isEqualToString:@"2"]||[self.orderVostatusStr isEqualToString:@"3"]||[self.orderVostatusStr isEqualToString:@"4"]||[self.orderVostatusStr isEqualToString:@"5"]||[self.orderVostatusStr isEqualToString:@"6"]||[self.orderVostatusStr isEqualToString:@"8"]||[self.orderVostatusStr isEqualToString:@"7"]) {
                    self.nameArr =@[@"申请日期",@"申请金额",@"到账卡号",@"周期"];
                    //申请日期转换
                    loanModel.applyDate = [JFHSUtilsTool getDateStringWithTimeStr:loanModel.applyDate showType:@"yyyy-MM-dd  HH:mm:ss"];
                    loanModel.applyAmount =   [NSString stringWithFormat:@"%.2f",[JFHSUtilsTool roundFloat:[loanModel.applyAmount floatValue]/100]];
                    //到账卡号 123456
                    NSString *bankName = [NSString stringWithFormat:@"%@(%@)",loanModel.bankName,[loanModel.cardNo substringFromIndex:loanModel.cardNo.length -4]];
                    NSArray *temArr = @[loanModel.applyDate,loanModel.applyAmount,bankName,[NSString stringWithFormat:@"%@天",loanModel.periodDays]];
                    self.orderArr =  [temArr mutableCopy];
                }else{
                    [self addRightButtonItemWithImage:[JFHSUtilsTool decodeFromPercentEscapeString:loan_agreement_text] selected:@"title"];
                    self.nameArr =@[@"借款日期",@"借款金额",@"到账卡号",@"应还日期",@"利息",@"滞纳金"];
                    //借款日期转换
                    loanModel.applyDate = [JFHSUtilsTool getDateStringWithTimeStr:loanModel.applyDate showType:@"yyyy-MM-dd"];
                    //应还日期
                    loanModel.recentRepaymentDate = [JFHSUtilsTool getDateStringWithTimeStr:loanModel.recentRepaymentDate showType:@"yyyy-MM-dd"];
                    //到账卡号 123456
                    NSString *bankName = [NSString stringWithFormat:@"%@(%@)",loanModel.bankName2,[loanModel.bankAccountNumber substringFromIndex:loanModel.bankAccountNumber.length -4]];
                    loanModel.repaymentNeedAmount =   [NSString stringWithFormat:@"%.2f",[JFHSUtilsTool roundFloat:[loanModel.repaymentNeedAmount floatValue]/100]];
                    loanModel.applyAmount =   [NSString stringWithFormat:@"%.2f",[JFHSUtilsTool roundFloat:[loanModel.applyAmount floatValue]/100]];
                    loanModel.interestAmount =   [NSString stringWithFormat:@"%.2f",[JFHSUtilsTool roundFloat:[loanModel.interestAmount floatValue]/100]];
                    loanModel.lateFeeAmount =   [NSString stringWithFormat:@"%.2f",[JFHSUtilsTool roundFloat:[loanModel.lateFeeAmount floatValue]/100]];
                    NSArray *temArr = @[loanModel.applyDate,[NSString stringWithFormat:@"%@元",loanModel.applyAmount],bankName,loanModel.recentRepaymentDate,[NSString stringWithFormat:@"%@元",loanModel.interestAmount],[NSString stringWithFormat:@"%@元",loanModel.lateFeeAmount]];
                    self.orderArr =  [temArr mutableCopy];
                }
                
            }
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeMessage"]];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            });
            if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"2"]) {
               
                [self againLogin];
            }
        }
        [self.orderTb reloadData];
    } failure:^(NSError *error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
}
-(void)orderTbUI{
    self.orderTb   =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH-60 *JT_ADAOTER_WIDTH-kTabBarHeight) style:UITableViewStyleGrouped];
    self.orderTb.delegate  = self;
    self.orderTb.dataSource = self;
    self.orderTb.tableHeaderView  = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];//解决顶部 多出的部分
    [self.view addSubview:self.orderTb];
    self.orderTb.tableFooterView  = [UIView new];
    self.orderTb.backgroundColor  = [UIColor clearColor];
    self.orderTb.separatorStyle  =UITableViewCellSeparatorStyleNone;
}
#pragma mark - 底部提示
-(void)bottomTipsView{
    UIView  *bottomView =[UIView  new];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self.view addSubview:bottomView];
    UILabel *tipsLable = [UILabel new];
    [bottomView addSubview:tipsLable];
    tipsLable.text  =[JFHSUtilsTool decodeFromPercentEscapeString:record_tips_text];
    tipsLable.font = kFontSystem(12);
    tipsLable.numberOfLines  = 0;
    
    tipsLable.textAlignment  = NSTextAlignmentCenter;
    tipsLable.textColor  =[UIColor colorWithHexString:@"#999999"];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60 *JT_ADAOTER_WIDTH);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20 *JT_ADAOTER_WIDTH);
        make.width.mas_equalTo(JT_ScreenW);
    }];
    [tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(self.view.mas_left).offset(54 *JT_ADAOTER_WIDTH);
        make.right.equalTo(self.view.mas_right).offset(-54 *JT_ADAOTER_WIDTH);
        
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.orderArr.count) {
        return self.orderArr.count;
    }return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*JT_ADAOTER_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.orderArr.count) {
        //已拒绝/审核通过,放款失败 1 2 3 4 5 6 8
        if ([self.orderVostatusStr isEqualToString:@"2"]||[self.orderVostatusStr isEqualToString:@"4"]||[self.orderVostatusStr isEqualToString:@"6"]||[self.orderVostatusStr isEqualToString:@"8"]||[self.orderVostatusStr isEqualToString:@"7"]||[self.orderVostatusStr isEqualToString:@"13"]) {
            return 60*JT_ADAOTER_WIDTH;
        }
        //审核中 1 3 5  7
        return 125*JT_ADAOTER_WIDTH;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.orderArr.count) {
        //审核中/已拒绝/审核通过,放款失败 1 2 3 4 5 6 8 7
        if ([self.orderVostatusStr isEqualToString:@"1"]||[self.orderVostatusStr isEqualToString:@"2"]||[self.orderVostatusStr isEqualToString:@"3"]||[self.orderVostatusStr isEqualToString:@"4"]||[self.orderVostatusStr isEqualToString:@"5"]||[self.orderVostatusStr isEqualToString:@"6"]||[self.orderVostatusStr isEqualToString:@"8"]||[self.orderVostatusStr isEqualToString:@"7"]||[self.orderVostatusStr isEqualToString:@"13"]) {
            return 0.0001;
        }
        return 120*JT_ADAOTER_WIDTH;
    }
    return 0.001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString  *cell = @"cellID";
    JTDetailOrderTableViewCell *detailCell =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!detailCell) {
        detailCell  =[[JTDetailOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    detailCell.selectionStyle =UITableViewCellSelectionStyleNone;
    [detailCell getNameLeftStr:self.nameArr[indexPath.row]rightDetailStr:self.orderArr[indexPath.row]];
    
    return detailCell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.orderArr.count) {
        UIView *headerView =[UIView new];
        headerView.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
        _loanHeaderView = [JTLoanHeaderView new];
        _loanHeaderView.backgroundColor =[UIColor clearColor];
        [headerView  addSubview:_loanHeaderView];
        [_loanHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headerView);
        }];
        NSString *tipsStr;
        NSString *tipsImg;
        NSString *detailStr;
        //审核中/已拒绝/审核通过,放款失败  审核通过,放款中  1 2 3 4 5 6 8 7
        if ([self.orderVostatusStr isEqualToString:@"2"]||[self.orderVostatusStr isEqualToString:@"4"]||[self.orderVostatusStr isEqualToString:@"6"]||[self.orderVostatusStr isEqualToString:@"8"]||[self.orderVostatusStr isEqualToString:@"7"]) {
            tipsStr=[self.orderVostatusStr isEqualToString:@"2"]?@"已拒绝":[self.orderVostatusStr isEqualToString:@"4"]?@"已拒绝":[self.orderVostatusStr isEqualToString:@"6"]?@"已拒绝":[self.orderVostatusStr isEqualToString:@"8"]?@"审核通过,放款失败":@"审核通过,放款中";
            tipsImg =[self.orderVostatusStr isEqualToString:@"6"]?@"refused":[self.orderVostatusStr isEqualToString:@"8"]?@"refused":[self.orderVostatusStr isEqualToString:@"2"]?@"refused":[self.orderVostatusStr isEqualToString:@"4"]?@"refused":@"applyStutes";
            detailStr = @"";
            [_loanHeaderView getHeaderImg:tipsImg headerName:tipsStr detailStr:detailStr showType:@"0"];
            //1  3 5 审核 中 applyStutes
        }else if ([self.orderVostatusStr isEqualToString:@"1"]||[self.orderVostatusStr isEqualToString:@"3"]||[self.orderVostatusStr isEqualToString:@"5"]){
            tipsStr  = @"审核中";
            tipsImg = @"applyStutes";
            detailStr = @"对于良好借款记录用户,将会对申请金额进行提额哦~请以到账后的借款金额为准";
            [_loanHeaderView getHeaderImg:tipsImg headerName:tipsStr detailStr:detailStr showType:@"0"];
        }else if([self.orderVostatusStr isEqualToString:@"13"]){
            
            //13   是已还款
            tipsStr = @"已还款";
            detailStr = @"";
            tipsImg = @"Operator_success";
            [_loanHeaderView getHeaderImg:tipsImg headerName:tipsStr detailStr:detailStr showType:@"1"];
        }else{
            //12 11 10 9 待还款 明日到期 今天到期 已逾期
            detailStr = @"您的借款金额已到账，借款信息将上传至百行征信，请关注您的借款状态并及时还款，逾期将对您的信用造成影响，不利于您下次借款哦~";
            tipsStr=[self.orderVostatusStr isEqualToString:@"12"]?@"待还款":[self.orderVostatusStr isEqualToString:@"11"]?@"明日到期":[self.orderVostatusStr isEqualToString:@"10"]?@"今天到期":[self.orderVostatusStr isEqualToString:@"9"]?@"已逾期":@"";
            tipsImg =[self.orderVostatusStr isEqualToString:@"12"]?@"loan_sucess":[self.orderVostatusStr isEqualToString:@"9"]?@"info_fill":@"tomorrow";
            //
            [_loanHeaderView getHeaderImg:tipsImg headerName:tipsStr detailStr:detailStr showType:@"0"];
        }
        
        
        return headerView;
    }return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.orderArr.count) {
        //审核中/已拒绝/审核通过,放款失败 1 2 3 4 5 6 8
        if ([self.orderVostatusStr isEqualToString:@"1"]||[self.orderVostatusStr isEqualToString:@"2"]||[self.orderVostatusStr isEqualToString:@"3"]||[self.orderVostatusStr isEqualToString:@"4"]||[self.orderVostatusStr isEqualToString:@"5"]||[self.orderVostatusStr isEqualToString:@"6"]||[self.orderVostatusStr isEqualToString:@"8"]||[self.orderVostatusStr isEqualToString:@"7"]||[self.orderVostatusStr isEqualToString:@"13"]) {
            
        }else{
            UIView *footerView =[UIView new];
            footerView.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
            UIButton *firstBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:343* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
            [firstBtn setTitle:@"立即还款" forState:UIControlStateNormal];
            UIButton *secondBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:343* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
            [secondBtn setTitle:@"我要续期" forState:UIControlStateNormal];
            [footerView addSubview:firstBtn];
            [footerView addSubview:secondBtn];
            if (JT_IS_iPhone5) {
                firstBtn.titleLabel.font  = kFontSystem(16);
                secondBtn.titleLabel.font  = kFontSystem(16);
            }else{
                firstBtn.titleLabel.font  = kFontSystem(18);
                secondBtn.titleLabel.font  = kFontSystem(18);
            }
            [firstBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(343* JT_ADAOTER_WIDTH, 46* JT_ADAOTER_WIDTH));
                make.centerX.equalTo(footerView);
                make.top.equalTo(footerView.mas_top).offset(13* JT_ADAOTER_WIDTH);
            }];
            [secondBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(343* JT_ADAOTER_WIDTH, 46* JT_ADAOTER_WIDTH));
                make.centerX.equalTo(footerView);
                make.top.equalTo(firstBtn.mas_bottom).offset(13* JT_ADAOTER_WIDTH);
            }];
            [firstBtn addTarget:self action:@selector(firstBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [secondBtn addTarget:self action:@selector(secondBtnClick) forControlEvents:UIControlEventTouchUpInside];
            return footerView;
        }
        
    }return nil;
}
#pragma mark - 立即还款
-(void)firstBtnClick{
    //先判断银行卡是否存在不存在提示用户 去 绑卡
    JTLoanModel *loanModel =self.bouncedArr[0];
    if ([JFHSUtilsTool isBlankString:loanModel.cardNo]) {
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"银行卡已经解绑，请先去认证中心绑定银行卡"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{

    //到账卡号 123456
    NSString *bankName = [NSString stringWithFormat:@"%@(尾号%@)",loanModel.bankName,[loanModel.cardNo substringFromIndex:loanModel.cardNo.length -4]];
    [self  renewalUI:@[@"还款",@"还款金额:",@"支付银行:",[NSString stringWithFormat:@"%@元",loanModel.repaymentNeedAmount],bankName,@"确认还款"] showType:@"1"tele:loanModel.phoneNumber];
        
    }
}
#pragma mark - 我要续期
-(void)secondBtnClick{
    JTLoanModel *loanModel =self.bouncedArr[0];
    if ([JFHSUtilsTool isBlankString:loanModel.cardNo]) {
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"银行卡已经解绑，请先去认证中心绑定银行卡"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
    NSString *feeAmountstr =   [NSString stringWithFormat:@"%.2f",[JFHSUtilsTool roundFloat:[loanModel.renewNeedAmount floatValue]/100]];
    //到账卡号 123456
    NSString *bankName = [NSString stringWithFormat:@"%@(尾号%@)",loanModel.bankName,[loanModel.cardNo substringFromIndex:loanModel.cardNo.length -4]];
    [self  renewalUI:@[@"续期",@"续期费:",@"支付银行:",[NSString stringWithFormat:@"%@元",feeAmountstr],bankName,@"确认续期"] showType:@"3"tele:loanModel.phoneNumber];
    }
}
#pragma mark -  弹框的一系列事件处理
#pragma mark - 我要续期 或者 还款
-(void)firstRenewalBtnEventClick:(UIButton *)codebtn{
    JTLog(@"%zd",codebtn.tag);
    //点击关闭弹框1 显示弹框2
    //发送 验证码z
    //手机序列号
    NSString  *idfv   =[JFHSUtilsTool getDeviceIDInKeychain];
    //随机生成 20以内的字符串保存  保证唯一性
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    NSString  *equipmentStr =[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"equipmentStr%@",userInfo.keyStr]];
    if ([JFHSUtilsTool isBlankString:equipmentStr]) {
        //没有存储值
        equipmentStr  = [self randomStringWithLength:20];
        JTLog(@"%@",equipmentStr);
        [[NSUserDefaults standardUserDefaults]setObject:equipmentStr forKey:[NSString stringWithFormat:@"equipmentStr%@",userInfo.keyStr]];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    JTLoanModel *loanModel =self.bouncedArr[0];
    NSString *type;
    NSString *priceNumber;
    if (codebtn.tag == 1000) {
        //还款
        type = @"1";
        priceNumber   = [NSString stringWithFormat:@"%.0f", [loanModel.repaymentNeedAmount floatValue]* 100];
        self.payType = 1000;
    }else if (codebtn.tag  ==1003){
        //续期
       type = @"2";
       
        priceNumber   = loanModel.renewNeedAmount;
        self.payType = 1003;
    }
    NSString *codeurl  =[NSString  stringWithFormat:@"%@/xjt/user/helipay/msgcode",JT_MS_URL];
    NSDictionary *dic  = @{@"repaymentAmount":priceNumber,@"recordType":type,@"cardNo":loanModel.cardNo,@"terminalId":idfv,@"terminalType":equipmentStr,@"repaymentPlanId":loanModel.repaymentPlanId};
    JTLog(@"code=%@",dic);
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:codeurl withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        JTLog(@"%@",data);
        if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
            //请求 成功 获取 订单号
            //倒计时开始
            [self  renewalUI:@[] showType:@"2" tele:loanModel.phoneNumber];
            //发送通知 到界面倒计时
            [[NSNotificationCenter defaultCenter]postNotificationName:@"codesuccessfulNotice" object:nil];
//            [self getCodeBtn:codebtn];
            self.payorderId  =[NSString stringWithFormat:@"%@",data[@"orderId"]];
            
        }else{
            //提示错误信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:data[@"resultCodeMessage"]];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            });
            if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"2"]) {
                [self againLogin];
            }
        }
    } withErrorCodeTwo:^{
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    } withErrorBlock:^(NSError * _Nonnull error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
    
}
#pragma mark  - 获取验证码
-(void)getCodeEventClick:(UIButton *)codeBtn{
    //请求接口获取验证码
    JTLog(@"%zd",codeBtn.tag);
    //点击关闭弹框1 显示弹框2
    //发送 验证码z
    //手机序列号
    NSString  *idfv   =[JFHSUtilsTool getDeviceIDInKeychain];
    //随机生成 20以内的字符串保存  保证唯一性
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    NSString  *equipmentStr =[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"equipmentStr%@",userInfo.keyStr]];
    if ([JFHSUtilsTool isBlankString:equipmentStr]) {
        //没有存储值
        equipmentStr  = [self randomStringWithLength:20];
        JTLog(@"%@",equipmentStr);
        [[NSUserDefaults standardUserDefaults]setObject:equipmentStr forKey:[NSString stringWithFormat:@"equipmentStr%@",userInfo.keyStr]];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    JTLoanModel *loanModel =self.bouncedArr[0];
    NSString *type;
    NSString *priceNumber;
    if (self.payType == 1000) {
        //还款
        type = @"1";
        priceNumber   = [NSString stringWithFormat:@"%.0f", [loanModel.repaymentNeedAmount floatValue]* 100];
    }else if (self.payType  ==1003){
        //续期
        type = @"2";
        
        priceNumber   = loanModel.renewNeedAmount;
    }
    NSString *codeurl  =[NSString  stringWithFormat:@"%@/xjt/user/helipay/msgcode",JT_MS_URL];
    NSDictionary *dic  = @{@"repaymentAmount":priceNumber,@"recordType":type,@"cardNo":loanModel.cardNo,@"terminalId":idfv,@"terminalType":equipmentStr,@"repaymentPlanId":loanModel.repaymentPlanId};
    JTLog(@"code=%@",dic);
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:codeurl withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        JTLog(@"%@",data);
        if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
            //请求 成功 获取 订单号
            //倒计时开始
            [self  renewalUI:@[] showType:@"2" tele:loanModel.phoneNumber];
            //发送通知 到界面倒计时
            [[NSNotificationCenter defaultCenter]postNotificationName:@"codesuccessfulNotice" object:nil];
            self.payorderId  =[NSString stringWithFormat:@"%@",data[@"orderId"]];
            
        }else{
            //提示错误信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:data[@"resultCodeMessage"]];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            });
            if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"2"]) {
                [self againLogin];
            }
        }
    } withErrorCodeTwo:^{
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    } withErrorBlock:^(NSError * _Nonnull error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
    
}
#pragma mark - 获取验证码点击确定之后
-(void)secondRenewalBtnEventClick:(NSString *)codeStr{
    JTLog(@"codeStr=%@",codeStr);
    //先判断用户是否填写了验证码
    if ([JFHSUtilsTool isBlankString:codeStr]) {
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请先输入验证码"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
        if (self.payorderId) {
            NSString *orderurl=[NSString stringWithFormat:@"%@/xjt/user/helipay/quickpay",JT_MS_URL];
            NSDictionary *dic  = @{@"orderId":self.payorderId,@"msgCode":codeStr};
            JTLog(@"%@",dic);
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
            [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:orderurl withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
                JTLog(@"%@",data);
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                    //付款成功 界面消失
                    [self RenewalCancelBtnEventClick];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });

                }else{
                    //错误信息提示
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:data[@"resultCodeMessage"]];
                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                    });
                }
            } withErrorCodeTwo:^{
                [self RenewalCancelBtnEventClick];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            } withErrorBlock:^(NSError * _Nonnull error) {
                [self RenewalCancelBtnEventClick];
              [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            }];
        }
    }
}
#pragma mark -  借款协议
-(void)rightBarButtonItemEvent:(id)sender{
    JTLoanModel *loanModel   = self.bouncedArr[0];
    JTWebViewController *web =[[JTWebViewController alloc]init];
    //罚息1(name = loan.config.daily.latefee1)  罚息2 (name = loan.config.daily.latefee4)  罚息3(name = loan.config.daily.latefee7)
   
    [self.feedArr enumerateObjectsUsingBlock:^(JTFeeModel *feedModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([feedModel.name isEqualToString:@"loan.config.daily.latefee1"]) {
            self.lateFee1  = feedModel.value;
        }
        if ([feedModel.name isEqualToString:@"loan.config.daily.latefee4"]) {
            self.lateFee2  = feedModel.value;
        }
        if ([feedModel.name isEqualToString:@"loan.config.daily.latefee7"]) {
            self.lateFee3  = feedModel.value;
        }
    }];
    
    NSDictionary *dic = @{@"bankNum":loanModel.cardNo,@"cardNo":loanModel.idCardNo,@"contractDays": loanModel.periodDays,@"firstParty":loanModel.userName,@"interest": [NSString stringWithFormat:@"%.0f",[loanModel.interestAmount floatValue]*100],@"lateFee1": self.lateFee1,@"lateFee2": self.lateFee2,@"lateFee3": self.lateFee3,@"loanAmount":  [NSString stringWithFormat:@"%.0f", [loanModel.applyAmount floatValue]*100],@"loanDay": loanModel.applyDate,@"phoneNum": loanModel.phoneNumber,@"poundage": loanModel.feeAmount,@"repaymentAmount": [NSString stringWithFormat:@"%.0f", [loanModel.repaymentNeedAmount floatValue]*100],@"repaymentDate": loanModel.recentRepaymentDate, @"secondParty": appName};
  
   
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    web.url  =appDelegate.messageArr[0];
    web.dic   = dic;
     web.showtype= @"2";
    [self.navigationController pushViewController:web animated:YES];
}
-(void)emptyUI{
    JTEmptyView *emptyView  =[JTEmptyView new];
    [self.view addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(105  * JT_ADAOTER_WIDTH);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(120*JT_ADAOTER_WIDTH);
    }];
    [emptyView getEmptyImg:@"loan_empty" emptyTitle:@"您尚未借款~"];
}
#pragma mark  -随机生成一个20位的字符串
-(NSString *)randomStringWithLength:(NSInteger)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
        
    }
    return randomString;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
