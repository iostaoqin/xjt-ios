//
//  JFDeatilInformationNewViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/27.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFDeatilInformationNewViewController.h"
#import "JFCardNewEditTableViewCell.h"
#import "JFDetailInformationNewTableViewCell.h"
#import "JFOtherNewInformationView.h"
#import "JFEditHomeSmallModel.h"
#import "JFEditSucessViewController.h"
@interface JFDeatilInformationNewViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,sureInstitutionsDelegate>
@property (nonatomic, strong)UITableView *informationTB;
@property (nonatomic, strong)NSMutableArray *pickArray;//pickView 选择器数据
@property (nonatomic,  strong)UIView *submitView;
@property (nonatomic, strong)NSMutableArray *detailArray;
@property (nonatomic,  strong)JFOtherNewInformationView *informationView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong)NSString *cityStr;

//创建三个数组 用于y点击 确定 提交的时候
@property (nonatomic, strong)NSMutableArray *firstArray;
@property (nonatomic, strong) NSMutableDictionary *tempDic;
@property (nonatomic, strong)NSMutableArray *orgNameArray;
@property (nonatomic,  strong)NSMutableArray *userArr;
@end

@implementation JFDeatilInformationNewViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor colorWithHexString:@"#F5F5F5"]; self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:kFontSystem(20),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}; self.navigationController.navigationBar.barTintColor=[UIColor colorWithHexString:@"#ffffff"];
    [self addLeftButtonItemWithImage:@"mine_comeBack_img" slected:@"mine_comeBack_img"];
    [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [self getUserInfo];
    //初始化
     self.detailArray = [NSMutableArray array];
    self.firstArray = [NSMutableArray array];
    self.orgNameArray =  [NSMutableArray array];
    self.userArr  = [NSMutableArray array];
    self.tempDic = [NSMutableDictionary dictionary];
    
    
    [self setupTB];
  
}
-(void)setupTB{
    _informationTB  = [[UITableView alloc]initWithFrame:CGRectMake(0, JT_NAV, JT_ScreenW, JT_ScreenH  -  JT_NAV) style:UITableViewStylePlain];
    [self.view addSubview:_informationTB];
   
    _informationTB.delegate  = self;
    _informationTB.dataSource  = self;
    _informationTB.tableFooterView  = [UIView new];
    _informationTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    _informationTB.backgroundColor  = [UIColor clearColor];
}
#pragma mark - 获取用户信息
-(void)getUserInfo{
    WEAKSELF;
    NSString *infoUrl  =[NSString stringWithFormat:@"%@/manager/bnh/user",HS_USER_URL];
    NSDictionary *dic  = @{@"detail":@"ture"};
    NSDictionary *userDic=  @{@"os":@"ios",@"appName":app_name_type};
    NSString *url   =[JFHSUtilsTool conectUrl:[userDic  mutableCopy] url:infoUrl];
    
    [PPNetworkHelper setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    JFUserInfoTool  *user  = [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:user.loginSuccessKey]) {
        [PPNetworkHelper setValue:user.loginSuccessKey forHTTPHeaderField:@"API_KEY"];
    }
    [PPNetworkHelper GET:url parameters:dic success:^(id responseObject) {
        JTLog(@"%@",responseObject);
           [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            [self.userArr removeAllObjects];
            for (NSDictionary *userInfDic  in responseObject[@"user"][@"userPropertys"]) {
                JFEditHomemodel *userModel =[JFEditHomemodel mj_objectWithKeyValues:userInfDic];
                //替换城市的名称
                if (![JFHSUtilsTool isBlankString:userModel.name]) {
                    if ([userModel.name isEqualToString:@"city"]) {
                        [self.firstDetailArray replaceObjectAtIndex:3 withObject:userModel.value];
                    }
                }
               
                [self.userArr addObject:userModel];
            }
            [self  getDeatilData];
        }
    } failure:^(NSError *error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        JTLog(@"%@",error);
    }];
}
#pragma mark  - 请求详细数据
-(void)getDeatilData{
    WEAKSELF;
    NSMutableArray *firstTampArray = [NSMutableArray array];
    NSMutableArray *secondArray = [NSMutableArray array];
    NSMutableArray *thirdArray = [NSMutableArray array];
    NSString  *detail_url = [NSString stringWithFormat:@"%@/manager/bnh/loanFields",HS_USER_URL];
    
    NSDictionary *detaulDic = @{@"os":@"ios",@"appName":app_name_type};
    NSString *url   =[JFHSUtilsTool conectUrl:[detaulDic  mutableCopy] url:detail_url];
    [PPNetworkHelper GET:url parameters:@{} success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //数据请求成功
            for (NSDictionary *dic in responseObject[@"largeLoanFields"]) {
                // area 1  area 2 area 3
                if ([[NSString stringWithFormat:@"%@",dic[@"area"]]isEqualToString:@"1"]) {
                    JFEditHomeDetailModel *firstModel  = [JFEditHomeDetailModel mj_objectWithKeyValues:dic];
                    [firstTampArray addObject:firstModel];
                    self.firstArray  = firstTampArray;
                    //把所在城市 加上
//                    if ([firstModel.desc isEqualToString:@"所在城市"]) {
//
//                    }
                }else{
                    
                    //
                    
                    
                    
                    
                    if ([[NSString stringWithFormat:@"%@",dic[@"area"]]isEqualToString:@"2"]){
                    JFEditHomeDetailModel *firstModel  = [JFEditHomeDetailModel mj_objectWithKeyValues:dic];
                    [secondArray addObject:firstModel];
                    
                }else{
                    JFEditHomeDetailModel *firstModel  = [JFEditHomeDetailModel mj_objectWithKeyValues:dic];
                    [thirdArray addObject:firstModel];
                    
                }
            }
            }
           
        
            
            
            
            
            [weakSelf.detailArray insertObject:firstTampArray atIndex:0];
            [weakSelf.detailArray insertObject:secondArray atIndex:1];
            [weakSelf.detailArray insertObject:thirdArray atIndex:2];
            
            [weakSelf.informationTB reloadData];
            //创建footer
              [self setFooterUI];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)setFooterUI{

    UIView *footerView  = [UIView new];
    footerView.backgroundColor  =[UIColor colorWithHexString:@"#F5F5F5"];
    footerView.frame = CGRectMake(0, 0, JT_ScreenW, 180 * JT_ADAOTER_WIDTH);
    _informationTB.tableFooterView = footerView;
    UILabel *nameLable   = [UILabel new];
    [footerView addSubview:nameLable];
    nameLable.textColor = [UIColor colorWithHexString:@"#999999"];
    nameLable.font  = kFontSystem(14);
    nameLable.numberOfLines =   0;
    NSString *str = @"请确认以上信息填写无误，提交申请后我们将为您推荐适合您的合作机构";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0; // 设置行间距
    paragraphStyle.alignment = NSTextAlignmentCenter; //设置两端对齐显示
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    nameLable.attributedText = attributedStr;
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(22  * JT_ADAOTER_WIDTH);
        make.left.equalTo(footerView.mas_left).offset(48  * JT_ADAOTER_WIDTH);
        make.centerX.equalTo(footerView);
    }];
     UIButton *applayBtn =[footerView buttonCreateWithNorStr:immediatelyApply_tips_text nomalBgColor:@"#FF4D4F" textFont:18 cornerRadius:23];
    [footerView addSubview:applayBtn];
    [applayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLable.mas_bottom).offset(20*JT_ADAOTER_WIDTH);
        make.size.mas_offset(CGSizeMake(343 * JT_ADAOTER_WIDTH, 46 * JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self.view);
    }];
    footerView.userInteractionEnabled =  YES;
    [applayBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==  0) {
        return 0;
    }else{
        return 10;
    }
  
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section !=0) {
        UIView *view = [UIView new];
        view.backgroundColor  = [UIColor colorWithHexString:@"#F5F5F5"];
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48*JT_ADAOTER_WIDTH;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section  == 0) {
        if (self.firstArray.count) {
            return [self.firstArray  count] -2;
        }return 0;
    }else if (section == 1){
        if (self.detailArray.count) {
            return [self.detailArray[1]count];
        }return 0;
    }else{
        if (self.detailArray.count) {
            return [self.detailArray[2]count];
        }return 0;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  == 0) {
        static NSString *firstCell  = @"JFCardNewEditTableViewCell";
        JFCardNewEditTableViewCell *firstInformationCell  = [tableView dequeueReusableCellWithIdentifier:firstCell];
        if (!firstInformationCell) {
            firstInformationCell =[[JFCardNewEditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCell];
        }
        [self.firstArray enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //身份证和 姓名去掉
            JFEditHomeDetailModel *firstModel =self.firstArray[idx];
            if ([firstModel.fieldName isEqualToString:@"username"] || [firstModel.fieldName isEqualToString:@"idcard"]) {
                [self.firstArray removeObjectAtIndex:idx];
            }
            if ([firstModel.type isEqualToString:@"1"]) {
                //注册通知
                
                [[NSNotificationCenter defaultCenter]
                 addObserver:self
                 selector:@selector(textFieldTextDidChangeValue:)
                 name:UITextFieldTextDidChangeNotification
                 object:firstInformationCell.nameTextFiled];
            }
        }];
        firstInformationCell.nameTextFiled.delegate  = self;
        [firstInformationCell getNameModel:self.firstArray[indexPath.row] detailTextStr:self.firstDetailArray[indexPath.row]];
       
        
        if (indexPath.row  == [self.firstArray count]-1) {
            firstInformationCell.lineLable.hidden =  YES;
        }
        firstInformationCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return firstInformationCell;
    }else{
        static NSString *secondCell  = @"JFDetailInformationNewTableViewCell";
        JFDetailInformationNewTableViewCell *secondInformationCell  = [tableView dequeueReusableCellWithIdentifier:secondCell];
        if (!secondInformationCell) {
            secondInformationCell =[[JFDetailInformationNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondCell];
        }
     
        secondInformationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section >=1) {
       
            JFEditHomeDetailModel *detailModel =self.detailArray[indexPath.section][indexPath.row];
            [secondInformationCell getNameData:detailModel userInfoArr:self.userArr];
            for (JFEditHomemodel *model in self.userArr) {
                if ([model.name isEqualToString:detailModel.fieldName]) {
                    JTLog(@"%@",model.value);
                    [self setSecondFieldName:detailModel.fieldName secondFiledValue:model.value selected:1];
                }
            }
        }
        if (indexPath.row  == [self.detailArray[1] count]-1 ||indexPath.row  == [self.detailArray[2] count]-1) {
            secondInformationCell.lineLable.hidden  = YES;
        }
        secondInformationCell.nameTextFiled.delegate  = self;
        secondInformationCell.nameTextFiled.tag  = indexPath.row;
        secondInformationCell.nameTextFiled.enabled  = NO;
        secondInformationCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return secondInformationCell;
        
    }

}
#pragma mark  - tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section >=1) {
        // area 2  area 3 操作选择
        WEAKSELF;
        self.pickArray =[NSMutableArray array];
        JFDetailInformationNewTableViewCell *cell  = (JFDetailInformationNewTableViewCell *)[_informationTB cellForRowAtIndexPath:indexPath];
        JFEditHomeDetailModel *selectedModel  = self.detailArray[indexPath.section][indexPath.row];
        [[selectedModel.largeLoanFieldValues mutableCopy] enumerateObjectsUsingBlock:^(NSDictionary *selectedDic, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![JFHSUtilsTool isBlankString:selectedDic[@"desc"]]) {
                //空 字符串  过滤
                NSString *str = [selectedDic[@"fieldValue"]mutableCopy];
                [weakSelf.pickArray addObject:str];
            }
            
        }];
        
        [BRStringPickerView showStringPickerWithTitle:cell.nameLable.text dataSource:self.pickArray defaultSelValue:@"" resultBlock:^(id selectValue) {
            cell.nameTextFiled.text  = selectValue;
            
             [weakSelf setSecondFieldName:selectedModel.fieldName     secondFiledValue:selectValue selected:indexPath.row];
            
        }];
    }
}
-(void)setSecondFieldName:(NSString  *)name secondFiledValue:(NSString  *)value selected:(NSInteger)idx{
     [_tempDic setValue:value forKey:name];
}
#pragma mark  - 注册通知 检测用户的修改
-(void)textFieldTextDidChangeValue:(NSNotification *)notice{
    UITextField *textField  =  (UITextField *)notice.object;
    for (JFEditHomeDetailModel *firstModel  in self.detailArray[0]) {
        //代表可以编辑
        if ([firstModel.desc isEqualToString:@"所在城市"]) {
            [self.firstDetailArray replaceObjectAtIndex:3 withObject:textField.text];
        }
    }
}
#pragma mark - 立即申请
-(void)applyBtnClick:(UIButton *)btn{
    JTLog(@"立即申请   = %@",_tempDic);
    WEAKSELF;
    //判断用户是否填写 了城市
    if ([JFHSUtilsTool isBlankString:self.firstDetailArray[3]]) {
        //没有填写城市
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请填写城市"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        return;
    }else{
    //申请金额 期限  年龄  所在城市  职业   姓名 身份证号码
    for (int i =0 ; i  < self.firstDetailArray.count - 2; i ++) {
        //找到对应的key 值
        JFEditHomeDetailModel *firstModel = self.firstArray[i];
        [_tempDic setValue:self.firstDetailArray[i] forKey:firstModel.fieldName];
    }
    //再加上姓名和身份证
    [_tempDic setValue:self.firstDetailArray[self.firstDetailArray.count  - 2] forKey:@"username"];
     [_tempDic setValue:self.firstDetailArray[self.firstDetailArray.count  - 1] forKey:@"idcard"];
     [_tempDic setValue:@"ios" forKey:@"os"];
     [_tempDic setValue:@"appName" forKey:app_name_type];
    
    //带星号的是必填的
    for (JFEditHomeDetailModel *secondModel in self.detailArray[1]) {
        //
        if ([JFHSUtilsTool isBlankString:_tempDic[secondModel.fieldName]]) {
            //提示用户
          [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:[NSString stringWithFormat:@"请填写%@",secondModel.desc]];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            return;
        }
    }
    if (_tempDic.count >= self.firstDetailArray.count + [self.detailArray[1]count]) {
        //说明至少第一个cell和第二个cell  数据填满
        //提交数据
        NSString *submitUrl  = [NSString stringWithFormat:@"%@/manager/bnh/largeLoan",HS_USER_URL];
        JTLog(@"%@",_tempDic);
        [JFHttpsToolEdit requestType:@"POST" putWithUrl:submitUrl withParameter:_tempDic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
            JTLog(@"%@",data);
             [self.orgNameArray removeAllObjects];
            if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                //数据请求成功
                
                for (NSDictionary *orgNameDic in data[@"largeLoanOrgs"]) {
                    JFEditHomeSmallModel *orgModel =[JFEditHomeSmallModel mj_objectWithKeyValues:orgNameDic];
                    if (weakSelf.count < 4) {
                        
                        orgModel.option = YES;
                    }else{
                         orgModel.option = NO;
                    }
                    weakSelf.count ++;
                    [self.orgNameArray addObject:orgModel];
                   
                }
                //创建弹框
                [self setBouncedUI];
            }
        } withErrorCodeTwo:^{
            
        } withErrorBlock:^(NSError * _Nonnull error) {
            
        }];
        //立即申请提交神策数据
        NSDictionary  *dic = @{@"page_no":@"2",@"btn_id":@"1001",@"btn_name":btn.titleLabel.text};
        [[SensorsAnalyticsSDK sharedInstance]track:@"LargeLoanClick" withProperties:dic];
    }
    }
   
}
#pragma mark - 弹框
-(void)setBouncedUI{
        WEAKSELF;
        _submitView  = [[UIView alloc]initWithFrame:self.view.bounds];
        _submitView.backgroundColor =[UIColor blackColor];
        _submitView.alpha = 0.4;
        [[UIApplication sharedApplication].keyWindow  addSubview:_submitView];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(submitGesture)];
        [_submitView addGestureRecognizer:gesture];
        _informationView  =[JFOtherNewInformationView new];
         [[UIApplication sharedApplication].keyWindow  addSubview:_informationView];
        _informationView.backgroundColor =[UIColor whiteColor];
        _informationView.layer.cornerRadius = 10;
        _informationView.layer.masksToBounds  = YES;
        _informationView.delegate =self;
        [_informationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(JT_ScreenW - 80 * JT_ADAOTER_WIDTH, 400  * JT_ADAOTER_WIDTH));
            make.left.equalTo(weakSelf.submitView.mas_left).offset(40 * JT_ADAOTER_WIDTH);
            make.centerY.equalTo(weakSelf.submitView);
        }];
    [_informationView getBoundsData:self.orgNameArray];
}
-(void)submitGesture{
    [_submitView removeFromSuperview];
    [_informationView removeFromSuperview];
}
#pragma mark -选择机构之后确定
-(void)sureEventClick:(NSMutableArray *)endSelectedArray{
    if (!endSelectedArray.count) {
        //提示用户
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"请选择组织机构"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }else{
        NSMutableArray *tempArr =  [NSMutableArray array];
        NSMutableArray *nameTemArr =  [NSMutableArray array];
        for (JFEditHomeSmallModel *mdoel in endSelectedArray) {
            [tempArr addObject:mdoel.orgId];
            [nameTemArr addObject:mdoel.orgName];
        }
        NSString  *orgUrl = [NSString stringWithFormat:@"%@/manager/bnh/largeLoanOrgs",HS_USER_URL];
        NSDictionary  *dic =@{@"orgIds":tempArr};
        NSDictionary *userDic=  @{@"os":@"ios",@"appName":app_name_type};
        NSString *url   =[JFHSUtilsTool conectUrl:[userDic  mutableCopy] url:orgUrl];
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"正在申请..."];
        [JFHttpsToolEdit requestType:@"POST" putWithUrl:url withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
            JTLog(@"%@",data);
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"申请成功"];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //提交成功 弹出 界面
                    [self submitGesture];
                    JFEditSucessViewController  *sucessVC = [[JFEditSucessViewController alloc]init];
                    sucessVC.dataArr  = @[self.firstDetailArray[0],self.firstDetailArray[1]];
                    [self.navigationController pushViewController:sucessVC animated:YES];
              
                });
                //提交申请成功日志
                [self submitApplySuccessLog];
            }
        } withErrorCodeTwo:^{
            
        } withErrorBlock:^(NSError * _Nonnull error) {
            
        }];
        //提交神策数据
        
        NSString *orgIdStr = [self jsonArrToNsstring:tempArr];
        NSString *nameStr  = [self jsonArrToNsstring:nameTemArr];
        NSDictionary *submitDic =  @{@"page_no":@"3",@"btn_id":@"1003",@"btn_name":@"确定",@"org_ids":orgIdStr,@"org_orgin_ids":nameStr};
        [[SensorsAnalyticsSDK sharedInstance]track:@"LargeLoanClick" withProperties:submitDic];
    }
    
    
    
}
-(NSString *)jsonArrToNsstring:(NSArray *)arr{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:&error];
    NSString *orgIdStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return orgIdStr;
}
#pragma mark -全选事件
-(void)selectedAllEventClick:(UIButton *)btn{
    btn.selected = !btn.selected;
}
-(void)leftBarButtonItemEvent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitApplySuccessLog{
    [JFSHLogEditTool logRequestCookId:@"" eventTagName:@"" eventAction:@"" firstEventValue:@"" secondEventValue:@"" showType:LogShowType_BigApplySuccess];
}
@end
