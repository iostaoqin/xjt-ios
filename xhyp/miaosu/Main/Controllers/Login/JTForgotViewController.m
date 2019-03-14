//
//  JTForgotViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTForgotViewController.h"
#import "JTSettingViewController.h"
@interface JTForgotViewController ()<UITableViewDelegate,UITableViewDataSource,getForgetCodeDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *forgotPwTb;
@property (nonatomic, strong)NSArray *imgArr;
@property (nonatomic, strong)NSArray *placeStrArr;
@end

@implementation JTForgotViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
     self.title = @"忘记密码";
    self.view.backgroundColor  =[UIColor colorWithHexString:@"#F5F5F5"];
      [self regitedTableView];
    if (@available(iOS 11.0, *)) {
        _forgotPwTb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
-(void)leftBarButtonItemEvent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)regitedTableView{
    self.forgotPwTb  =[[UITableView alloc]initWithFrame:CGRectMake(0,20 * JT_ADAOTER_WIDTH, JT_ScreenW, JT_ScreenH) style:UITableViewStylePlain];
    [self.view addSubview:self.forgotPwTb];
    self.forgotPwTb.delegate  = self;
    self.forgotPwTb.dataSource  = self;
    self.forgotPwTb.scrollEnabled = NO;
    self.forgotPwTb.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.forgotPwTb.tableFooterView  =[UIView new];
    self.forgotPwTb.backgroundColor  =[UIColor colorWithHexString:@"#F5F5F5"];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imgArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 *JT_ADAOTER_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 160*JT_ADAOTER_WIDTH;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"cell";
    JTForgotTableViewCell *registedCell  =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!registedCell) {
        registedCell =[[JTForgotTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    if (indexPath.row == 1) {
        registedCell.codeBtn.hidden  = NO;
        [registedCell.teleTextFiled mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120 *JT_ADAOTER_WIDTH);
        }];
        registedCell.forgotCodeDelegate = self;
    }
    registedCell.teleTextFiled.delegate  =self;
    registedCell.selectionStyle =UITableViewCellSelectionStyleNone;
    registedCell.backgroundColor= [UIColor whiteColor];
    if (indexPath.row == 0||indexPath.row  == 1) {
        registedCell.teleTextFiled.keyboardType  = UIKeyboardTypeNumberPad;
    }else{
        registedCell.teleTextFiled.keyboardType  = UIKeyboardTypeASCIICapable;
    }
    [registedCell getForgotNameStr:self.imgArr[indexPath.row] placeHolderText:self.placeStrArr[indexPath.row] typeView:@""indexStr:indexPath.row];
    if (indexPath.row   == 0) {
        if (![JFHSUtilsTool isBlankString:[[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"]]) {
            //注册登录 过的直接显示电话号码
            registedCell.teleTextFiled.text  = [[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"];
            
        }
    }
    return registedCell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView =[UIView new];
    CGFloat registFont;
    if (JT_IS_iPhone5) {
        registFont  = 16;
    }else{
        registFont  = 18;
    }
    
    UIButton *sureBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:315* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#01D3C7"];
    [sureBtn setTitle:@"重置" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = kFontSystem(registFont);
    [footerView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(315 *JT_ADAOTER_WIDTH,  46 *JT_ADAOTER_WIDTH));
        make.centerX.equalTo(footerView);
        make.top.equalTo(footerView.mas_top).offset(20);
    }];
    [sureBtn addTarget:self action:@selector(sureBtnnClick) forControlEvents:UIControlEventTouchUpInside];
  
    return footerView;
}
#pragma mark -  UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger len  = 0;
    if (textField.tag == 1000) {
        
        len  = 11;
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > len && range.length !=1) {
            textField.text = [toBeString substringToIndex:len];
            return NO;
        }
    }else if(textField.tag  == 1002){
        //密码 6-16位
        len  = 16;
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > len && range.length !=1) {
            textField.text = [toBeString substringToIndex:len];
            return NO;
        }
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -  确定重置密码
-(void)sureBtnnClick{
    NSIndexPath *index  =[NSIndexPath indexPathForRow:0 inSection:0];
    JTForgotTableViewCell *teleCell = (JTForgotTableViewCell *)[_forgotPwTb cellForRowAtIndexPath:index];//手机号
    NSIndexPath *codeIndex  =[NSIndexPath indexPathForRow:1 inSection:0];
    JTForgotTableViewCell *codeCell = (JTForgotTableViewCell *)[_forgotPwTb cellForRowAtIndexPath:codeIndex];//验证码
    NSIndexPath *passwordIndex  =[NSIndexPath indexPathForRow:2 inSection:0];
    JTForgotTableViewCell *passwordCell = (JTForgotTableViewCell *)[_forgotPwTb cellForRowAtIndexPath:passwordIndex];//密码
    NSIndexPath *passwordAIndex  =[NSIndexPath indexPathForRow:3 inSection:0];
    JTForgotTableViewCell *passwordACell = (JTForgotTableViewCell *)[_forgotPwTb cellForRowAtIndexPath:passwordAIndex];//重复密码
    //回收键盘
    [teleCell.teleTextFiled resignFirstResponder];
    [codeCell.teleTextFiled resignFirstResponder];
    [passwordACell.teleTextFiled resignFirstResponder];
    [passwordCell.teleTextFiled resignFirstResponder];
    if ([JFHSUtilsTool isBlankString:teleCell.teleTextFiled.text]||[JFHSUtilsTool isBlankString:codeCell.teleTextFiled.text]||[JFHSUtilsTool isBlankString:passwordCell.teleTextFiled.text]||[JFHSUtilsTool isBlankString:passwordACell.teleTextFiled.text]) {
        NSString *msg;
        msg = [JFHSUtilsTool isBlankString:teleCell.teleTextFiled.text]?teleCell.teleTextFiled.placeholder:[JFHSUtilsTool isBlankString:codeCell.teleTextFiled.text]?codeCell.teleTextFiled.placeholder:[JFHSUtilsTool isBlankString:passwordCell.teleTextFiled.text]?passwordCell.teleTextFiled.placeholder:[JFHSUtilsTool isBlankString:passwordACell.teleTextFiled.text]?[NSString stringWithFormat:@"请输入%@",passwordACell.teleTextFiled.placeholder]:@"";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:msg];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
        //先判断用户输入的密码位数是否合格
        if ([passwordCell.teleTextFiled.text length]<6 ||[passwordCell.teleTextFiled.text length]>16  ) {
            //提示 用户
            [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeText msgStr:passwordCell.teleTextFiled.placeholder];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        }else{
            //判断两次输入的密码是否一致
            if ([passwordCell.teleTextFiled.text isEqualToString:passwordACell.teleTextFiled.text]) {
                NSString *forgotUrl= [NSString stringWithFormat:@"%@/xjt/user/forgetPassword",JT_MS_URL];
                NSDictionary *forgotDic  =@{@"phoneNumber":teleCell.teleTextFiled.text,@"msgCode":codeCell.teleTextFiled.text};
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
                [JFHttpsTool requestType:@"POST" passwordStr:[JFHSUtilsTool md5HexDigest:passwordCell.teleTextFiled.text] putWithUrl:forgotUrl withParameter:forgotDic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
                    JTLog(@"%@",data);
                    if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                        //调用登录接口
                        [self loginData:[JFHSUtilsTool md5HexDigest:passwordCell.teleTextFiled.text] teleNumberStr:teleCell.teleTextFiled.text];
                        
                    }else{
                        //错误提示信息
                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:data[@"resultCodeMessage"]];
                            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                        });
                        
                    }
                } withErrorCodeTwo:^{
                    
                } withErrorBlock:^(NSError * _Nonnull error) {
                    
                }];
            }else{
                //不一致密码 提示用户
                
                [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"两次输入的密码不一致"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            }
    }
    }
}
-(void)loginData:(NSString *)password teleNumberStr:(NSString *)xteleNumberStr{
    NSString *LogStr  = [NSString stringWithFormat:@"%@/xjt/user/loginByPassword",JT_MS_URL];
    NSDictionary *logDic = @{@"phoneNumber":xteleNumberStr};
    JTLog(@"%@  %@",password,xteleNumberStr);
    NSString *loginUrl  = [JFHSUtilsTool conectUrl:[logDic mutableCopy] url:LogStr];
    [PPNetworkHelper setValue:password forHTTPHeaderField:@"password"];
    [PPNetworkHelper GET:loginUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //登录成功 保存key 和userId
            JFUserInfoTool  *userInfo  =[JFUserManager shareManager].currentUserInfo;
            userInfo.keyStr  =[NSString stringWithFormat:@"%@",responseObject[@"key"]];
            userInfo.userIdStr  =[NSString stringWithFormat:@"%@",responseObject[@"userId"]];
//            userInfo.xteleNumberStr  = xteleNumberStr;
            [[NSUserDefaults standardUserDefaults]setValue:xteleNumberStr forKey:@"teleValue"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [JFUserManager shareManager].currentUserInfo  =userInfo;
            //发送通知修改左侧VC等 登录状态显示
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSucessNotice" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"重置密码成功"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.pwType == forgotpw_change) {
                
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[JTSettingViewController class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            });
            //发送通知到主界面 重新请求用户个人信息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"personalSucessNotice" object:nil];
        }else{
            //错误信息
            
        }
    } failure:^(NSError *error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
}
#pragma mark  - 获取验证码事件
-(void)getCodeEvent:(UIButton *)codeBtn{
    //判断用户是否填写了手机号
    NSIndexPath *index  =[NSIndexPath indexPathForRow:0 inSection:0];
    JTForgotTableViewCell *teleCell = (JTForgotTableViewCell *)[_forgotPwTb cellForRowAtIndexPath:index];//手机号
    [teleCell.teleTextFiled resignFirstResponder];
    if ([JFHSUtilsTool isBlankString:teleCell.teleTextFiled.text]) {
        NSString *msg;
        msg = [JFHSUtilsTool isBlankString:teleCell.teleTextFiled.text]?teleCell.teleTextFiled.placeholder:@"";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:msg];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
        //发送验证码之前  检查手机是否为11位
        if ([teleCell.teleTextFiled.text length]<11) {
            //提示用户
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请输入11位的手机号"];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        }else{
       
        //获取验证码
        NSString *codeUrl =[NSString stringWithFormat:@"%@/xjt/msgCode",JT_MS_URL];
        NSDictionary *codeDic =@{@"phoneNumber":teleCell.teleTextFiled.text,@"signTemplateId":app_name_xiao_type,@"channelCode":@"prod-ios",@"msgType":@"2"};
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
        [PPNetworkHelper GET:codeUrl parameters:codeDic success:^(id responseObject) {
            JTLog(@"发送验证码=%@",responseObject);
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
                //发送成功
                [self getCodeBtn:codeBtn];
            }else{
                //错误提示信息
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeMessage"]];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                });
            }
        } failure:^(NSError *error) {
             [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        }];
    }
    }
}
-(NSArray *)imgArr{
    if (!_imgArr) {
        _imgArr=  @[@"手机号码",@"验证码",@"新密码",@"重复密码"];
    }
    return _imgArr;
}
-(NSArray *)placeStrArr{
    if (!_placeStrArr) {
        _placeStrArr =  @[@"请输入手机号",@"请输入验证码",@"请输入6-16位密码",@"重复新密码"];
    }
    return _placeStrArr;
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
