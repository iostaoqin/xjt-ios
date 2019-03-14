//
//  JFSettingUsersViewConntroller.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFSettingUsersViewConntroller.h"
#import "JFCardNewEditTableViewCell.h"
@interface JFSettingUsersViewConntroller ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *settingTableView;
@property (nonatomic, strong)NSArray *nameArray;
@property (nonatomic, strong)NSArray *pickArray;
@property (nonatomic,  strong)NSMutableArray *editArr;
@property (nonatomic,  strong)NSArray *placeArr;
@end
@implementation JFSettingUsersViewConntroller
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor colorWithHexString:@"#F5F5F5"];
    _nameArray = @[@"手机号",@"姓名",@"身份证号码",@"职业信息"];
    JFUserInfoTool *userInfo = [JFUserManager shareManager].currentUserInfo;
    NSArray *temArr = @[[JFHSUtilsTool isBlankString:userInfo.xteleNumberStr]?@"":[userInfo.xteleNumberStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"],[JFHSUtilsTool isBlankString:userInfo.nameStr]?@"":userInfo.nameStr, [JFHSUtilsTool isBlankString:userInfo.identityStr]?@"":userInfo.identityStr,[JFHSUtilsTool isBlankString:userInfo.professionalStr]?@"":userInfo.professionalStr];
    self.editArr   = [temArr mutableCopy];
    self.placeArr = @[@"",@"请填写",@"请填写",@"请选择"];
     [self addLeftButtonItemWithImage:@"mine_comeBack_img" slected:@"mine_comeBack_img"];
    [self tableViewUI];
    
}
-(void)leftBarButtonItemEvent:(id)sender{
    if ([self.whereVC isEqualToString:@"JFUserLoginViewController"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)tableViewUI{
    WEAKSELF;
    _settingTableView  =[[UITableView  alloc]initWithFrame:CGRectMake(0, JT_NAV, JT_ScreenW, 230) style:UITableViewStyleGrouped];
    [self.view addSubview:_settingTableView];
    _settingTableView.delegate = self;
    _settingTableView.dataSource  = self;
    _settingTableView.scrollEnabled  = NO;
    _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _settingTableView.backgroundColor  =[UIColor clearColor];
    UIButton *submitBtn  = [self.view buttonCreateWithNorStr:@"提交" nomalBgColor:@"#FF4D4F" textFont:18 cornerRadius:23];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343  *  JT_ADAOTER_WIDTH, 46 * JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self.view);
        make.top.equalTo(weakSelf.settingTableView.mas_bottom).offset(36 * JT_ADAOTER_WIDTH);
    }];
    [submitBtn addTarget:self action:@selector(submitDataEvent) forControlEvents:UIControlEventTouchUpInside];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nameArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *setting  = @"cell";
    JFCardNewEditTableViewCell *cell  =  [tableView dequeueReusableCellWithIdentifier:setting];
    if (!cell) {
        cell  =[[JFCardNewEditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setting];
    }
       JFUserInfoTool *userInfo = [JFUserManager shareManager].currentUserInfo;
    if (indexPath.row  == 0) {
        
        
       cell.nameTextFiled.enabled = [JFHSUtilsTool isBlankString:userInfo.xteleNumberStr]?YES:NO;
    }
    
    if (indexPath.row  == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.nameTextFiled.enabled  =  NO;
        cell.nameTextFiled.placeholder = [JFHSUtilsTool isBlankString:userInfo.professionalStr]?@"请选择":@"";
    }
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    [cell getNameText:_nameArray[indexPath.row]
        detailTextStr:_editArr[indexPath.row]placeTitle:self.placeArr[indexPath.row]];
    cell.nameTextFiled.delegate  = self;
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  == 3) {
        NSIndexPath *index =  [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        JFCardNewEditTableViewCell  *cardCell = (JFCardNewEditTableViewCell *)[_settingTableView cellForRowAtIndexPath:index];
            [BRStringPickerView showStringPickerWithTitle:cardCell.nameLable.text dataSource:self.pickArray defaultSelValue:@"" resultBlock:^(id selectValue) {
                cardCell.nameTextFiled.text  = selectValue;
            }];
        
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark  -  提交编辑资料
-(void)submitDataEvent{
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    NSIndexPath *teleIndex = [NSIndexPath indexPathForRow:0 inSection:0];
     NSIndexPath *nameIndex = [NSIndexPath indexPathForRow:1 inSection:0];
     NSIndexPath *indentityIndex = [NSIndexPath indexPathForRow:2 inSection:0];
     NSIndexPath *professionalIndex = [NSIndexPath indexPathForRow:3 inSection:0];
    
    JFCardNewEditTableViewCell  *teleCell = (JFCardNewEditTableViewCell *)[_settingTableView  cellForRowAtIndexPath:teleIndex];
      JFCardNewEditTableViewCell  *nameCell = (JFCardNewEditTableViewCell *)[_settingTableView  cellForRowAtIndexPath:nameIndex];
      JFCardNewEditTableViewCell  *indentityCell = (JFCardNewEditTableViewCell *)[_settingTableView  cellForRowAtIndexPath:indentityIndex];
      JFCardNewEditTableViewCell  *professionalCell = (JFCardNewEditTableViewCell *)[_settingTableView  cellForRowAtIndexPath:professionalIndex];
    //回收键盘
    [teleCell.nameTextFiled resignFirstResponder];
    [nameCell.nameTextFiled resignFirstResponder];
    [indentityCell.nameTextFiled resignFirstResponder];
    //判断用户 是否 填写全 信息
    if ([JFHSUtilsTool isBlankString:teleCell.nameTextFiled.text]||[JFHSUtilsTool isBlankString:nameCell.nameTextFiled.text]||[JFHSUtilsTool isBlankString:indentityCell.nameTextFiled.text]||[JFHSUtilsTool isBlankString:professionalCell.nameTextFiled.text]) {
        NSString *msg;
        msg = [JFHSUtilsTool isBlankString:teleCell.nameTextFiled.text]?[NSString stringWithFormat:@"%@%@",teleCell.nameTextFiled.placeholder,teleCell.nameLable.text]:[JFHSUtilsTool isBlankString:nameCell.nameTextFiled.text]?[NSString stringWithFormat:@"%@%@",nameCell.nameTextFiled.placeholder,nameCell.nameLable.text]:[JFHSUtilsTool isBlankString:indentityCell.nameTextFiled.text]?[NSString stringWithFormat:@"%@%@",indentityCell.nameTextFiled.placeholder,indentityCell.nameLable.text]:[JFHSUtilsTool isBlankString:professionalCell.nameTextFiled.text]?[NSString stringWithFormat:@"%@%@",professionalCell.nameTextFiled.placeholder,professionalCell.nameLable.text]:@"";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:msg];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
        //判断手机号是否正确
        //1 如果一进入界面就有手机号就不用判断格式了
        if ([JFHSUtilsTool isBlankString:userInfo.xteleNumberStr]) {
            //为空 判断手机号
            if ([teleCell.nameTextFiled.text jk_isMobileNumber]) {
                //判断身份证
                [self submitData:teleCell.nameTextFiled.text nameStr:nameCell.nameTextFiled.text identityStr:indentityCell.nameTextFiled.text professionalStr:professionalCell.nameTextFiled.text];
            }else{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请输入11位手机号"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                
            }
            
        }else{
            //直接判断身份证
            [self submitData:userInfo.xteleNumberStr nameStr:nameCell.nameTextFiled.text identityStr:indentityCell.nameTextFiled.text professionalStr:professionalCell.nameTextFiled.text];
        }
        
    }
}
-(void)submitData:(NSString *)xteleNumberStr nameStr:(NSString *)name identityStr:(NSString *)identity professionalStr:(NSString *)professional{
     JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    //判断身份证格式是否正确
    if ([NSString jk_accurateVerifyIDCardNumber:identity]) {
        //提交申请接口
        NSString *submit_url  = [NSString stringWithFormat:@"%@/manager/bnh/userInfo",HS_USER_URL];
        NSDictionary *userDic=  @{@"os":@"ios",@"appName":app_name_type};
        NSString *url   =[JFHSUtilsTool conectUrl:[userDic  mutableCopy] url:submit_url];
        NSDictionary *dic = @{@"username":name,@"idcard":identity,@"occupation":professional};
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"正在提交申请..."];
        
        [JFHttpsToolEdit requestType:@"PUT" putWithUrl:url withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
            JTLog(@"%@",data);
            if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            //保存相关信息
            userInfo.xteleNumberStr   = xteleNumberStr;
            userInfo.nameStr  = name;
            userInfo.professionalStr  = professional;
            userInfo.identityStr  =  identity;
            [JFUserManager shareManager].currentUserInfo =  userInfo;
            self.mineBlock(name);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"提交成功"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            });
            //发送 通知给我的界面修改相关信息
            [[NSNotificationCenter defaultCenter]postNotificationName:@"settingSucessNotice" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //返回 上一页
                if ([self.whereVC isEqualToString:@"JFUserLoginViewController"]) {
                     [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                   [self.navigationController popViewControllerAnimated:YES];
                }
               
            });
            }
        } withErrorCodeTwo:^{
             [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        } withErrorBlock:^(NSError * _Nonnull error) {
             [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        }];
        
    }else{
        //身份证格式错误
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"身份证格式错误,请重填写"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }
}
-(NSArray *)pickArray{
    if (!_pickArray) {
        _pickArray  = @[@"工薪族",@"企业主",@"自由职业者"];
    }
    return _pickArray;
}
@end
