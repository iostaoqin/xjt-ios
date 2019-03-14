//
//  JTForgotViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTCPWViewController.h"
#import "JTForgotViewController.h"
@interface JTCPWViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *changePwTb;
@property (nonatomic, strong)NSArray *imgArr;
@property (nonatomic, strong)NSArray *placeStrArr;

@end

@implementation JTCPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  = @"修改登录密码";
    [self changePWUI];
    if (@available(iOS 11.0, *)) {
        _changePwTb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
-(void)leftBarButtonItemEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)changePWUI{
    self.changePwTb  =[[UITableView alloc]initWithFrame:CGRectMake(0,0, JT_ScreenW, JT_ScreenH) style:UITableViewStylePlain];
    [self.view addSubview:self.changePwTb];
    self.changePwTb.delegate  = self;
    self.changePwTb.dataSource  = self;
    self.changePwTb.scrollEnabled = NO;
    self.changePwTb.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.changePwTb.tableFooterView  =[UIView new];
    self.changePwTb.backgroundColor =  [UIColor colorWithHexString:@"#F5F5F5"];
    CGFloat registFont;
    if (JT_IS_iPhone5) {
        registFont  = 16;
    }else{
        registFont  = 18;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imgArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 160*JT_ADAOTER_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 *JT_ADAOTER_WIDTH;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =[UIView new];
    headerView.backgroundColor=  [UIColor colorWithHexString:@"#F5F5F5"];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView =[UIView new];
    CGFloat registFont;
    UIButton *forgotBtn  =[UIButton  buttonWithType:UIButtonTypeSystem];
    [footerView addSubview:forgotBtn];
    if (JT_IS_iPhone5) {
        registFont  = 16;
        forgotBtn.titleLabel.font = kFontSystem(14);
    }else{
        registFont  = 18;
        forgotBtn.titleLabel.font = kFontSystem(16);
    }
    
    UIButton *changePWBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:315* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"01D3C7"];
    [changePWBtn setTitle:@"修改" forState:UIControlStateNormal];
    changePWBtn.titleLabel.font = kFontSystem(registFont);
    [footerView addSubview:changePWBtn];
    [changePWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(315 *JT_ADAOTER_WIDTH,  46 *JT_ADAOTER_WIDTH));
        make.centerX.equalTo(footerView);
        make.top.equalTo(footerView.mas_top).offset(24*JT_ADAOTER_WIDTH);
    }];
    
    [forgotBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgotBtn setTitle:@"忘记密码" forState:UIControlStateSelected];
    [forgotBtn setTitleColor:[UIColor colorWithHexString:@"#10ACDC"] forState:UIControlStateNormal];
    [forgotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerView);
        make.top.equalTo(changePWBtn.mas_bottom).offset(10);
    }];
    [changePWBtn addTarget:self action:@selector(changePWBtnClick) forControlEvents:UIControlEventTouchUpInside];
       [forgotBtn addTarget:self action:@selector(forgotBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"JTCPWViewController";
    JTForgotTableViewCell *CPWCell  =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!CPWCell) {
        CPWCell =[[JTForgotTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    
    CPWCell.selectionStyle =UITableViewCellSelectionStyleNone;
    CPWCell.backgroundColor = [UIColor whiteColor];
    [CPWCell getForgotNameStr:self.imgArr[indexPath.row] placeHolderText:self.placeStrArr[indexPath.row] typeView:@""indexStr:indexPath.row];
    CPWCell.teleTextFiled.delegate = self;
    CPWCell.teleTextFiled.tag  = indexPath.row;
    CPWCell.teleTextFiled.keyboardType  = UIKeyboardTypeASCIICapable;
//    if (indexPath.row   == 0) {
//        if (![JFHSUtilsTool isBlankString:[[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"]]) {
//            //注册登录 过的直接显示电话号码
//            CPWCell.teleTextFiled.text  = [[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"];
//
//        }
//    }
    return CPWCell;
}
#pragma mark -  UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger len  = 0;
    if(textField.tag  == 1002){
        //密码 6-16位
        len  = 16;
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > len && range.length !=1) {
            textField.text = [toBeString substringToIndex:len];
            return NO;
        }
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark  - 忘记密码
-(void)forgotBtnClick{
    JTForgotViewController *forgotVC =[[JTForgotViewController alloc]init];
    forgotVC.pwType = forgotpw_change;
    [self.navigationController pushViewController:forgotVC animated:YES];
}
#pragma mark -  修改密码
-(void)changePWBtnClick{
    NSIndexPath *originalIndex  = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *newIndex  = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *againIndex  = [NSIndexPath indexPathForRow:2 inSection:0];
    JTForgotTableViewCell *originalCell  =(JTForgotTableViewCell  *)[_changePwTb cellForRowAtIndexPath:originalIndex];
    JTForgotTableViewCell *newCell  =(JTForgotTableViewCell  *)[_changePwTb cellForRowAtIndexPath:newIndex];
    JTForgotTableViewCell *againCell  =(JTForgotTableViewCell  *)[_changePwTb cellForRowAtIndexPath:againIndex];
    
    //回收键盘
    [originalCell.teleTextFiled resignFirstResponder];
    [newCell.teleTextFiled resignFirstResponder];
    [againCell.teleTextFiled resignFirstResponder];
    if ([JFHSUtilsTool isBlankString:originalCell.teleTextFiled.text]||[JFHSUtilsTool isBlankString:newCell.teleTextFiled.text]||[JFHSUtilsTool isBlankString:againCell.teleTextFiled.text]) {
        NSString *msg;
        msg = [JFHSUtilsTool isBlankString:originalCell.teleTextFiled.text]?originalCell.teleTextFiled.placeholder:[JFHSUtilsTool isBlankString:newCell.teleTextFiled.text]?newCell.teleTextFiled.placeholder:[JFHSUtilsTool isBlankString:againCell.teleTextFiled.text]?[NSString stringWithFormat:@"请%@",againCell.teleTextFiled.placeholder]:@"";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:msg];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
        //先判断用户输入的密码位数w是否合格
        if ([newCell.teleTextFiled.text length]<6 ||[newCell.teleTextFiled.text length]>16  ) {
            //提示 用户
            [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeText msgStr:newCell.teleTextFiled.placeholder];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        }else{
            //判断两次输入的密码是否一致
            if ([newCell.teleTextFiled.text isEqualToString:againCell.teleTextFiled.text]) {
                NSString *cpwUrl =[NSString stringWithFormat:@"%@/xjt/user/resertPassword",JT_MS_URL];
                NSDictionary *cDic = @{@"newPassword":[JFHSUtilsTool md5HexDigest:newCell.teleTextFiled.text]};
                [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
                [JFHttpsTool requestType:@"POST" passwordStr:[JFHSUtilsTool md5HexDigest:originalCell.teleTextFiled.text] putWithUrl:cpwUrl withParameter:cDic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
                    JTLog(@"%@",data);
                     [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                    if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                        //调用登录接口
                        [self loginCpwData:[JFHSUtilsTool md5HexDigest:newCell.teleTextFiled.text] teleNumberStr:@""];
                         
                    }else{
                        //错误提示信息
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
            }else{
                //不一致密码 提示用户
                
                [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"两次输入的密码不一致"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                
            }
            
            
        }
        
        
    }   
}
-(void)loginCpwData:(NSString *)password teleNumberStr:(NSString *)xteleNumberStr{
    JFUserInfoTool  *userInfo  =[JFUserManager shareManager].currentUserInfo;
    NSString *LogStr  = [NSString stringWithFormat:@"%@/xjt/user/loginByPassword",JT_MS_URL];
    NSDictionary *logDic = @{@"phoneNumber":[[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"]};
    NSString *loginUrl  = [JFHSUtilsTool conectUrl:[logDic mutableCopy] url:LogStr];
    [PPNetworkHelper setValue:password forHTTPHeaderField:@"password"];
    [PPNetworkHelper GET:loginUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //登录成功 保存key 和userId
            
            userInfo.keyStr  =[NSString stringWithFormat:@"%@",responseObject[@"key"]];
            userInfo.userIdStr  =[NSString stringWithFormat:@"%@",responseObject[@"userId"]];
//            userInfo.xteleNumberStr  = xteleNumberStr;
            [[NSUserDefaults standardUserDefaults]setValue:xteleNumberStr forKey:@"teleValue"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [JFUserManager shareManager].currentUserInfo  =userInfo;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"修改密码成功"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            //发送通知到主界面 重新请求用户个人信息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"personalSucessNotice" object:nil];
        }else{
            //错误信息
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
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
}
#pragma mark  - 获取验证码事件
-(void)getCodeEvent:(UIButton *)codeBtn{
    [self getCodeBtn:codeBtn];
}
-(NSArray *)imgArr{
    if (!_imgArr) {
        _imgArr=  @[@"原密码",@"新密码",@"重复密码"];
    }
    return _imgArr;
}
-(NSArray *)placeStrArr{
    if (!_placeStrArr) {
        _placeStrArr =  @[@"请输入原密码",@"请输入6-16位密码",@"重复新密码"];
    }
    return _placeStrArr;
}

@end
