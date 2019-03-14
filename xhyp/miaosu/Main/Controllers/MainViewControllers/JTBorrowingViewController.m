//
//  JTBorrowingViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBorrowingViewController.h"
#import "JTDetailOrderTableViewCell.h"
#import "JTBrowingTableViewCell.h"
@interface JTBorrowingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *nameArr;
@property (nonatomic, strong)UITableView *BorrowingTb;
@property (nonatomic, strong)UIButton *agreenBtn;
@property (nonatomic, strong)NSMutableArray *loanArr;
@property (nonatomic, strong)NSMutableArray *loanDetailArr;
@property (nonatomic, strong)NSString *totalPrice;//借款金额
@property (nonatomic, strong)NSString *lateFee1;//
@property (nonatomic, strong)NSString *lateFee2;
@property (nonatomic, strong)NSString *lateFee3;
@end

@implementation JTBorrowingViewController
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
    // Do any additional setup after loading the view.
    self.title  = @"我要借款";
    self.view.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
    [self BorrowingTbUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sliderViewRefresh:) name:@"sliderNotice" object:nil];
    if (@available(iOS 11.0, *)) {
        _BorrowingTb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.loanArr=[NSMutableArray array];
    self.loanDetailArr  =[NSMutableArray array];
    [self loanBorrowingData];
}
#pragma mark  - 请求配置信息
-(void)loanBorrowingData{
    NSString *loanStr   = [NSString stringWithFormat:@"%@/xjt/user/loanProperties",JT_MS_URL];
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:userInfo.keyStr]) {
        [PPNetworkHelper setValue:userInfo.keyStr forHTTPHeaderField:@"API_KEY"];
    }
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"加载中"];
    [PPNetworkHelper GET:loanStr parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            [self.loanArr removeAllObjects];
            //请求成功 刷新数据
            JTLoanModel *loanModel = [JTLoanModel mj_objectWithKeyValues:responseObject];
            loanModel.cardNo  =[NSString  stringWithFormat:@"%@",responseObject[@"userCard"][@"cardNo"]];
            [self calculateLoanDetailData:loanModel carNo:responseObject[@"userCard"][@"cardNo"]];
            [self.loanArr addObject:loanModel];
        }else{
            if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"2"]) {
                [self againLogin];
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeMessage"]];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                });
            }
        }
        [self.BorrowingTb reloadData];
    } failure:^(NSError *error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
}
#pragma mark - 计算贷款明细
-(void)calculateLoanDetailData:(JTLoanModel *)model carNo:(NSString *)card{
    //管理费用  =  j借款金额 *fee * 7
    //手续费和利息的单位是万分之
    //利息=借款金额 * interest * 7 天
    //一开始用最小金额去计算
    [self.loanDetailArr removeAllObjects];
    NSString *managementFree =  [NSString stringWithFormat:@"%.2f元",[JFHSUtilsTool roundFloat:[model.minMount floatValue]/100 * [model.fee floatValue]*[model.periodDays integerValue]/10000]];
    //利息interest
    NSString *interestStr  = [NSString stringWithFormat:@"%.2f元",[JFHSUtilsTool roundFloat:[model.minMount floatValue]/100 * [model.interest floatValue]/10000 * [model.periodDays integerValue]]];
    //到账金额 = 借款金额-手续费(管理费+管理)
    NSString *price=  [NSString stringWithFormat:@"%.2f元", [model.minMount floatValue]/100-[managementFree floatValue]];
    NSArray *temArr = @[@[],@[[NSString stringWithFormat:@"%@天",model.periodDays],interestStr,managementFree],@[price,[JFHSUtilsTool groupedString:card]]];
    self.loanDetailArr  = [temArr mutableCopy];
    self.totalPrice = model.minMount;
}
#pragma mark - 拖动滑块的时候   改变cell的数值
-(void)sliderViewRefresh:(NSNotification *)notice{
    
    NSIndexPath *index  =[NSIndexPath indexPathForRow:0 inSection:0];
    JTBrowingTableViewCell *cell =(JTBrowingTableViewCell *)[_BorrowingTb cellForRowAtIndexPath:index];
    cell.priceNameLable.text  =[NSString stringWithFormat:@"+%@",notice.userInfo[@"price"]];
    //
    [self sliderCalculateLoanDetailData:notice.userInfo[@"price"]];
    
}
-(void)sliderCalculateLoanDetailData:(NSString  *)totalPrice{
    //管理费用  =  借款金额 *fee *  7
    //手续费和利息的单位是万分之
    //利息=借款金额 * interest * 7 天
    //一开始用最小金额去计算
    JTLog(@"%@",totalPrice);
    [self.loanDetailArr removeAllObjects];
    JTLoanModel *model= self.loanArr[0];
    NSString *managementFree =  [NSString stringWithFormat:@"%.2f元",[JFHSUtilsTool roundFloat:[totalPrice floatValue] *[model.periodDays integerValue]* [model.fee floatValue]/10000]];
  
    //利息interest
    NSString *interestStr  = [NSString stringWithFormat:@"%.2f元",[JFHSUtilsTool roundFloat:[totalPrice floatValue] * [model.interest floatValue]/10000 * 7]];
    //到账金额 = 借款金额-手续费(管理费)
    NSString *price=  [NSString stringWithFormat:@"%.2f元", [totalPrice floatValue]-[managementFree floatValue]];
    NSArray *temArr = @[@[],@[[NSString stringWithFormat:@"%@天",model.periodDays],interestStr,managementFree],@[price,[JFHSUtilsTool groupedString:model.cardNo]]];
    self.loanDetailArr  = [temArr mutableCopy];
    self.totalPrice =[NSString stringWithFormat:@"%d", [totalPrice integerValue] * 100];
    //刷新 tb
    //刷新第二个section  和第三个section
    //    [self.BorrowingTb reloadData];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.BorrowingTb reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    NSIndexSet *thirdIndexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.BorrowingTb reloadSections:thirdIndexSet withRowAnimation:UITableViewRowAnimationNone];
}
-(void)BorrowingTbUI{
    self.BorrowingTb   =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH) style:UITableViewStylePlain];
    self.BorrowingTb.delegate  = self;
    self.BorrowingTb.dataSource = self;
    [self.view addSubview:self.BorrowingTb];
    self.BorrowingTb.tableFooterView  = [UIView new];
    self.BorrowingTb.backgroundColor  = [UIColor clearColor];
    self.BorrowingTb.separatorStyle  =UITableViewCellSeparatorStyleNone;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0) {
        return 1;
    }else{
        if (self.loanDetailArr.count) {return [self.nameArr[section] count];}return 0;
        
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  ==0) {
        return 150;
    }return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section  ==0) {
        return 0.0001;
    }return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.loanDetailArr.count) {
        if (section==2) {
            return 160;
        }return 0.0001;
    }return 0.00001;
   
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView   =[UIView new];
    headerView.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.loanDetailArr.count) {
    if (section ==2) {
        UIView *footerView =[UIView new];
        footerView.backgroundColor=[UIColor colorWithHexString:@"F5F5F5"];
        UILabel *nameLable  =[UILabel new];
        [footerView addSubview:nameLable];
        
        nameLable.text= @"到账金额 = 借款金额 - 管理费";
        nameLable.textColor  =[UIColor colorWithHexString:@"#999999"];
        //
        UIButton *secondBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:343* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
        [secondBtn setTitle:@"同意协议并提交审核" forState:UIControlStateNormal];
        [footerView addSubview:secondBtn];
        //协议显示
        
        _agreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:_agreenBtn];
        [_agreenBtn setImage:[UIImage imageNamed:@"img_new_nomal"] forState:UIControlStateNormal];
        [_agreenBtn setImage:[UIImage imageNamed:@"img_new_selected"] forState:UIControlStateSelected];
        [_agreenBtn setImage:[UIImage imageNamed:@"img_new_selected"] forState:UIControlStateHighlighted];
        _agreenBtn.selected  = YES;
        [_agreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 14));
            make.top.equalTo(nameLable.mas_bottom).offset(26* JT_ADAOTER_WIDTH);
            make.left.equalTo(footerView.mas_left).offset(16  * JT_ADAOTER_WIDTH);
        }];
        
        UILabel *agreedLable = [UILabel new];
        [footerView addSubview:agreedLable];
        agreedLable.font = kFontSystem(14);
        agreedLable.textColor  = [UIColor colorWithHexString:@"#333333"];
        NSString *areenStr =[NSString stringWithFormat:@"已阅读%@",[JFHSUtilsTool decodeFromPercentEscapeString:agreement_home_text]];
        agreedLable.attributedText  =[JFHSUtilsTool attributedString:areenStr selectedStr:[JFHSUtilsTool decodeFromPercentEscapeString:agreement_home_text] selctedColor:@"10ADDB"haspreStr:@"已阅读"];
        [agreedLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.agreenBtn.mas_right).offset(10);
            make.centerY.equalTo(self.agreenBtn);
        }];
        //授权书authorization
        UILabel *authorizationLable = [UILabel new];
        [footerView addSubview:authorizationLable];
        authorizationLable.font = kFontSystem(14);
        authorizationLable.attributedText  =[JFHSUtilsTool attributedString:@"《授权书》" selectedStr:@"《授权书》" selctedColor:@"10ADDB"haspreStr:@""];
        [authorizationLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(agreedLable.mas_right).offset(5);
            make.centerY.equalTo(self.agreenBtn);
        }];
        [_agreenBtn addTarget:self action:@selector(agreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //协议手势
        UITapGestureRecognizer *gesture  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureEvent)];
        agreedLable.userInteractionEnabled  = YES;
        [agreedLable addGestureRecognizer:gesture];
        //授权书手势
        UITapGestureRecognizer *authorizationGesture  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(authorizationGestureEvent)];
        authorizationLable.userInteractionEnabled  = YES;
        [authorizationLable addGestureRecognizer:authorizationGesture];
        
        
        
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
            make.top.equalTo(footerView.mas_top).offset(18   *JT_ADAOTER_WIDTH);
        }];
        [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(343* JT_ADAOTER_WIDTH, 46* JT_ADAOTER_WIDTH));
            make.centerX.equalTo(footerView);
            make.top.equalTo(authorizationLable.mas_bottom).offset(30* JT_ADAOTER_WIDTH);
        }];
        if (JT_IS_iPhone5) {
            nameLable.font  =kFontSystem(10);
            secondBtn.titleLabel.font  = kFontSystem(16);
        }else{
            
            nameLable.font  =kFontSystem(12);
            secondBtn.titleLabel.font  = kFontSystem(18);
        }
        [secondBtn addTarget:self action:@selector(secondBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return footerView;
    } }return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString  *cell = @"JTDetailOrderTableViewCell";
        JTBrowingTableViewCell *firstCell =[tableView dequeueReusableCellWithIdentifier:cell];
        if (!firstCell) {
            firstCell  =[[JTBrowingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        }
        firstCell.backgroundColor = [UIColor whiteColor];
        firstCell.selectionStyle =UITableViewCellSelectionStyleNone;
        if (self.loanArr.count) {
            [firstCell getSlideModel:self.loanArr[0]];
        }
        firstCell.maxValue  =self.maxValue;
        firstCell.minValue  =self.minValue;
        return firstCell;
    }else{
        
        static NSString  *cell = @"JTDetailOrderTableViewCell";
        JTDetailOrderTableViewCell *secondCell =[tableView dequeueReusableCellWithIdentifier:cell];
        if (!secondCell) {
            secondCell  =[[JTDetailOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        }
//        if (indexPath.section ==1 && indexPath.row ==2) {
//            secondCell.loanImg.hidden = NO;
//            [secondCell.loanImg addTarget:self action:@selector(loanImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        }else{
//            secondCell.loanImg.hidden = YES;
//        }
        if (self.loanDetailArr.count) {
            
            [secondCell getNameLeftStr:self.nameArr[indexPath.section][indexPath.row]rightDetailStr:self.loanDetailArr[indexPath.section][indexPath.row]];
        }
        secondCell.backgroundColor = [UIColor whiteColor];
        secondCell.selectionStyle =UITableViewCellSelectionStyleNone;
        return secondCell;
        
    }
}
#pragma mark - 提交审核
-(void)secondBtnClick{
    JTLoanModel *lomodel  =self.loanArr[0];
    if (_agreenBtn.selected == NO) {
        //提示用户
        [self alertUser];
    }else{
        NSString  *submitStr =[NSString stringWithFormat:@"%@/xjt/user/apply",JT_MS_URL];
        NSDictionary *dic =@{@"loanAmount":self.totalPrice,@"periodNum":lomodel.periodNum,@"periodDays":lomodel.periodDays,@"loanContractVersion":@"1.0.1"};
        JTLog(@"%@",dic);
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"申请中..."];
        [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:submitStr withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
            JTLog(@"%@",data);
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                //借款成功 提交u用户返回上页
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"提交成功,请等待审核"];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else{
               //错误提示
                if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"2"]) {
                    [self againLogin];
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:data[@"resultCodeMessage"]];
                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                    });
                }
            }
        } withErrorCodeTwo:^{
             [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        } withErrorBlock:^(NSError * _Nonnull error) {
             [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        }];
    }
}
#pragma mark   - 查看问题信息 
-(void)loanImgBtnClick{
    
}
-(NSArray *)nameArr{
    if (!_nameArr) {
        _nameArr =@[@[],@[@"固定周期",@"借款利息",@"管理费"],@[@"到账金额",@"收款银行卡"]];
    }
    return _nameArr;
}
#pragma mark - 同意协议
-(void)agreenBtnClick:(UIButton *)sender{
    _agreenBtn.selected  = !sender.selected;
    
}
#pragma mark -  跳转到协议webe页面
-(void)gestureEvent{
    [self.feedarr enumerateObjectsUsingBlock:^(NSDictionary *feeddic, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([feeddic[@"name"] isEqualToString:@"loan.config.daily.latefee1"]) {
            self.lateFee1  = feeddic[@"value"];
        }
        if ([feeddic[@"name"] isEqualToString:@"loan.config.daily.latefee4"]) {
            self.lateFee2  = feeddic[@"value"];
        }
        if ([feeddic[@"name"] isEqualToString:@"loan.config.daily.latefee7"]) {
            self.lateFee3  = feeddic[@"value"];
        }
    }];

    NSDictionary *dic = @{@"lateFee1": self.lateFee1,@"lateFee2": self.lateFee2,@"lateFee3": self.lateFee3};
    JTWebViewController *web =[[JTWebViewController alloc]init];
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    web.url  =appDelegate.messageArr[0];
    web.dic=  dic;
    web.showtype= @"1";
    [self.navigationController pushViewController:web animated:YES];
}
#pragma mark  - 授权书
-(void)authorizationGestureEvent{
    JTWebViewController *web =[[JTWebViewController alloc]init];
    web.hidesBottomBarWhenPushed = YES;
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    web.url  =[appDelegate.messageArr[3] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.navigationController pushViewController:web animated:YES];
}
-(void)alertUser{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请勾选协议" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:goAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
