//
//  JTBaseInformationViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseInformationViewController.h"
#import "JTFirstInformationTableViewCell.h"
#import "JTSecondInformationTableViewCell.h"
@interface JTBaseInformationViewController ()<UITableViewDelegate,UITableViewDataSource,secondInformationDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate,ProvincesDelegate>
@property (nonatomic, strong)UITableView *informationTB;
@property (nonatomic, strong)NSArray *placeArr;
@property (nonatomic, strong)NSArray *secondNameArr;
@property (nonatomic,assign)NSInteger  selectedBtnTag;
@end

@implementation JTBaseInformationViewController
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
    self.title = @"基本信息认证";
    [self informationTBUI];
    if ([self.xyAction isEqualToString:@"xyAction"]) {
    
    }else{
        if (@available(iOS 11.0, *)) {
            _informationTB.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
   
}
-(void)informationTBUI{
    _informationTB  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH-kTabBarHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:_informationTB];
    _informationTB.dataSource = self;
    _informationTB.delegate =self;
    //  支持自适应 cell
    _informationTB.estimatedRowHeight = 50;
    _informationTB.rowHeight = UITableViewAutomaticDimension;
    _informationTB.separatorStyle=  UITableViewCellSeparatorStyleNone;
    _informationTB.tableFooterView =[UIView new];
    _informationTB.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section  ==0) {
        return 2;
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section  == 2) {
        return 80;
    }return 0.00001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section  ==0) {
        UIView *headerView  =[UIView new];
        headerView.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
        UILabel *nameLable =[UILabel new];
        [headerView addSubview:nameLable];
        nameLable.text = @"填写您的真实信息，详情信息可加快审核";
        if (JT_IS_iPhone5) {
          nameLable.font = kFontSystem(12);
        }else{
            nameLable.font = kFontSystem(14);
        }
        nameLable.textColor  =[UIColor colorWithHexString:@"#999999"];
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerView);
        }];
        return headerView;
    }else{
        UIView *otherHeaderView  =[UIView new];
        otherHeaderView.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
        return otherHeaderView;
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section  ==2) {
    UIView *footerView =[UIView new];
    CGFloat registFont;
    if (JT_IS_iPhone5) {
        registFont  = 16;
    }else{
        registFont  = 18;
    }
    
    UIButton *changePWBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:343* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"01D3C7"];
    [changePWBtn setTitle:@"提交资料" forState:UIControlStateNormal];
    changePWBtn.titleLabel.font = kFontSystem(registFont);
    [footerView addSubview:changePWBtn];
    [changePWBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343 *JT_ADAOTER_WIDTH,  46 *JT_ADAOTER_WIDTH));
        make.centerX.equalTo(footerView);
        make.top.equalTo(footerView.mas_top).offset(16*JT_ADAOTER_WIDTH);
    }];
    [changePWBtn addTarget:self action:@selector(submitDataClick) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
    }return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
    static NSString *cell  = @"JTFirstInformationTableViewCell";
    JTFirstInformationTableViewCell *informationCell =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!informationCell) {
        informationCell =[[JTFirstInformationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
        
    if (indexPath.row == 0) {
        
        informationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        informationCell.addressTextView.editable  = NO;
        informationCell.delegate  = self;
    }else{
        informationCell.nameLable.hidden = YES;
    }
       
        informationCell.selectionStyle  =UITableViewCellSelectionStyleNone;
    [informationCell getInformationPlaceHolder:self.placeArr[indexPath.row]indx:indexPath.row];
    return informationCell;
    }else{
        static NSString *cell  = @"JTSecondInformationTableViewCell";
        JTSecondInformationTableViewCell *informationSecondCell =[tableView dequeueReusableCellWithIdentifier:cell];
        if (!informationSecondCell) {
            informationSecondCell =[[JTSecondInformationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        }
        [informationSecondCell getLeftNameStr:self.secondNameArr[indexPath.section][indexPath.row] nameIdx:indexPath.row];
        if (indexPath.row   == [self.secondNameArr[indexPath.section] count]-1) {
            informationSecondCell.lineLable.hidden =  YES;
        }
        informationSecondCell.selectedBtn.tag  = 1000 +indexPath.section;
        informationSecondCell.selectionStyle = UITableViewCellSelectionStyleNone;
        informationSecondCell.informationDelegate = self;
        return informationSecondCell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section  !=0) {
        //
        if ((indexPath.row  ==1 && indexPath.section  ==1)) {
            JTSecondInformationTableViewCell *secondCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:indexPath];
            [BRStringPickerView showStringPickerWithTitle:secondCell.addressTextField.text dataSource:@[@"父亲", @"母亲", @"配偶",@"儿子",@"女儿"] defaultSelValue:@"" resultBlock:^(id selectValue) {
                secondCell.addressTextField.text  = selectValue;
            }];
        }
        if ((indexPath.row  ==1 && indexPath.section  ==2)) {
            JTSecondInformationTableViewCell *secondCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:indexPath];
            [BRStringPickerView showStringPickerWithTitle:secondCell.addressTextField.text dataSource:@[@"同学", @"朋友", @"同事",@"亲戚",@"兄弟",@"姐妹",@"其他"] defaultSelValue:@"" resultBlock:^(id selectValue) {
                secondCell.addressTextField.text  = selectValue;
            }];
        }
        
        
    }
}
#pragma mark  - 选择省市区
-(void)ProvincesBtnItemEvent{
    NSIndexPath   *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath   *addressPath =[NSIndexPath indexPathForRow:1 inSection:0];
    JTFirstInformationTableViewCell *cell =(JTFirstInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:indexPath];
    JTFirstInformationTableViewCell *addresscell =(JTFirstInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:addressPath];
    [addresscell.addressTextView resignFirstResponder];
    // 点击选择省市区
    NSArray *defaultSelArr = [cell.addressTextView.text componentsSeparatedByString:@" "];
    NSArray *dataSource = nil;
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:dataSource defaultSelected:defaultSelArr isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        [[cell.addressTextView viewWithTag:999]setAlpha:0];
        cell.addressTextView.text  =[NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
        
    } cancelBlock:^{
        
    }];
}
#pragma mark  -  提交资料事件
-(void)submitDataClick{
   //地址
    NSIndexPath *addressIdx  =[NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *addressDetailIdx  =[NSIndexPath indexPathForRow:1 inSection:0];
    JTFirstInformationTableViewCell *addressCell =(JTFirstInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:addressIdx];
    JTFirstInformationTableViewCell *addressDetailCell =(JTFirstInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:addressDetailIdx];
    // 紧急联系人1
    NSIndexPath *relationshipIdx  =[NSIndexPath indexPathForRow:1 inSection:1];
     NSIndexPath *nameSecondIdx  =[NSIndexPath indexPathForRow:2 inSection:1];
    NSIndexPath *nameIdx  =[NSIndexPath indexPathForRow:3 inSection:1];
    JTSecondInformationTableViewCell *relationshipCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:relationshipIdx];
    JTSecondInformationTableViewCell *nameCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:nameIdx];
     JTSecondInformationTableViewCell *nameOtherCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:nameSecondIdx];
    
    // 紧急联系人2
    NSIndexPath *relationshipSIdx  =[NSIndexPath indexPathForRow:1 inSection:2];
     NSIndexPath *nameSecondOtherIdx  =[NSIndexPath indexPathForRow:2 inSection:2];
    NSIndexPath *nameSecondTeleIdx  =[NSIndexPath indexPathForRow:3 inSection:2];
    JTSecondInformationTableViewCell *relationshipSCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:relationshipSIdx];
    JTSecondInformationTableViewCell *nameSCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:nameSecondTeleIdx];
    JTSecondInformationTableViewCell *nameSOtherCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:nameSecondOtherIdx];
    
    //判断用户是否全部选择完
    if ([JFHSUtilsTool isBlankString:addressCell.addressTextView.text]||[JFHSUtilsTool isBlankString:addressDetailCell.addressTextView.text]||[JFHSUtilsTool isBlankString:relationshipCell.addressTextField.text]||[JFHSUtilsTool isBlankString:nameCell.teleLable.text]||[JFHSUtilsTool isBlankString:relationshipSCell.addressTextField.text]||[JFHSUtilsTool isBlankString:nameSCell.teleLable.text]) {
        NSString *msg;
        msg = [JFHSUtilsTool isBlankString:addressCell.addressTextView.text]?addressCell.placeLable.text:[JFHSUtilsTool isBlankString:addressDetailCell.addressTextView.text]?addressDetailCell.placeLable.text:[JFHSUtilsTool isBlankString:relationshipCell.addressTextField.text]?relationshipCell.addressTextField.placeholder:[JFHSUtilsTool isBlankString:nameCell.teleLable.text]?@"请选择紧急联系人1":[JFHSUtilsTool isBlankString:relationshipSCell.addressTextField.text]?relationshipSCell.addressTextField.placeholder:[JFHSUtilsTool isBlankString:nameSCell.teleLable.text]?@"请选择紧急联系人2":@"";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:msg];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }else{
        //判断用户填写的详细地址是否少于5个字
        if ([addressDetailCell.addressTextView.text length] <5) {
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"详细地址不少于5个字"];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        }else{
        //判断用户选择的手机号h是否合格 先去空格
             NSString *firstTele = [[nameCell.teleLable.text  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
             NSString *secondTele =[[nameSCell.teleLable.text  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
        if (![JFHSUtilsTool isValidateMobile:firstTele]||![JFHSUtilsTool isValidateMobile:secondTele]) {
            //提示用户 手机号不能为座机号
            [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"手机号不能是座机号或者公司电话,请填写有效手机号"];
            [[JFHudMsgTool  shareHusMsg]hiddenHud:MBProgressHUDModeText];
        }else{
            //请求接口
            //省市区  去掉空格
            NSString *privoce =[addressCell.addressTextView.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
            //合并地址
            NSString *addressStr  =[NSString stringWithFormat:@"%@%@",privoce,addressDetailCell.addressTextView.text];
            NSDictionary *dic=  @{@"liveAddress":addressStr,@"contract1Relation":relationshipCell.addressTextField.text,@"contract1Username":nameOtherCell.teleLable.text,@"contract1Phonenumber":firstTele,@"contract2Relation":relationshipSCell.addressTextField.text,@"contract2Username":nameSOtherCell.teleLable.text,@"contract2Phonenumber":secondTele};
            NSString *url  =[NSString stringWithFormat:@"%@/xjt/user/baseInfo",JT_MS_URL];
            JTLog(@"%@",dic);
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
            [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:url withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                JTLog(@"%@",data);
                if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"基本信息认证成功"];
                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                 //发送通知到认证中心改变多少项认证成功
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"certificateBasicInfoNoticeSucess" object:nil];
                }else{
                    //错误提示信息
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
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
        
    }
    
}
#pragma mark - 选择联系人事件
-(void)selectedConnectEventClick:(UIButton *)btn{
    self.selectedBtnTag  = btn.tag  -1000;
    if (IOS_VERSION_9_OR_AFTER) {//ios 9 之后
        NSLog(@"ios9以后");
        [JFHSUtilsTool checkAddressBookIOS9AfterAuthorization:^(bool isAuthorized) {
            
            if (isAuthorized) {
                //调用系统的通讯录界面
                JTLog(@"ios9之后调用系统的通讯录界面");
                if (@available(iOS 9.0, *)) {
                    CNContactPickerViewController *contact = [[CNContactPickerViewController alloc]init];
                    contact.delegate = self;
                    [self presentViewController:contact animated:YES completion:nil];
                }
                
               
                
            }else{
                
                [self alertControllerToSetup];//这里弹出提示让用户选择跳转到本程序的设置，打开通讯录
                
                
            }
            
        }];
        
    }else {
        NSLog(@"ios9之前");
        [JFHSUtilsTool CheckAddressBookIOS9BeforeAuthorization:^(bool isAuthorized) {
            
            if (isAuthorized) {
                
                ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
                
                nav.peoplePickerDelegate = self;
                
                [self presentViewController:nav animated:YES completion:nil];
                
            }else{
                
                [self alertControllerToSetup];
                
            }
            
        }];
        
    }
}
-(void)alertControllerToSetup
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您没有开启访问通讯录的权限,是否前往设置打开本程序的通讯录权限" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:goAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//实现代理方法

#pragma mark ABPeoplePickerNavigationControllerDelegate

//取消选择

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person

{
    //显示名称电话号码
    NSIndexPath *index =[NSIndexPath indexPathForRow:2 inSection:self.selectedBtnTag];
    JTSecondInformationTableViewCell *nameCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:index];
    NSIndexPath *teleIndex =[NSIndexPath indexPathForRow:3 inSection:self.selectedBtnTag];
    JTSecondInformationTableViewCell *teleCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:teleIndex];
    //这里有许多属性值可以带过来,参考 factory类里面的数组处理
    CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    CFStringRef abFullName = ABRecordCopyCompositeName(person);
    
    NSString *nameString = (__bridge NSString *)abName;
    
    NSString *lastNameString = (__bridge NSString *)abLastName;
    
    if ((__bridge id)abFullName != nil) {
        
        nameString = (__bridge NSString *)abFullName;
        
    } else {
        
        if ((__bridge id)abLastName != nil)
            
        {
            
            nameString = [NSString stringWithFormat:@"%@%@", nameString, lastNameString];
            
        }
        
    }
    
    NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
    
    ABMultiValueRef phones= ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    for (NSInteger j = 0; j < ABMultiValueGetCount(phones); j++) {
        
        [phoneArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
        
    }
    
    if(nameString.length != 0){
        
      
        JTLog(@"名字%@",nameString);
        nameCell.teleLable.text  = nameString;
    }
    
    if (phoneArr.count != 0) {
        
        NSString *firstPhone = [phoneArr firstObject];
        
        if ([firstPhone rangeOfString:@"-"].location != NSNotFound) {
            
            firstPhone  = [firstPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
        }
        
       
         JTLog(@"电话 =%@",firstPhone);
        teleCell.teleLable.text  = firstPhone;
    }
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark  CNContactPickerDelegate

//取消

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker

{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//选中与取消选中时调用的方法

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
API_AVAILABLE(ios(9.0)){
    
    //显示名称电话号码
    NSIndexPath *index =[NSIndexPath indexPathForRow:2 inSection:self.selectedBtnTag];
    JTSecondInformationTableViewCell *nameCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:index];
    NSIndexPath *teleIndex =[NSIndexPath indexPathForRow:3 inSection:self.selectedBtnTag];
    JTSecondInformationTableViewCell *teleCell =(JTSecondInformationTableViewCell *)[_informationTB cellForRowAtIndexPath:teleIndex];
    //这里有许多属性值可以带过来,参考 factory类里面的数组处理
    NSString * givenName = contact.givenName;
    
    NSString * familyName = contact.familyName;
    
    NSString *nameString = [NSString stringWithFormat:@"%@ %@",familyName,givenName];
    
    NSMutableArray *phoneArray = [NSMutableArray array];
    
    NSArray * tmpArr = contact.phoneNumbers;
    
    for (CNLabeledValue * labelValue in tmpArr) {
        
        CNPhoneNumber * number = labelValue.value;
        
        [phoneArray addObject:number.stringValue];
        
    }
    
   
    JTLog(@"名字%@",nameString);
    nameCell.teleLable.text = nameString;
    if (phoneArray.count != 0) {
        
        NSString *firstPhone = [phoneArray firstObject];
        
        if ([firstPhone rangeOfString:@"-"].location != NSNotFound) {
            
            firstPhone  = [firstPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
        }
        
      
        JTLog(@"电话=%@",firstPhone);
        teleCell.teleLable.text = firstPhone;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(NSArray *)placeArr
{
    if (!_placeArr) {
        _placeArr  = @[@"点击选择地址",@"请输入详细地址"];
    }
    return _placeArr;
}
-(NSArray *)secondNameArr
{
    if (!_secondNameArr) {
        _secondNameArr  = @[@[],@[@"紧急联系人1",@"关系",@"联系人姓名",@"联系人电话"],@[@"紧急联系人2",@"关系",@"联系人姓名",@"联系人电话"]];
    }
    return _secondNameArr;
}


@end
