//
//  JTLoginViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTLoginViewController.h"
#import "JTLoginView.h"
#import "JTRegistedViewController.h"
#import "JTForgotViewController.h"
@interface JTLoginViewController ()<UITableViewDelegate,UITableViewDataSource,registedUserDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *loginTable;
@property (nonatomic, strong)NSArray *imgArr;
@property (nonatomic, strong)NSArray *placeStrArr;
@property (nonatomic, strong)JTLoginView *loginView;
@end

@implementation JTLoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //关闭按钮
    [self closeUI];
    if (@available(iOS 11.0, *)) {
        _loginTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
-(void)closeUI{
    CGFloat font;
    if (JT_IS_iPhone5) {
        font = 16;
    }else{
        font = 18;
    }
    UIButton  *comeBack = [UIButton  buttonWithType:UIButtonTypeCustom];
    [comeBack setImage:[UIImage imageNamed:@"new_closeImg"] forState:UIControlStateNormal];
    [comeBack setFrame:CGRectMake(20 *JT_ADAOTER_WIDTH, JT_STATUS_BAR_HEIGHT, 44*JT_ADAOTER_WIDTH, 44*JT_ADAOTER_WIDTH)];
    [self.view addSubview:comeBack];
    [comeBack addTarget:self action:@selector(comeBackEvent) forControlEvents:UIControlEventTouchUpInside];
    //登录
    UILabel *nameLable =[UILabel new];
    [self.view addSubview:nameLable];
    nameLable.text= @"登录";
    nameLable.textColor= [UIColor colorWithHexString:@"#333333"];
    nameLable.font =  kFontSystem(font);
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.view);
        make.centerY.equalTo(comeBack);
    }];
    //logoImg
    UIImageView *loginImg  = [UIImageView new];
    [self.view addSubview:loginImg];
    loginImg.image = [UIImage imageNamed:@"loginLogo"];
    [loginImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75 *JT_ADAOTER_WIDTH, 75*JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(JT_NAV + 23*JT_ADAOTER_WIDTH);
    }];
    //tb
    self.loginTable  =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.loginTable];
    self.loginTable.delegate  = self;
    self.loginTable.dataSource  = self;
    self.loginTable.scrollEnabled = NO;
    self.loginTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loginTable.tableFooterView  =[UIView new];
    [self.loginTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(loginImg.mas_bottom).offset(60*JT_ADAOTER_WIDTH);
        make.height.mas_equalTo(120 * JT_ADAOTER_WIDTH);
    }];

