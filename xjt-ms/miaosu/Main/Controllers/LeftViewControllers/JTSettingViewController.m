//
//  JTSettingViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTSettingViewController.h"
#import "JTSettingTableViewCell.h"
#import "JTCPWViewController.h"

@interface JTSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView  *settingTableView;
@property (nonatomic, strong)NSArray *nameArr;
@end

@implementation JTSettingViewController
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
    self.title  = @"设置";
    self.view.backgroundColor =  [UIColor colorWithHexString:@"#F5F5F5"];
    [self settingTableViewUI];
    if (@available(iOS 11.0, *)) {
//        _settingTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
-(void)settingTableViewUI{
    self.settingTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0,0, JT_ScreenW, JT_ScreenH) style:UITableViewStylePlain];
    [self.view addSubview:self.settingTableView];
    self.settingTableView.delegate  = self;
    self.settingTableView.dataSource  = self;
    self.settingTableView.scrollEnabled = NO;
    self.settingTableView.backgroundColor   = [UIColor colorWithHexString:@"#F5F5F5"];
    self.settingTableView.tableFooterView  =[UIView new];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.nameArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 20 *JT_ADAOTER_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47 *JT_ADAOTER_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 160*JT_ADAOTER_WIDTH;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView  =[UIView new];
    headerView.backgroundColor  =[UIColor colorWithHexString:@"#F5F5F5"];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
        
        
        UIView *footerView =[UIView new];
        UIButton *exitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:exitBtn];
        [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [exitBtn setTitleColor:[UIColor colorWithHexString:@"#62A7E9"] forState:UIControlStateNormal];
        exitBtn.backgroundColor =[UIColor whiteColor];
        [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(footerView);
            make.top.equalTo(footerView.mas_top).offset(50 * JT_ADAOTER_WIDTH);
            make.height.mas_equalTo(47 * JT_ADAOTER_WIDTH);
        }];
        [exitBtn addTarget:self action:@selector(exitedBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if (JT_IS_iPhone5) {
            exitBtn.titleLabel.font =  kFontSystem(14);
        }else{
            exitBtn.titleLabel.font =  kFontSystem(16);
        }
        return footerView;
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cellID";
    JTSettingTableViewCell *settingCell= [tableView dequeueReusableCellWithIdentifier:cell];
    if (!settingCell) {
        settingCell =[[JTSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    if (!(indexPath.section == 0 && indexPath.row == 0)) {
        settingCell.rightNameLable.hidden =  YES;
        settingCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
   
    [settingCell getLeftNameStr:self.nameArr[indexPath.row] rightNameStr:[JFHSUtilsTool getCacheSizeWithFilePath:cachesPath]];
    settingCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    return settingCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row==0) {
            //清除缓存
            NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            [JFHSUtilsTool clearCacheWithFilePath:cachesPath];
            //刷新内存
            [self refreshCell];
          
        }else{

            //修改登录密码
            JTCPWViewController *changePW =[[JTCPWViewController alloc]init];
            [self.navigationController pushViewController:changePW animated:YES];
        }
    
}
-(void)refreshCell{
    NSIndexPath *index  =[NSIndexPath indexPathForRow:0 inSection:0];
    JTSettingTableViewCell  *cell =(JTSettingTableViewCell *)[_settingTableView cellForRowAtIndexPath:index];
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    cell.rightNameLable.text  = [JFHSUtilsTool getCacheSizeWithFilePath:cachesPath];
    [_settingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];
}
-(NSArray *)nameArr{
    if (!_nameArr) {
        _nameArr  = @[@"清除缓存",@"修改登录密码"];
    }
    return _nameArr;
}
#pragma mark  -  退出登录
-(void)exitedBtnClick{
    JFUserInfoTool *userInfo  =[JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:userInfo.keyStr]) {
        //在登陆成功之后 才能操作退出
     
    NSString *exitUrl   = [NSString stringWithFormat:@"%@/xjt/user/logout",JT_MS_URL];
     [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:exitUrl withParameter:@{} withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
        JTLog(@"%@",data);
         [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
         //退出成功之后 清空存储本地的数据
            JFUserInfoTool *userInfo = [[JFUserInfoTool alloc]init];
            [JFUserManager shareManager].currentUserInfo   = userInfo;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"退出成功"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
             [[NSNotificationCenter defaultCenter]postNotificationName:@"exitLoginSucessNotice" object:nil];
        }else{
            //错误提示信息
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
}

@end
