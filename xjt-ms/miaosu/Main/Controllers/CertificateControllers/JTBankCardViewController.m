//
//  JTBankCardViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBankCardViewController.h"
#import "JTBankTableViewCell.h"
#import "JTBankSucessView.h"
@interface JTBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,  strong)UITableView *bankTableView;
@property (nonatomic, strong)NSArray *nameArr;
@property (nonatomic, strong)NSArray *palceHolderArr;
@property (nonatomic, strong)NSString *bankOrderId;//订单id
@property (nonatomic, strong)NSString *bankType;//银行卡内型
@property (nonatomic,strong)NSMutableArray *bankArr;
@property (nonatomic, strong)JTBankSucessView *bankSucessView;
@property (nonatomic, assign)BOOL isBankTypeQualified;//银行卡是否合理
@end

@implementation JTBankCardViewController
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
    self.title = @"银行卡认证";
    self.bankArr  =[NSMutableArray array];
    if ([self.xyType isEqualToString:@"xyAction"]) {
        
        
    }else{
        if (@available(iOS 11.0, *)) {
            _bankTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    switch (_showType) {
        case showSucess:
        {
            //认证成功
            self.view.backgroundColor =  [UIColor colorWithHexString:@"#F5F5F5"];
            [self bankApplySucessUI];
            [self bankApplySucessData];
        }
            break;
            
        default:
        {
            [self getCardBank];
            [self bankTableViewUI];
            
        }
            break;
    }
    self.isBankTypeQualified  = NO;
}
#pragma mark  - 得到银行卡认证成功的数据
-(void)bankApplySucessData{
    NSString *url  = [NSString stringWithFormat:@"%@/xjt/user/card",JT_MS_URL];
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    [PPNetworkHelper setValue:userInfo.keyStr forHTTPHeaderField:@"API_KEY"];
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        JTLog(@"银行卡绑定成功=%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            NSDictionary *bankDic  =responseObject[@"userCard"][@"payBank"];
            JTLog(@"%@",bankDic);
            JTCertificationModel *bankModel  =[JTCertificationModel mj_objectWithKeyValues:bankDic];
            //银行卡号
            bankModel.cardNo = [NSString stringWithFormat:@"%@",responseObject[@"userCard"][@"cardNo"]];
            bankModel.creationDate  = [JFHSUtilsTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%@",responseObject[@"userCard"][@"creationDate"]] showType:@"yyyy-MM-dd"];
            [self.bankSucessView getBankModle:bankModel];
        }
    } failure:^(NSError *error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
    
}
-(void)getCardBank{
    NSString *url  = [NSString stringWithFormat:@"%@/xjt/banks",JT_MS_URL];
    [PPNetworkHelper GET:url parameters:@""success:^(id responseObject) {
        JTLog(@"getCardBank=%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            [self.bankArr removeAllObjects];
            for (NSDictionary *dic in responseObject[@"banks"]) {
                JTCertificationModel *bankModel  =[JTCertificationModel mj_objectWithKeyValues:dic];
                [self.bankArr addObject:bankModel];
            }
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
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark- 银行卡认证成功UI
-(void)bankApplySucessUI{
    
    _bankSucessView =[JTBankSucessView new];
    [self.view addSubview:_bankSucessView];
    //    _bankSucessView.backgroundColor = [UIColor colorWithHexString:@"#62A7E9"];
    _bankSucessView.layer.cornerRadius=  5;
    _bankSucessView.layer.borderColor = [UIColor clearColor].CGColor;
    _bankSucessView.layer.borderWidth = 0;
    _bankSucessView.layer.masksToBounds =  YES;
    [_bankSucessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343 *JT_ADAOTER_WIDTH, 140  *JT_ADAOTER_WIDTH));
        make.top.equalTo(self.view.mas_top).offset(20);
        make.centerX.equalTo(self.view);
    }];
}
#pragma mark -  银行卡认证界面
-(void)bankTableViewUI{
    _bankTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH) style:UITableViewStyleGrouped];
    _bankTableView.backgroundColor =  [UIColor colorWithHexString:@"#F5F5F5"];
    _bankTableView.delegate = self;
    _bankTableView.dataSource  = self;
    _bankTableView.separatorStyle  =  UITableViewCellSeparatorStyleNone;
    _bankTableView.tableFooterView   = [UIView new];
    [self.view addSubview:_bankTableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView  *headerView =[UIView new];
    headerView.backgroundColor =[UIColor colorWithHexString:@"#F5F5F5"];
    return headerView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 160*JT_ADAOTER_WIDTH;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView =[UIView new];
    CGFloat registFont;
    if (JT_IS_iPhone5) {
        registFont  = 16;
    }else{
        registFont  = 18;
    }
    
    UIButton *submitBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:343* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"01D3C7"];
    [submitBtn setTitle:@"提交绑卡" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = kFontSystem(registFont);
    [footerView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343 *JT_ADAOTER_WIDTH,  46 *JT_ADAOTER_WIDTH));
        make.centerX.equalTo(footerView);
        make.top.equalTo(footerView.mas_top).offset(24*JT_ADAOTER_WIDTH);
    }];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"JTBankTableViewCell";
    JTBankTableViewCell *banckCell   =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!banckCell) {
        
        banckCell =[[JTBankTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    if (indexPath.row  == 1) {
        [banckCell.rightNameTextFiled becomeFirstResponder];
    }
    [banckCell getLeftName:self.nameArr[indexPath.row] placeHolderStr: self.palceHolderArr[indexPath.row] showIndex:indexPath.row];
    [banckCell.codeBtn addTarget:self action:@selector(codeSubmitEventClick:) forControlEvents:UIControlEventTouchUpInside];
    banckCell.selectionStyle  =UITableViewCellSelectionStyleNone;
    banckCell.rightNameTextFiled.delegate = self;
    banckCell.rightNameTextFiled.tag   = 1000 + indexPath.row;
    return banckCell;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger len  = 0;
    if (textField.tag == 1001) {
        
        len  = 11;
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > len && range.length !=1) {
            textField.text = [toBeString substringToIndex:len];
            return NO;
        }
    }
    
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //
    
    return YES;
}
// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSIndexPath *thirdIndx  =[NSIndexPath indexPathForRow:2 inSection:0];
    
    JTBankTableViewCell *bankCell =(JTBankTableViewCell *)[_bankTableView cellForRowAtIndexPath:thirdIndx];
    if (textField ==bankCell.rightNameTextFiled) {
        //当银行卡失去焦点之后 检测卡号是不是正确
        JTLog(@"失去焦点");
        [self checkBackqualified:bankCell.rightNameTextFiled.text];
    }
}
#pragma Mark- 提交审核
-(void)submitBtnClick{
    
    NSIndexPath *teleIndex  =[NSIndexPath indexPathForRow:1 inSection:0];
    JTBankTableViewCell *teleCell = (JTBankTableViewCell *)[_bankTableView cellForRowAtIndexPath:teleIndex];//预留手机号
    NSIndexPath *passwordIndex  =[NSIndexPath indexPathForRow:2 inSection:0];
    JTBankTableViewCell *bankCell = (JTBankTableViewCell *)[_bankTableView cellForRowAtIndexPath:passwordIndex];//银行卡号
    NSIndexPath *codeIndex  =[NSIndexPath indexPathForRow:3 inSection:0];
    JTBankTableViewCell *codeCell = (JTBankTableViewCell *)[_bankTableView cellForRowAtIndexPath:codeIndex];//验证码
    if ([JFHSUtilsTool isBlankString:self.bankType]) {
        //
        [codeCell.rightNameTextFiled becomeFirstResponder];
        [self checkBackqualified:bankCell.rightNameTextFiled.text];
    }else{
        //提交审核
        //判断用户是否输入验证码
        if ([JFHSUtilsTool isBlankString:codeCell.rightNameTextFiled.text]) {
            //提示用户
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:codeCell.rightNameTextFiled.placeholder];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        }else{
            //提交绑定

        if (self.bankArr.count) {
            [self.bankArr enumerateObjectsUsingBlock:^(JTCertificationModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([model.bankBin isEqualToString:self.bankType]) {
                    //获取到对应的bin拿到bankcode
                    [self submitBankApply:model.bankCode xteleNumberStr:teleCell.rightNameTextFiled.text bankStr:bankCell.rightNameTextFiled.text codeStr:codeCell.rightNameTextFiled.text];
                    //停止循环
                    self.isBankTypeQualified  = YES;
                    *stop = YES;
                }
            }];
            if (self.isBankTypeQualified == NO) {
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"银行卡错误或不支持的银行卡"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            }
        }
    }
    
    }
}
#pragma mark 提交审核
-(void)submitBankApply:(NSString *)bankCode xteleNumberStr:(NSString  *)tele bankStr:(NSString *)bank codeStr:(NSString *)code{
    //先判断 用户是不是随便输入的验证码
    if ([JFHSUtilsTool isBlankString:self.bankOrderId]) {
        //
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请输入正确的验证码"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
        NSString  *bankUrl   =[NSString  stringWithFormat:@"%@/xjt/user/bank/blindcard",JT_MS_URL];
        NSDictionary *bankDic   = @{@"bankCode":bankCode,@"cardNo":bank,@"phoneNumber":tele,@"orderId":self.bankOrderId,@"msgCode":code};
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"提交审核中..."];
        [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:bankUrl withParameter:bankDic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
            JTLog(@"%@",data);
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                //绑定成功  返回上一页
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"银行卡认证成功"];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
                    [self.navigationController  popViewControllerAnimated:YES];
                });
                //
                [[NSNotificationCenter defaultCenter]postNotificationName:@"certificationBankSucessNotice" object:nil];
            }else{
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
-(void)codeSubmitEventClick:(UIButton *)codeBtn{
    NSIndexPath *codeIndex  =[NSIndexPath indexPathForRow:1 inSection:0];
    JTBankTableViewCell *teleCell = (JTBankTableViewCell *)[_bankTableView cellForRowAtIndexPath:codeIndex];//预留手机号
    NSIndexPath *passwordIndex  =[NSIndexPath indexPathForRow:2 inSection:0];
    JTBankTableViewCell *bankCell = (JTBankTableViewCell *)[_bankTableView cellForRowAtIndexPath:passwordIndex];//银行卡号
    if ([JFHSUtilsTool isBlankString:teleCell.rightNameTextFiled.text]||[JFHSUtilsTool isBlankString:bankCell.rightNameTextFiled.text]) {
        NSString *msg;
        msg = [JFHSUtilsTool isBlankString:teleCell.rightNameTextFiled.text]?teleCell.rightNameTextFiled.placeholder:[JFHSUtilsTool isBlankString:bankCell.rightNameTextFiled.text]?bankCell.rightNameTextFiled.placeholder:@"";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:msg];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
        //让银行卡失去聚焦   检测 卡号是否正确
        [teleCell.rightNameTextFiled resignFirstResponder];
        [bankCell.rightNameTextFiled resignFirstResponder];
        if ([JFHSUtilsTool isBlankString:self.bankType]) {
            //没有值就检查
            [self checkBackqualifiedTeleNumberStr:teleCell.rightNameTextFiled.text bankStr:bankCell.rightNameTextFiled.text codeBtn:codeBtn];
        }else{
            //直接请求获取验证码的接口
            if (self.bankArr.count) {
                [self.bankArr enumerateObjectsUsingBlock:^(JTCertificationModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([model.bankBin isEqualToString:self.bankType]) {
                        //获取到对应的bin拿到bankcode
                        [self getCodeDataBackCode:model.bankCode xteleNumberStr:teleCell.rightNameTextFiled.text bankStr:bankCell.rightNameTextFiled.text codeBtn:codeBtn];
                        //停止循环
                        self.isBankTypeQualified = YES;
                        *stop = YES;
                    }
                }];
                if (self.isBankTypeQualified  == NO) {
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"银行卡错误或不支持的银行卡"];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                }
            }
        }
        
    }
}
-(void)getCodeDataBackCode:(NSString *)bankCode xteleNumberStr:(NSString  *)tele bankStr:(NSString *)bank codeBtn:(UIButton *)btn{
    NSString  *bankUrl   =[NSString  stringWithFormat:@"%@/xjt/user/bank/msgCode",JT_MS_URL];
    NSDictionary *bankDic   = @{@"bankCode":bankCode,@"cardNo":bank,@"phoneNumber":tele};
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:bankUrl withParameter:bankDic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
        JTLog(@"%@",data);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
            
            [self getCodeBtn:btn];
            //请求成功 获取订单号
            //遍历
            self.bankOrderId =  data[@"orderId"];
        }else{
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
-(NSArray *)nameArr{
    if (!_nameArr) {
        _nameArr   = @[@"持卡人",@"预留手机号",@"银行卡号",@""];
    }
    return _nameArr;
}
-(NSArray *)palceHolderArr{
    if (!_palceHolderArr) {
        _palceHolderArr   = @[@"",@"请输入手机号码",@"请输入到账银行卡号",@"请输入验证码"];
    }
    return _palceHolderArr;
}
//18926066086  6214867815870507
//17606619884   6270611103003846108
-(void)checkBackqualified:(NSString *)bankStr{
    //
    if (bankStr.length > 8) {
        NSString *binUrl  =@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json";
        NSDictionary *binDic =@{@"cardNo":bankStr,@"cardBinCheck":@"true"};
       
        [PPNetworkHelper GET:[JFHSUtilsTool conectUrl:[binDic mutableCopy]url:binUrl] parameters:nil success:^(id responseObject) {
           
            
            JTLog(@"%@",responseObject);
            //validated  0
            if ([[NSString stringWithFormat:@"%@",responseObject[@"validated"]]isEqualToString:@"0"]) {
                //银行卡 错误
               
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"银行卡错误"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            }else{
                //判断是不是借记卡
                if ([[NSString stringWithFormat:@"%@",responseObject[@"cardType"]]isEqualToString:@"DC"]) {
                    //bank
                    self.bankType = [NSString stringWithFormat:@"%@",responseObject[@"bank"]];
                }else{
               
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"暂不支持该卡,请填写其他借记卡"];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                }
            }
        } failure:^(NSError *error) {
           
        }];
    }else{
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请输入正确的银行卡号"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }
}
-(void)checkBackqualifiedTeleNumberStr:(NSString  *)tele bankStr:(NSString *)bank codeBtn:(UIButton *)btn{
    if (bank.length > 8) {
        NSString *binUrl  =@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json";
        NSDictionary *binDic =@{@"cardNo":bank,@"cardBinCheck":@"true"};
        
        [PPNetworkHelper GET:[JFHSUtilsTool conectUrl:[binDic mutableCopy]url:binUrl] parameters:nil success:^(id responseObject) {
            
            
            JTLog(@"%@",responseObject);
            //validated  0
            if ([[NSString stringWithFormat:@"%@",responseObject[@"validated"]]isEqualToString:@"0"]) {
                //银行卡 错误
                
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"银行卡错误"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            }else{
                //判断是不是借记卡
                if ([[NSString stringWithFormat:@"%@",responseObject[@"cardType"]]isEqualToString:@"DC"]) {
                    //bank
                    self.bankType = [NSString stringWithFormat:@"%@",responseObject[@"bank"]];
                    if (self.bankArr.count) {
                        [self.bankArr enumerateObjectsUsingBlock:^(JTCertificationModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([model.bankBin isEqualToString:self.bankType]) {
                                //获取到对应的bin拿到bankcode
                                [self getCodeDataBackCode:model.bankCode xteleNumberStr:tele bankStr:bank codeBtn:btn];
                                //停止循环
                                self.isBankTypeQualified = YES;
                                *stop = YES;
                            }
                        }];
                        if (self.isBankTypeQualified  == NO) {
                            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"银行卡错误或不支持的银行卡"];
                            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                        }
                    }
                }else{
                    
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"暂不支持该卡,请填写其他借记卡"];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请输入正确的银行卡号"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }
}
//18575511205
@end