//登录
   
    UIButton *loginBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:315* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
    [self.view addSubview:loginBtn];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = kFontSystem(font);
    [loginBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(315* JT_ADAOTER_WIDTH, 46* JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.loginTable.mas_bottom).offset(30* JT_ADAOTER_WIDTH);
    }];
    //注册
    JTLoginView *loginView  =[[JTLoginView alloc]init];
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(20* JT_ADAOTER_WIDTH);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40* JT_ADAOTER_WIDTH);
    }];
    loginView.delegate  =self;
    [loginBtn addTarget:self action:@selector(loginBtnEventClick) forControlEvents:UIControlEventTouchUpInside];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imgArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 *JT_ADAOTER_WIDTH;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"cell";
    JTLoginTableViewCell *registedCell  =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!registedCell) {
        registedCell =[[JTLoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    registedCell.selectionStyle =UITableViewCellSelectionStyleNone;
    registedCell.teleTextFiled.delegate =self;
    [registedCell getLogiImg:self.imgArr[indexPath.row] placeHolderText:self.placeStrArr[indexPath.row] typeView:@""];
    registedCell.teleTextFiled.tag =  1000 + indexPath.row;
    if (indexPath.row   == 0) {
        if (![JFHSUtilsTool isBlankString:[[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"]]) {
            //注册登录 过的直接显示电话号码
            registedCell.teleTextFiled.text  = [[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"];
            
        }
        registedCell.teleTextFiled.keyboardType  = UIKeyboardTypeNumberPad;
    }else{
        //显示英文键盘
        registedCell.teleTextFiled.autocorrectionType  = UITextAutocapitalizationTypeNone;
         registedCell.teleTextFiled.keyboardType  = UIKeyboardTypeASCIICapable;
    }
    return registedCell;
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
    }else if(textField.tag  == 1001){
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

    
//    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 登录事件
-(void)loginBtnEventClick{
    NSIndexPath *index  =[NSIndexPath indexPathForRow:0 inSection:0];
    JTLoginTableViewCell *teleCell = (JTLoginTableViewCell *)[_loginTable cellForRowAtIndexPath:index];//手机号
    NSIndexPath *passwordIndex  =[NSIndexPath indexPathForRow:1 inSection:0];
    JTLoginTableViewCell *passwordCell = (JTLoginTableViewCell *)[_loginTable cellForRowAtIndexPath:passwordIndex];//密码
    //回收键盘
    [teleCell.teleTextFiled resignFirstResponder];
    [passwordCell.teleTextFiled resignFirstResponder];
    if ([JFHSUtilsTool isBlankString:teleCell.teleTextFiled.text]||[JFHSUtilsTool isBlankString:passwordCell.teleTextFiled.text]) {
        NSString *msg;
        msg = [JFHSUtilsTool isBlankString:teleCell.teleTextFiled.text]?teleCell.teleTextFiled.placeholder:[JFHSUtilsTool isBlankString:passwordCell.teleTextFiled.text]?passwordCell.teleTextFiled.placeholder:@"";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:msg];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
        if ([teleCell.teleTextFiled.text length]<11) {
            //提示用户
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请输入11位的手机号"];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        }else{
            //调用登录接口
              [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
            [self loginData:[JFHSUtilsTool md5HexDigest:passwordCell.teleTextFiled.text] teleNumberStr:teleCell.teleTextFiled.text];
            
        }
    }
}
-(void)loginData:(NSString *)password teleNumberStr:(NSString *)xteleNumberStr{
    NSString *LogStr  = [NSString stringWithFormat:@"%@/xjt/user/loginByPassword",JT_MS_URL];
    NSDictionary *logDic = @{@"phoneNumber":xteleNumberStr};
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
            [JFUserManager shareManager].currentUserInfo  =userInfo;
            [[NSUserDefaults standardUserDefaults]setValue:xteleNumberStr forKey:@"teleValue"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"登录成功"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            //发送通知修改左侧VC和mainVC等 登录状态显示
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSucessNotice" object:nil];
            //发送通知到主界面 重新请求用户个人信息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"personalSucessNotice" object:nil];
        }else{
            //错误信息
            
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeMessage"]];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            });
        }
    } failure:^(NSError *error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
}
#pragma mark  - 立即注册
-(void)registedClick{
    JTRegistedViewController *registedVC  =[[JTRegistedViewController alloc]init];
    registedVC.title = @"注册";
    [self.navigationController pushViewController:registedVC animated:YES];
}
#pragma mark -  忘记密码
-(void)forgotPasswordClick{
    JTForgotViewController *forgotVC =[[JTForgotViewController alloc]init];
    forgotVC.pwType = forgotpw_login;
    [self.navigationController pushViewController:forgotVC animated:YES];
}
-(NSArray *)imgArr{
    if (!_imgArr) {
        _imgArr=  @[@"tele",@"lock"];
    }
    return _imgArr;
}
-(NSArray *)placeStrArr{
    if (!_placeStrArr) {
        _placeStrArr =  @[@"请输入手机号",@"请输入6-16位密码"];
    }
    return _placeStrArr;
}

-(void)comeBackEvent{
    //回收键盘
    NSIndexPath *index  =[NSIndexPath indexPathForRow:0 inSection:0];
    JTLoginTableViewCell *teleCell = (JTLoginTableViewCell *)[_loginTable cellForRowAtIndexPath:index];//手机号
    NSIndexPath *passwordIndex  =[NSIndexPath indexPathForRow:1 inSection:0];
    JTLoginTableViewCell *passwordCell = (JTLoginTableViewCell *)[_loginTable cellForRowAtIndexPath:passwordIndex];//密码
    [teleCell.teleTextFiled resignFirstResponder];
     [passwordCell.teleTextFiled resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
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
