//
//  JFUserLoginViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/24.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFUserLoginViewController.h"
#import "ViewController.h"
#import "JFNewDeatilCardViewController.h"
#import "JFEditeUsersInformationViewController.h"
#import "JFSettingUsersViewConntroller.h"
#import "JFSuggestUsersViewController.h"
@interface JFUserLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong)UITextField *teleTextFiled;
@property (nonatomic, strong)UITextField *codeTextFiled;
@end

@implementation JFUserLoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupU];
}
-(void)setupU{
    WEAKSELF;
    //顶部图片
    UIImageView *topImg  = [UIImageView new];
    [self.view addSubview:topImg];
    topImg.image =[UIImage imageNamed:@"new_img_login_bg"];
    topImg.backgroundColor  =[UIColor clearColor];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(JT_ScreenW, JT_ADAOTER_WIDTH * 256));
        make.top.equalTo(self.view);
    }];
    
    //返回按钮
    UIButton  *comeBack = [UIButton  buttonWithType:UIButtonTypeCustom];
    [comeBack setImage:[UIImage imageNamed:@"mine_comeBack_img"] forState:UIControlStateNormal];
    [comeBack setFrame:CGRectMake(20, JT_STATUS_BAR_HEIGHT, 50 *JT_ADAOTER_WIDTH, 50 *JT_ADAOTER_WIDTH)];
    [self.view addSubview:comeBack];
    [comeBack addTarget:self action:@selector(comeBackEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //lable 登录
    UILabel *loginNameLable = [UILabel new];
    [topImg addSubview:loginNameLable];
    loginNameLable.text  = @"登录";
    loginNameLable.font  = kFontSystem(18);
    loginNameLable.textColor = [UIColor colorWithHexString:@"#ffffff"];
    [loginNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImg);
        make.top.equalTo(topImg.mas_top).offset(JT_NAV/2);
      
    }];
    UIImageView *loginImg  = [UIImageView new];
    loginImg.image =[UIImage imageNamed:@"new_login_Logo_img"];
    [topImg addSubview:loginImg];
    [loginImg mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(JT_ADAOTER_WIDTH * 100, JT_ADAOTER_WIDTH * 100));
        make.top.equalTo(self.view).offset(JT_NAV);
        make.centerX.equalTo(topImg);
    }];
    UIImageView *tipsImg  = [UIImageView new];
    [topImg addSubview:tipsImg];
    tipsImg.image =[UIImage imageNamed:@"new_img_loginTips"];
    [tipsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(JT_ADAOTER_WIDTH * 200, JT_ADAOTER_WIDTH * 40));
        make.top.equalTo(loginImg.mas_bottom).offset(15 * JT_ADAOTER_WIDTH);
        make.centerX.equalTo(topImg);
    }];
    UIView *firstView  = [UIView new];
    [self.view addSubview:firstView];
    firstView.backgroundColor   =[UIColor clearColor];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImg.mas_bottom).offset(39 *  JT_ADAOTER_WIDTH);
           make.size.mas_equalTo(CGSizeMake(JT_ScreenW, JT_ADAOTER_WIDTH * 60));
    }];
    
    UIImageView *teleImg =  [UIImageView new];
    [firstView addSubview:teleImg];
    teleImg.image= [UIImage imageNamed:@"new_tele_img"];
    [teleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(firstView.mas_left).offset(53);
    }];
    UILabel *teleName  =[UILabel new];
    [firstView addSubview:teleName];
    teleName.text   = @"手机";
    teleName.font =  kFontSystem(14);
    teleName.textColor = [UIColor colorWithHexString:@"333333"];
    [teleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(teleImg.mas_right).offset(8);
        make.centerY.equalTo(teleImg);
    }];
    _teleTextFiled = [UITextField new];
    [firstView addSubview:_teleTextFiled];
    _teleTextFiled.placeholder = @"请输入手机号";
    _teleTextFiled.keyboardType  =UIKeyboardTypeNumberPad;
    _teleTextFiled.font  = kFontSystem(15);
    _teleTextFiled.delegate = self;
     [_teleTextFiled setValue:[UIColor colorWithHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    [_teleTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(teleImg.mas_left);
        make.top.equalTo(teleImg.mas_bottom).offset(20);
        make.right.equalTo(firstView.mas_right).offset(-53);
    }];
    UILabel *line  = [UILabel new];
    [firstView addSubview:line];
    line.backgroundColor  = [UIColor colorWithHexString:@"#EEEEEE"];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.teleTextFiled);
        make.top.equalTo(weakSelf.teleTextFiled.mas_bottom).offset(7);
        make.height.mas_equalTo(@1);
    }];
    //获取 手机验证码
    UIView *codeView  = [UIView new];
    [self.view addSubview:codeView];
    codeView.backgroundColor = [UIColor  clearColor];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstView.mas_bottom).offset(33 *  JT_ADAOTER_WIDTH);
        make.size.mas_equalTo(CGSizeMake(JT_ScreenW, JT_ADAOTER_WIDTH * 60));
    }];
    UIImageView *codeImg =  [UIImageView new];
    [codeView addSubview:codeImg];
    codeImg.image= [UIImage imageNamed:@"new_img_safetyCertificate"];
    [codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(codeView.mas_left).offset(53);
    }];
    UILabel *codeName  =[UILabel new];
    [codeView addSubview:codeName];
    codeName.text   = @"验证码";
    codeName.font =  kFontSystem(14);
    codeName.textColor = [UIColor colorWithHexString:@"333333"];
    [codeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeImg.mas_right).offset(8);
        make.centerY.equalTo(codeImg);
    }];
    //codeTextField
    _codeTextFiled = [UITextField new];
    [codeView addSubview:_codeTextFiled];
    _codeTextFiled.placeholder = @"请输入验证码";
    _codeTextFiled.keyboardType  =UIKeyboardTypeNumberPad;
    _codeTextFiled.delegate = self;
    _codeTextFiled.font  = kFontSystem(15);
    [_codeTextFiled setValue:[UIColor colorWithHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    [_codeTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeImg.mas_left);
        make.top.equalTo(codeImg.mas_bottom).offset(20);
//        make.right.equalTo(codeView.mas_right).offset(-53);
    }];
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _codeBtn.backgroundColor  =[UIColor clearColor];
    [_codeBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    _codeBtn.titleLabel.font  = kFontSystem(12);
    _codeBtn.layer.cornerRadius  = 12 *JT_ADAOTER_WIDTH;
    _codeBtn.layer.borderWidth  = 1;
    _codeBtn.layer.borderColor =[UIColor colorWithHexString:@"dddddd"].CGColor;
    _codeBtn.layer.masksToBounds = YES;
    [codeView addSubview:_codeBtn];
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(100 *JT_ADAOTER_WIDTH, 24));
        make.right.equalTo(codeView.mas_right).offset(-53);
        make.left.equalTo(weakSelf.codeTextFiled.mas_right).offset(-10);
        make.top.equalTo(codeName.mas_bottom).offset(14);
    }];
    [_codeBtn addTarget:self action:@selector(codeBtnEventClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *codeLine  = [UILabel new];
    [codeView addSubview:codeLine];
    codeLine.backgroundColor  = [UIColor colorWithHexString:@"#EEEEEE"];
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.codeTextFiled);
        make.right.equalTo(weakSelf.codeBtn.mas_right);
        make.top.equalTo(weakSelf.codeTextFiled.mas_bottom).offset(7);
        make.height.mas_equalTo(@1);
    }];
    //登录
    UIButton *loginBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    loginBtn.backgroundColor =[UIColor colorWithHexString:@"#FF4D4F"];
 [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font  = kFontSystem(18);
    loginBtn.layer.cornerRadius  = 23 *JT_ADAOTER_WIDTH;
    loginBtn.layer.borderWidth  = 0;
//    codeBtn.layer.borderColor =[UIColor colorWithHexString:@"dddddd"].CGColor;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(270 *JT_ADAOTER_WIDTH, 46));
        make.top.equalTo(codeView.mas_bottom).offset(JT_ADAOTER_WIDTH  * 48);
        make.centerX.equalTo(self.view);
    }];
    [loginBtn addTarget:self action:@selector(loginBtnEventClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)comeBackEvent{
    if ([self.jumControllerVC isEqualToString:@"JFEditeUsersInformationViewController"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 登录事件
-(void)loginBtnEventClick{
    WEAKSELF;
    //回收键盘
    [_codeTextFiled resignFirstResponder];
     [_teleTextFiled resignFirstResponder];
    //检查 是否输入验证码
    if ([JFHSUtilsTool isBlankString:_codeTextFiled.text]) {
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请输入验证码"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
        //提交登录接口
        
      NSString *loginUrl =  [NSString stringWithFormat:@"%@/manager/mgt/bnh/userLogin",HS_USER_URL];
        NSDictionary *loginDic = @{@"os":@"ios",@"appName":app_name_type,@"msgCode":_codeTextFiled.text,@"phoneNumber":_teleTextFiled.text,@"channelCode":@"prod-ios",@"platform":@"ios"};
        NSString *url   =[JFHSUtilsTool conectUrl:[loginDic  mutableCopy] url:loginUrl];
          JTLog(@"登录 URL=%@",url);
        [PPNetworkHelper setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"正在登录..."];
        [PPNetworkHelper POST:url parameters:nil success:^(id responseObject) {
            JTLog(@"%@",responseObject);
            if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
                //登录c成功 存储相应的数据
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                JFUserInfoTool *userInfo = [JFUserManager shareManager].currentUserInfo;
                userInfo.loginSuccessKey  = [NSString stringWithFormat:@"%@",responseObject[@"key"]];
                userInfo.xuserloginIdStr = [NSString stringWithFormat:@"%@",responseObject[@"userId"]];
                userInfo.xteleNumberStr  = weakSelf.teleTextFiled.text;
                [JFUserManager shareManager].currentUserInfo = userInfo;
                //调用神策的登录接口 把匿名id和 登录成功h之后获取id关联
                [[SensorsAnalyticsSDK sharedInstance]login:[NSString stringWithFormat:@"%@",responseObject[@"userId"]]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [weakSelf jumVCEvent];
                });
                //登录成功之后 上传日志 信息
                [self uploadLog];
                //发送 通知 更改设置界面信息和我的界面信息  (用户s退出登录/再次 登录 成功之后)
                if ([self.jumControllerVC isEqualToString:@"JFEditeUsersInformationViewController"]||[self.jumControllerVC isEqualToString:@"JFBigNewEditViewController"]||[self.jumControllerVC isEqualToString:@"JFSuggestUsersViewController"]||[self.jumControllerVC isEqualToString:@"JFSettingUsersViewConntroller"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"loginAgainNotice" object:nil];
                }
            }else{
                //错误 提示信息
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"4"]) {
                    //resultCodeMessage "验证码错误或者过期，请重新获取",
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeMessage"]];
                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                    });
                   
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeDesc"]];
                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                    });
                }
            }
        } failure:^(NSError *error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        }];
        
    }
    
    
}
#pragma mark  - 一系列跳转事件
-(void)jumVCEvent{
    WEAKSELF;
    //点击查看更多   💕 _card_text的时候直接跳转tabar
    if ([self.jumControllerVC isEqualToString:@"JFGiveNewViewController"]) {
        //首页点击
        self.tabBarController.selectedIndex  = 1;
        //回到💕界面 从 0 开始
         [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshFirstDataNotice" object:nil];
    }else if([self.jumControllerVC isEqualToString:@"JFWebNewEditViewController"]){
        //跳转到web界面
        JFWebNewEditViewController *webVC =[[JFWebNewEditViewController alloc]init];
        webVC.url = self.requestStr;
        webVC.whereVC = @"JFUserLoginViewController";
        webVC.webArr=  self.loginWebArr;
        [webVC setImgBlock:^{
            JTLog(@"不做操作");
        }];
        webVC.hidesBottomBarWhenPushed  = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if([self.jumControllerVC isEqualToString:@"JFBigNewEditViewController"]||[self.jumControllerVC isEqualToString:@"JFEditeUsersInformationViewController"]){
        //big_text 直接返回 当前界面  我的界面 w姓名/请登录  退出登录时
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.jumControllerVC isEqualToString:@"JFNewDeatilCardViewController"]){
  
        JFNewDeatilCardViewController *newVC = [[JFNewDeatilCardViewController alloc]init];
        newVC.hidesBottomBarWhenPushed  = YES;
        newVC.title =  self.titleStr;
        newVC.categoryID  =  self.requestStr;
        newVC.cityStr  =self.cityStr;
        newVC.cardModel  = self.cardNewModel;
        newVC.categoryIdx  = [NSString  stringWithFormat:@"%zd",self.catagreIdx];
        newVC.whereVC = @"JFUserLoginViewController";
        [self.navigationController pushViewController:newVC animated:YES];
    }else  if([self.jumControllerVC isEqualToString:@"JFEditeUsersInformationViewController"]){
        JFEditeUsersInformationViewController *settingVC = [[JFEditeUsersInformationViewController  alloc]init];
        settingVC.hidesBottomBarWhenPushed   = YES;
        settingVC.title  =  self.requestStr;
        settingVC.whereVC = @"JFUserLoginViewController";
        [settingVC setImgBlock:^(NSString *imgUrl) {
            [weakSelf.portraintImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"login_img_portrait"]];
        }];
        [self.navigationController pushViewController:settingVC animated:YES];
    }else if([self.jumControllerVC isEqualToString:@"JFSettingUsersViewConntroller"]){
        JFSettingUsersViewConntroller  *editeVC  = [[JFSettingUsersViewConntroller alloc]init];
        editeVC.hidesBottomBarWhenPushed   = YES;
        editeVC.title  =  self.requestStr;
        editeVC.whereVC = @"JFUserLoginViewController";
        [editeVC setMineBlock:^(NSString *name) {
            weakSelf.nameLable.text  = name;
        }];
        [self.navigationController pushViewController:editeVC animated:YES];
    }else if ([self.jumControllerVC isEqualToString:@"JFSuggestUsersViewController"]){
        JFSuggestUsersViewController *suggestVc =  [[JFSuggestUsersViewController  alloc]init];
        suggestVc.title  =  suggestion_me_text;
        suggestVc.whereVC = self.jumControllerVC;
        suggestVc.hidesBottomBarWhenPushed =  YES;
        [self.navigationController  pushViewController:suggestVc animated:YES];
    }
        
}
#pragma mark -  上传日志信息
-(void)uploadLog{
    JFUserInfoTool *user  =[JFUserManager shareManager].currentUserInfo;
    NSString *loginUrl  =[NSString stringWithFormat:@"%@/manager/mgt/user/log",HS_USER_URL];
    NSDictionary *dic  = @{@"userId":user.xuserloginIdStr,@"channelCode":@"prod-ios",@"eventAction":@"login",@"eventValue":@"1"};
    //,@"os":@"ios",@"appName":app_name_type
    NSString *submitUrl =[JFHSUtilsTool conectUrl:[dic mutableCopy] url:loginUrl];
    JTLog(@"%@",submitUrl);
    [PPNetworkHelper setValue:user.loginSuccessKey forHTTPHeaderField:@"API_KEY"];
    [PPNetworkHelper setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    JTLog(@"%@",user.loginSuccessKey);
    [PPNetworkHelper POST:submitUrl parameters:nil success:^(id responseObject) {
         JTLog(@"上传日志=%@",responseObject);
    } failure:^(NSError *error) {
        JTLog(@"%@",error);
    }];
}
-(void)codeBtnEventClick{
    //判断手机号格式是否正确
    
//    [_teleTextFiled.text jk_isMobileNumber]
    
    if (_teleTextFiled.text.length ==11) {
        //格式正确
        //请求 验证码g接口
        NSString *codeStr = [NSString stringWithFormat:@"%@/manager/mgt/msgCode",HS_USER_URL];
        NSDictionary *codeDic =@{@"phoneNumber":_teleTextFiled.text,@"signTemplateId":app_name_type,@"channelCode":@"prod-ios"};
        NSDictionary *userDic=  @{@"os":@"ios",@"appName":app_name_type};
        NSString *url   =[JFHSUtilsTool conectUrl:[userDic  mutableCopy] url:codeStr];
        [PPNetworkHelper GET:url parameters:codeDic success:^(id responseObject) {
            JTLog(@"%@",responseObject);
            if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
                //发送成功
                [self setCountdown];
            }else{
                //错误提示信息
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeMessage"]];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            }
        } failure:^(NSError *error) {
            JTLog(@"%@",error);
        }];
        
    }else{
        //提示用户输入正确的手机格式\
        
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请输入11位的手机号"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }
}
#pragma mark  - 倒计时 60s
-(void)setCountdown{
    __block int timeout = 60; //（秒）倒计时时间
    WEAKSELF;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置 特别注明：UI的改变一定要在主线程中进行
                if (weakSelf.codeBtn!=nil) {
                    [weakSelf.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    weakSelf.codeBtn.userInteractionEnabled = YES;
                }
            });
        }else{
            
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.codeBtn !=nil) {
                    [weakSelf.codeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                    weakSelf.codeBtn.userInteractionEnabled = NO;
                }
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger len = 0;
    if (textField == _teleTextFiled) {
        len = 11;
    }else if (textField == _codeTextFiled){
        len = 4;
    }
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > len && range.length !=1) {
        textField.text = [toBeString substringToIndex:len];
        return NO;
    }
    return YES;
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
