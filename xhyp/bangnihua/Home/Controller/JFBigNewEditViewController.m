//
//  JFBigNewEditViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFBigNewEditViewController.h"
#import "JFCardNewEditTableViewCell.h"
#import "JFNewCardEditView.h"
#import "JFDeatilInformationNewViewController.h"
#import "JTWebViewController.h"
@interface JFBigNewEditViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,changeAddressDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong)UITableView *giveTbaleView;
@property (nonatomic, strong)JFNewCardEditView *CardView;
@property (nonatomic, strong)NSArray *nameArray;
@property (nonatomic, strong) UIButton *applyBtn;
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, assign)BOOL locationYesOrNo;//防止定位成功循环
@property (nonatomic, strong)UIButton *submitBtn;
@property (nonatomic, strong)NSArray *pickArray;
@property (nonatomic, strong)NSArray  *placeArr;
@property (nonatomic, strong)NSArray  *secondPlaceArr;
@property  (nonatomic, strong)NSString *webUrl;
@end

@implementation JFBigNewEditViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor colorWithHexString:@"#F5F5F5"];
    [self addLeftButtonItemWithImage:@"mine_comeBack_img" slected:@"mine_comeBack_img"];
    //定位服务
    self.locationYesOrNo  =  NO;
    [self location];
    [self setupTableView];
    [self setupCardView];
    JFUserInfoTool *userInfo=[JFUserManager shareManager].currentUserInfo;
    self.placeArr  = @[@[@"最低1万,最高100万",@"最短1个月,最长36个月 "],@[@"请填写",@"请填写",@"请选择"]];
    self.secondPlaceArr = @[@[@"",@"",@""],@[[JFHSUtilsTool isBlankString:userInfo.nameStr]?@"":userInfo.nameStr,[JFHSUtilsTool isBlankString:userInfo.identityStr]?@"":userInfo.identityStr,[JFHSUtilsTool isBlankString:userInfo.professionalStr]?@"":userInfo.professionalStr]];
    [self requestWebUrl];
    
}
#pragma mark-  请求big_give_text用户协议的url
-(void)requestWebUrl{
    NSString *basicUrl  =[NSString stringWithFormat:@"%@/mall/%@/appInfo",Flower_USER_URL,requesr_type];
    NSDictionary *dic =  @{@"appName":app_name_type};
   NSString *url  = [JFHSUtilsTool conectUrl:[dic mutableCopy] url:basicUrl];
    [PPNetworkHelper  GET:url parameters:@{} success:^(id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            self.webUrl =[NSString stringWithFormat:@"%@",responseObject[@"userInfoAuthAgreement"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - 定位
-(void)location{
    if ([CLLocationManager locationServicesEnabled]) {
        //开始定位
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        
        //设置寻址经度
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
            
        }
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;//每隔多少米定位一次 这里设置任何移动
        [_locationManager startUpdatingLocation];
    }
}
#pragma mark - CoreLocation delegate
#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //设置提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAlert = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingUrl];
    }];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sureAlert];
    [alert addAction:cancelAlert];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currentLocation = [locations lastObject];
    WEAKSELF;
    if (self.locationYesOrNo == NO) {
        self.locationYesOrNo = YES;
        //反向地理编码
        CLGeocoder  *clGeoCoder = [[CLGeocoder alloc]init];
        CLLocation *cl  = [[CLLocation alloc]initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        [clGeoCoder reverseGeocodeLocation:cl completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            for (CLPlacemark *placeMark in placemarks) {
                NSDictionary *addressDic = placeMark.addressDictionary;
                NSString *state=[addressDic objectForKey:@"State"];
                
                NSString *city=[addressDic objectForKey:@"City"];
                
                NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
                
                NSString *street=[addressDic objectForKey:@"Street"];
                NSLog(@"所在城市====%@ %@ %@ %@", state, city, subLocality, street);
                
                [weakSelf.locationManager stopUpdatingLocation];
                weakSelf.CardView.addressLable.text  = city;
            }
        }];
    }
    
}
-(void)leftBarButtonItemEvent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupCardView{
    _CardView = [[JFNewCardEditView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, 110 *  JT_ADAOTER_WIDTH)];
    _CardView.backgroundColor  =[UIColor whiteColor];
    _CardView.addressDelegate =  self;
    _giveTbaleView.tableHeaderView =_CardView;
}
-(void)setupTableView{
    WEAKSELF;
    _giveTbaleView  =[[UITableView alloc]initWithFrame:CGRectMake(0, JT_NAV, JT_ScreenW, 370  *JT_ADAOTER_WIDTH) style:UITableViewStylePlain];
    [self.view addSubview:_giveTbaleView];
    _giveTbaleView.delegate  = self;
    _giveTbaleView.dataSource = self;
    _giveTbaleView.scrollEnabled   = NO;
    _giveTbaleView.tableFooterView  = [UIView new];
    _giveTbaleView.tableHeaderView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];//解决顶部 多出的部分
    _giveTbaleView.backgroundColor  =[UIColor  clearColor];
    _giveTbaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //
    _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_applyBtn];
    [_applyBtn setImage:[UIImage imageNamed:@"img_new_nomal"] forState:UIControlStateNormal];
    [_applyBtn setImage:[UIImage imageNamed:@"img_new_selected"] forState:UIControlStateSelected];
    [_applyBtn setImage:[UIImage imageNamed:@"img_new_selected"] forState:UIControlStateHighlighted];
    _applyBtn.selected  = YES;
    [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(weakSelf.giveTbaleView.mas_bottom).offset(20* JT_ADAOTER_WIDTH);
        make.left.equalTo(self.view.mas_left).offset(30  * JT_ADAOTER_WIDTH);
    }];
    UILabel *agreedLable = [UILabel new];
    [self.view addSubview:agreedLable];
    agreedLable.font = kFontSystem(14);
    agreedLable.textColor  = [UIColor colorWithHexString:@"#333333"];
    NSString *agreeStr  =  @"同意《用户信息授权协议》";
    agreedLable.attributedText  =[JFHSUtilsTool attributedString:agreeStr selectedStr:@"《用户信息授权协议》"selctedColor:@"#47A3FF"haspreStr:@"同意"];
    [agreedLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.applyBtn.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.applyBtn);
    }];
    [_applyBtn addTarget:self action:@selector(applyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //添加 手势
    UITapGestureRecognizer *gesture  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureEvent)];
    agreedLable.userInteractionEnabled  = YES;
    [agreedLable addGestureRecognizer:gesture];
    //提交申请
    _submitBtn =[self.view buttonCreateWithNorStr:apply_tips_text nomalBgColor:@"#FF4D4F" textFont:18 cornerRadius:23];
    [self.view addSubview:_submitBtn];
    
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.applyBtn.mas_bottom).offset(24 * JT_ADAOTER_WIDTH);
        make.size.mas_offset(CGSizeMake(343 * JT_ADAOTER_WIDTH, 46 * JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self.view);
    }];
    [_submitBtn addTarget:self action:@selector(applayBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.nameArray[0]count];
    }
    
    return [self.nameArray[1]count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48  * JT_ADAOTER_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section  == 0) {
        return 0;
    }
    return 20*JT_ADAOTER_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view  = [UIView new];
    view.backgroundColor  =  [UIColor colorWithHexString:@"#F5F5F5"];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cellID";
    JFCardNewEditTableViewCell *cardCell  = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!cardCell) {
        cardCell =[[JFCardNewEditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    
    cardCell.nameTextFiled.tag  = indexPath.row;
    cardCell.nameTextFiled.delegate  = self;
    if (indexPath.section == 1) {
        if (indexPath.row  == 2) {
            cardCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cardCell.nameTextFiled.enabled  = NO;
        }
    }
    
    [cardCell getNameText:self.nameArray[indexPath.section][indexPath.row]detailTextStr:self.secondPlaceArr[indexPath.section][indexPath.row] placeTitle:self.placeArr[indexPath.section][indexPath.row]];
    cardCell.selectionStyle =   UITableViewCellSelectionStyleNone;
    //申请金额 期限  身份证显示数字键盘
    if (indexPath.section  == 0 || (indexPath.section==1&&indexPath.row == 1)) {
        cardCell.nameTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    }
    return cardCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row   ==2) {
        //选在职业信息
        JFCardNewEditTableViewCell *cell  = (JFCardNewEditTableViewCell *)[_giveTbaleView cellForRowAtIndexPath:indexPath];
       
        [self handlerbangnihuaTextFiledSelected:cell.nameLable.text index:indexPath];
    }
}
#pragma mark - 修改城市
-(void)changeAddress{
    JTLog(@"切换城市");
}

#pragma mark - 提交申请
-(void)applayBtnEvent:(UIButton *)btn{
    //金额
    NSIndexPath *priceIndex  = [NSIndexPath indexPathForRow:0 inSection:0];
    //月份
    NSIndexPath *monthIndex  = [NSIndexPath indexPathForRow:1 inSection:0];
    //姓名
    NSIndexPath *nameIndex  = [NSIndexPath indexPathForRow:0 inSection:1];
    //身份证
    NSIndexPath *indentityIndex  = [NSIndexPath indexPathForRow:1 inSection:1];
    //职业
    NSIndexPath *professionalIndex  = [NSIndexPath indexPathForRow:2 inSection:1];
    JFCardNewEditTableViewCell  *priceCell = (JFCardNewEditTableViewCell *)[_giveTbaleView cellForRowAtIndexPath:priceIndex];
    JFCardNewEditTableViewCell  *monthCell = (JFCardNewEditTableViewCell *)[_giveTbaleView cellForRowAtIndexPath:monthIndex];
    JFCardNewEditTableViewCell  *nameCell = (JFCardNewEditTableViewCell *)[_giveTbaleView cellForRowAtIndexPath:nameIndex];
    JFCardNewEditTableViewCell  *indentityCell = (JFCardNewEditTableViewCell *)[_giveTbaleView cellForRowAtIndexPath:indentityIndex];
     JFCardNewEditTableViewCell  *professionalCell = (JFCardNewEditTableViewCell *)[_giveTbaleView cellForRowAtIndexPath:professionalIndex];
    //回收键盘
    [priceCell.nameTextFiled resignFirstResponder];
    [monthCell.nameTextFiled resignFirstResponder];
    [nameCell.nameTextFiled resignFirstResponder];
    [indentityCell.nameTextFiled resignFirstResponder];
    //判断用户 是否 填写全 信息
    if ([JFHSUtilsTool isBlankString:priceCell.nameTextFiled.text]||[JFHSUtilsTool isBlankString:monthCell.nameTextFiled.text]||[JFHSUtilsTool isBlankString:nameCell.nameTextFiled.text]||[JFHSUtilsTool isBlankString:indentityCell.nameTextFiled.text]||[JFHSUtilsTool isBlankString:professionalCell.nameTextFiled.text]) {
        NSString *msg;
        msg = [JFHSUtilsTool isBlankString:priceCell.nameTextFiled.text]?[NSString stringWithFormat:@"请填写%@",priceCell.nameLable.text]:[JFHSUtilsTool isBlankString:monthCell.nameTextFiled.text]?[NSString stringWithFormat:@"请填写%@",monthCell.nameLable.text]:[JFHSUtilsTool isBlankString:nameCell.nameTextFiled.text]?[NSString stringWithFormat:@"%@%@",nameCell.nameTextFiled.placeholder,nameCell.nameLable.text]:[JFHSUtilsTool isBlankString:indentityCell.nameTextFiled.text]?[NSString stringWithFormat:@"%@%@",indentityCell.nameTextFiled.placeholder,indentityCell.nameLable.text]:[JFHSUtilsTool isBlankString:professionalCell.nameTextFiled.text]?[NSString stringWithFormat:@"%@%@",professionalCell.nameTextFiled.placeholder,professionalCell.nameLable.text]:@"";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:msg];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        
    }else{
        //判断用户输入 的金额和期限是否符合需求
        if ([priceCell.nameTextFiled.text integerValue]<9999 ||[priceCell.nameTextFiled.text integerValue] >1000001) {
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:priceCell.nameTextFiled.placeholder];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            return;
        }
        if ([monthCell.nameTextFiled.text integerValue]<1 ||[monthCell.nameTextFiled.text integerValue] >37) {
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:monthCell.nameTextFiled.placeholder];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            return;
        }
        //判断身份证格式是否正确
        if ([NSString jk_accurateVerifyIDCardNumber:indentityCell.nameTextFiled.text]) {
            //身份证正确  提交审核
            //提交申请接口
            NSString *submit_url  = [NSString stringWithFormat:@"%@/manager/bnh/userInfo",HS_USER_URL];
            //
            NSDictionary *userDic=  @{@"os":@"ios",@"appName":app_name_type};
            NSString *url   =[JFHSUtilsTool conectUrl:[userDic  mutableCopy] url:submit_url];
            
            NSDictionary *dic = @{@"username":nameCell.nameTextFiled.text,@"idcard":indentityCell.nameTextFiled.text,@"occupation":professionalCell.nameTextFiled.text};
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"正在提交申请..."];

            [JFHttpsToolEdit requestType:@"PUT" putWithUrl:url withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
                JTLog(@"%@",data);
                JTLog(@"msg=%@",msg);
                if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    JFDeatilInformationNewViewController *detailVC  =[[JFDeatilInformationNewViewController alloc]init];
                    //self.CardView.addressLable.text
                    //如果用户拒绝定位 则不传城市
                    NSString *cityStr  =[JFHSUtilsTool isBlankString:self.CardView.addressLable.text]?@"":self.CardView.addressLable.text;
                    NSArray  *temArr =@[priceCell.nameTextFiled.text,monthCell.nameTextFiled.text,[JFHSUtilsTool getIdentityCardAge:indentityCell.nameTextFiled.text],cityStr,professionalCell.nameTextFiled.text,nameCell.nameTextFiled.text,indentityCell.nameTextFiled.text];
                    detailVC.title  = fill_information_text;
                    detailVC.idx  = self.bigLoanIdx;
                  
                    detailVC.firstDetailArray  =  [temArr mutableCopy];
                    [self.navigationController pushViewController:detailVC animated:YES];
                    
                    //保存 姓名   身份证    职业信息
                    JFUserInfoTool *userInfo   =[JFUserManager shareManager].currentUserInfo;
                    userInfo.nameStr =nameCell.nameTextFiled.text;
                    userInfo.professionalStr  =professionalCell.nameTextFiled.text;
                    userInfo.identityStr  =indentityCell.nameTextFiled.text;
                    [JFUserManager shareManager].currentUserInfo  = userInfo;
                    
                    
                });
                }else{
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeText msgStr:data[@"resultCodeMessage"]];
                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                    });
                }
            } withErrorCodeTwo:^{
                 [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            } withErrorBlock:^(NSError * _Nonnull error) {
                JTLog(@"%@",error);
                 [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            }];

//        }
//        else{
//            //身份证格式错误
//            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"身份证格式错误,请重填写"];
//            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        }
      }
    //提交神策 数据
    NSDictionary  *dic = @{@"page_no":@"1",@"btn_id":@"1000",@"btn_name":btn.titleLabel.text};
    [[SensorsAnalyticsSDK sharedInstance]track:@"LargeLoanClick" withProperties:dic];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSIndexPath  *index =  [NSIndexPath indexPathForRow:1 inSection:1];
    JFCardNewEditTableViewCell  *cell  = (JFCardNewEditTableViewCell *)[_giveTbaleView cellForRowAtIndexPath:index];
    NSInteger len = 18;
    if (textField ==  cell.nameTextFiled) {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > len && range.length !=1) {
            textField.text = [toBeString substringToIndex:len];
            return NO;
        }
    }
    
    return YES;
}
-(void)applyBtnClick:(UIButton *)sender{
    
    _applyBtn.selected  = !sender.selected;
    _submitBtn.enabled  =_applyBtn.selected;
    if (_applyBtn.selected == YES) {
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor =[UIColor colorWithHexString:@"#FF4D4F"];
    }else{
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor =[UIColor colorWithHexString:@"#EEEEEE"];
    }
}
#pragma mark - 用户协议跳转
-(void)gestureEvent{
    JTLog(@"用户协议跳转");
    JTWebViewController *web  =[[JTWebViewController alloc]init];
    web.url  = self.webUrl;
    [self.navigationController pushViewController:web animated:YES];
}
-(void)handlerbangnihuaTextFiledSelected:(NSString *)selectedStr index:(NSIndexPath *)index{
   
    JFCardNewEditTableViewCell *cell  = (JFCardNewEditTableViewCell *)[_giveTbaleView cellForRowAtIndexPath:index];
    [BRStringPickerView showStringPickerWithTitle:selectedStr dataSource:self.pickArray defaultSelValue:@"" resultBlock:^(id selectValue) {
        cell.nameTextFiled.text  = selectValue;
    }];
}
-(NSArray *)nameArray{
    if (!_nameArray) {
        _nameArray = @[@[@"申请金额(元)",@"申请期限(月)"],@[@"姓名",@"身份证",@"职业信息"]];
    }
    return _nameArray;
}
-(NSArray *)pickArray{
    if (!_pickArray) {
        _pickArray  = @[@"工薪族",@"企业主",@"自由职业者"];
    }
    return _pickArray;
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
