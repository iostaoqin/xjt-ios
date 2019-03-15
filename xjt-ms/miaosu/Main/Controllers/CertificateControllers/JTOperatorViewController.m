//
//  JTOperatorViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTOperatorViewController.h"
#import "JTOperatorView.h"
#import "JTOperationSecondView.h"
#import "JTOperationSucessTableViewCell.h"
NSInteger OperatorViewCount  = 0;
@interface JTOperatorViewController ()<OperatorViewHeaderDelegate,againSubmitDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,  strong)JTOperatorView *operationView;
@property (nonatomic, strong)JTOperationSecondView *operationSecondView;
@property (nonatomic, strong)NSArray *firstNameArr;
@property (nonatomic, strong)NSArray *secondNameArr;
@property (nonatomic, strong)NSArray *nameArr;
@property (nonatomic, strong)NSMutableArray *nameValueArr;
@property (nonatomic, strong)UITableView *sucessTb;
@property (nonatomic, assign)BOOL certicationIs;//是否认证成功
@end

@implementation JTOperatorViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_type ==operator_success||_type  ==certication_success) {
        
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
  
}
-(void)leftBarButtonItemEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.certicationIs  = YES;
    self.nameValueArr =[NSMutableArray array];
    //成功是另外的布局
    [self sucessTbUI];
    if (_type  == certication_success) {
        //实名认证成功之后 请求接口
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
        [self certicationSucessData];
    }else{
        //请求运营商接口
         [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
        if (self.type  ==operator_review) {
            //认证中 就不请求接口了 直接显示 数据    认证进度的时间用存本地 的时间戳
            [self authenticationOperator];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        }else{
             [self xyActionData];
        }
       
    }
    if (@available(iOS 11.0, *)) {
        _sucessTb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}
#pragma mark - 运营商认证中界面
-(void)authenticationOperator{
    JFUserInfoTool *user  =[JFUserManager shareManager].currentUserInfo;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
    self.secondNameArr  = @[@"认证进度",[NSString stringWithFormat:@"%@提交运营商认证审核", [JFHSUtilsTool getDateStringWithTimeStr:user.operatorTimeStr showType:@"yyyy-MM-dd"]],@"认证一般在2-15分钟内审核完毕"];
    //认证中
    [self.operationView getOperationLogoImg:@"Operator"];
    [self.operationSecondView gettTiltNameStr:@"提交成功,审核中..." detailStrArr:self.secondNameArr showType:1];
}
#pragma mark  -运营商认证接口请求
-(void)xyActionData{
    
    NSString *suceessUrl  =[NSString stringWithFormat:@"%@/xjt/user/mobileVerifiedInfo",JT_MS_URL];
    JFUserInfoTool  *user  = [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:user.keyStr]) {
        [PPNetworkHelper setValue:user.keyStr forHTTPHeaderField:@"API_KEY"];
    }
    [PPNetworkHelper GET:suceessUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            NSDictionary *valuDic=  responseObject[@"mobileVerifiedInfo"];
            if ([[NSString stringWithFormat:@"%@",valuDic[@"mobileVerified"]]isEqualToString:@"1"]) {
                //运营商认证成功
                self.nameArr  =  @[@"手机号码",@"通讯录",@"运营商认证",@"提交时间",@"通过时间"];
                JTCertificationModel *model  =[JTCertificationModel mj_objectWithKeyValues:valuDic];
                model.creationDate   = [JFHSUtilsTool getDateStringWithTimeStr:model.creationDate showType:@"yyyy-MM-dd"];
                model.mobileVerifiedDate   = [JFHSUtilsTool getDateStringWithTimeStr:model.mobileVerifiedDate showType:@"yyyy-MM-dd  HH:mm:ss"];
                [self.nameValueArr  addObject:model];
                [self.sucessTb reloadData];
            }else{
                //运营商认证失败 显示的是另外的UI
                 [self.navigationController setNavigationBarHidden:YES animated:YES];
                self.secondNameArr  = @[@"失败原因",[NSString stringWithFormat:@"%@",valuDic[@"failReason"]],@"认证一般在2-15分钟内审核完毕"];
                self.view.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
                //失败
                [self.operationView getOperationLogoImg:@"Operator_fail"];
                [self.operationSecondView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(230 *JT_ADAOTER_WIDTH);
                }];
                [self.operationSecondView gettTiltNameStr:@"认证失败" detailStrArr:self.secondNameArr showType:2];
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
        
    } failure:^(NSError *error) {
         [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
}
#pragma mark  - 实名认证成功之后
-(void)certicationSucessData{
    NSString *suceessUrl  =[NSString stringWithFormat:@"%@/xjt/user/realnameVerifiedInfo",JT_MS_URL];
    JFUserInfoTool  *user  = [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:user.keyStr]) {
        [PPNetworkHelper setValue:user.keyStr forHTTPHeaderField:@"API_KEY"];
    }
    [PPNetworkHelper GET:suceessUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            NSDictionary *valuDic=  responseObject[@"realnameVerifiedInfo"];
            if ([[NSString stringWithFormat:@"%@",valuDic[@"realnameVerified"]]isEqualToString:@"1"]) {
                self.certicationIs  = YES;
            }else{
                self.certicationIs  = NO;
            }
            self.nameArr  =  @[@"姓名",@"身份证号",@"有效期",@"审核状态",@"提交时间",@"通过时间"];
            JTCertificationModel *model  =[JTCertificationModel mj_objectWithKeyValues:valuDic];
            model.creationDate   = [JFHSUtilsTool getDateStringWithTimeStr:model.creationDate showType:@"yyyy-MM-dd"];
            model.realnameVerifiedDate   = [JFHSUtilsTool getDateStringWithTimeStr:model.realnameVerifiedDate showType:@"yyyy-MM-dd  HH:mm:ss"];
            [self.nameValueArr  addObject:model];
            [self.sucessTb reloadData];
            
        }
    } failure:^(NSError *error) {
        JTLog(@"%@",error);
         [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
    
}
-(void)sucessTbUI{
    _sucessTb = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.sucessTb];
    _sucessTb.delegate  = self;
    _sucessTb.dataSource =self;
    _sucessTb.tableFooterView   =[UIView new];
    _sucessTb.scrollEnabled  = NO;
    _sucessTb.separatorStyle  =UITableViewCellSeparatorStyleNone;
    _sucessTb.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.nameArr.count) {
        return self.nameArr.count;
    }return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.nameArr.count) {
        return 160;
    } return 0;
   
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView =[UIView new];[UIColor colorWithHexString:@"F5F5F5"];
    //实名认证失败的时候  有重新提交按钮
    UIView *fainView= [UIView new];
    fainView.backgroundColor= [UIColor whiteColor];
    [footerView addSubview:fainView];
    [fainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(footerView);
        make.height.mas_offset(80);
    }];
    UIButton *againSubmitBtn   =[UIButton new];
    [againSubmitBtn setTitle:@"重新提交审核" forState:UIControlStateNormal];
    [againSubmitBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    againSubmitBtn.layer.cornerRadius = 3;
    againSubmitBtn.layer.borderWidth = 1;
    againSubmitBtn.layer.borderColor  =[UIColor colorWithHexString:@"#D9D9D9"].CGColor;
    againSubmitBtn.layer.masksToBounds= YES;
    [fainView addSubview:againSubmitBtn];
    
    [againSubmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140 *JT_ADAOTER_WIDTH, 36*JT_ADAOTER_WIDTH));
        make.centerX.equalTo(fainView);
        make.top.equalTo(fainView.mas_top).offset(30*JT_ADAOTER_WIDTH);
    }];
    UILabel *secondLable  =[UILabel new];
    [footerView addSubview:secondLable];
   
    secondLable.textColor =[UIColor colorWithHexString:@"#999999"];
    if (JT_IS_iPhone5) {
        secondLable.font  = kFontSystem(10);
        againSubmitBtn.titleLabel.font   = kFontSystem(14);
    }else{
        secondLable.font  = kFontSystem(12);
        againSubmitBtn.titleLabel.font   = kFontSystem(16);
    }
    [secondLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.top.equalTo(fainView.mas_bottom).offset(14*JT_ADAOTER_WIDTH);
    }];
    [againSubmitBtn addTarget:self action:@selector(fainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    againSubmitBtn.hidden = YES;
    if (_type  == certication_success) {
        secondLable.text  = @"实名认证通过后不可更改";
        if (self.certicationIs  == NO) {
            againSubmitBtn.hidden = NO;
        }else{
            [fainView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(30);
            }];
        }
    }else{
        [fainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(30);
        }];
        secondLable.text  = @"运营商认证六个月更新一次，请及时认证。";
    }
    
    
    return  footerView;
}
#pragma mark  - 实名认证失败 事件
-(void)fainBtnClick{
    //发送通知 回到认证中心页面并自动再次进行认证
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"againCerticationnNotice" object:nil];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =[UIView new];
    headerView.backgroundColor  =[UIColor whiteColor];
    return  headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.nameValueArr.count) {
        return 20;
    }return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"JTOperationSucessTableViewCell";
    JTOperationSucessTableViewCell *sucessCell  =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!sucessCell) {
        sucessCell=[[JTOperationSucessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    sucessCell.backgroundColor =[UIColor whiteColor];
    sucessCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.nameValueArr.count) {
        JTCertificationModel *model  =self.nameValueArr[0];
        if (_type ==certication_success) {
            //实名认证
            [sucessCell getLtftNameStr:self.nameArr[indexPath.row] rightNameStr:model showTypeIdx:indexPath.row type:4];
        }else{
            //运营商认证
            [sucessCell getLtftNameStr:self.nameArr[indexPath.row] rightNameStr:model showTypeIdx:indexPath.row type:1];
        }
        
    }
    return sucessCell;
}
-(JTOperationSecondView *)operationSecondView{
    if (!_operationSecondView) {
        _operationSecondView =[JTOperationSecondView new];
        [self.view addSubview:_operationSecondView];
        _operationSecondView.delegate = self;
        _operationSecondView.backgroundColor =[UIColor whiteColor];
        [_operationSecondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.operationView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(170 *JT_ADAOTER_WIDTH);
        }];
    }
    return _operationSecondView;
}
-(JTOperatorView *)operationView{
    if (!_operationView) {
        _operationView  =[[JTOperatorView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, 180 *JT_ADAOTER_WIDTH)];
        _operationView.delegate  = self;
        [_operationView setGradientBackgroundColor:@"#10ACDC" secondColor:@"#00D4C7"];
        [self.view addSubview:_operationView];
    }
    return _operationView;
}
#pragma mark - 重新提交审核
-(void)againSubmitEvent{
    //返回上一页   发送 通知 直接进行运营商认证
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"xyAgainCerticationNotion" object:nil];
}

-(void)OperatorViewleftBarButtonItemEvent{
    [self.navigationController  popViewControllerAnimated:YES];
}

@end
