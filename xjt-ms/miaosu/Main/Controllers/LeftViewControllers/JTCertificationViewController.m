//
//  JTCertificationViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTCertificationViewController.h"
#import "JTCertificationView.h"
#import "JTCertificationTableViewCell.h"
#import "JTBankCardViewController.h"
#import "JTBaseInformationViewController.h"
#import "JTOperatorViewController.h"
NSInteger personalCount  = 0;
NSInteger certicationCount  = 0;
NSInteger certicationTotalCountdownTime  = 0;
@interface JTCertificationViewController ()<CertificationHeaderDelegate,UITableViewDelegate,UITableViewDataSource,UDIDSafeAuthDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong)JTCertificationView *certificationView;//认证中心
@property  (nonatomic, strong)UITableView *CertificationTableView;
@property (strong, nonatomic)NSArray *nameArr;
@property (strong, nonatomic)NSArray *imageArr;
@property (nonatomic,  strong)NSMutableArray *addreessBookNameArr;//通讯录名字
@property (nonatomic, strong) NSString * partnerOrderId;
@property (nonatomic, strong) NSString * signTime;
@property (nonatomic, strong)NSArray  *selectedArr;
@property (nonatomic,strong)NSMutableArray *certificationArr;
@property (nonatomic, strong) NSString * xyorderID;//新颜认证的order
//定时器内容
@property (nonatomic, strong)dispatch_source_t persnoalInfoTime;//定义定时对象
@property (nonatomic, strong)dispatch_source_t  addressBookTime;//定义定时对象
@property (nonatomic, strong) NSString *currentTime;//获取当前时间戳
@end

@implementation JTCertificationViewController
-(void)dealloc{
    //基本信息认证成功
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"certificateBasicInfoNoticeSucess" object:nil];
    //再次实名认证
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"againCerticationnNotice" object:nil];
    //再次运营商认证
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"xyAgainCerticationNotion" object:nil];
    //银行认证成功
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"certificationBankSucessNotice" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
   
   
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.persnoalInfoTime) {
        dispatch_cancel(self.persnoalInfoTime);
    }
    if (self.addressBookTime) {
        dispatch_cancel(self.addressBookTime);
    }
}
#pragma mark - 定时器轮询个人信息
#pragma mark - 因为有时 数据返回延时
-(void)CertificationData:(NSInteger)certificationType{
  
    
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.persnoalInfoTime = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(4.0* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.persnoalInfoTime, start, interval, 0);
    //设置 回调
    dispatch_source_set_event_handler(self.persnoalInfoTime, ^{
        personalCount += 4;
        dispatch_async(dispatch_get_main_queue(), ^{
         
        });
        [self getPersonalData:certificationType];
    });
    if (personalCount  == certicationTotalCountdownTime||self.certificationArr.count) {
        //2两分钟之后停止定时
        dispatch_cancel(self.persnoalInfoTime);
        personalCount =  0;
        certicationTotalCountdownTime = 0;
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }
    //启动 定时器
    dispatch_resume(self.persnoalInfoTime);
}
#pragma mark -通过userKey获取用户的基本信息（包括认证信息）
-(void)getPersonalData:(NSInteger)type{
    NSString *certificationUrl  =[NSString stringWithFormat:@"%@/xjt/user",JT_MS_URL];
       JFUserInfoTool *userInf= [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:userInf.keyStr]) {
        [PPNetworkHelper setValue:userInf.keyStr forHTTPHeaderField:@"API_KEY"];
    }
    [PPNetworkHelper GET:certificationUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
         [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString  stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //当返回
            //停止定时器  当返回对应的值为1 的时候才停止轮询
            NSDictionary *basiDic =responseObject[@"user"];
            switch (type) {
                case certificationRealNameSucess:
                {
                    //实名认证处理
                    if ([[NSString  stringWithFormat:@"%@",basiDic[@"realnameVerified"]]isEqualToString:@"1"]) {
                    }
                    [self getEveryCertificationData:basiDic];
                }
               break;
                case certificationMobilSucess:
                {
                    //运营商 认证处理
                    if ([[NSString  stringWithFormat:@"%@",basiDic[@"mobileVerified"]]isEqualToString:@"1"]) {
                    }
                    [self getEveryCertificationData:basiDic];
                }
                    break;
                case certificationBasicInfoSucess:
                {
                    //基本信息 认证处理
                    if ([[NSString  stringWithFormat:@"%@",basiDic[@"basicInfoVerified"]]isEqualToString:@"1"]) {
                    }
                    [self getEveryCertificationData:basiDic];
                }
                    break;
                default:
                {
                    //银行卡认证
                    if ([[NSString  stringWithFormat:@"%@",basiDic[@"bankCardVerified"]]isEqualToString:@"1"]) {
                    }
                    [self getEveryCertificationData:basiDic];
                }
                    break;
            }
            //若果时间到 还没有轮询 到结果为1  显示最终的结果
//            if (personalCount  == certicationTotalCountdownTime){
//                 [self getEveryCertificationData:basiDic];
//            }
        }else{
            //其他错误 信息
             [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"2"]) {
                [self againLogin];
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeMessage"]];
                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                });
            }
        }
        [self.CertificationTableView reloadData];
    } failure:^(NSError *error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
   
}
#pragma mark - 处理各个认证信息的结果信息
-(void)getEveryCertificationData:(NSDictionary *)basiDic{
    [self.certificationArr removeAllObjects];
    if (self.persnoalInfoTime) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
         dispatch_cancel(self.persnoalInfoTime);
        
    }
   
    certicationTotalCountdownTime  = 0;
     JFUserInfoTool *userInf= [JFUserManager shareManager].currentUserInfo;
    JTCertificationModel *basiModel   =[JTCertificationModel mj_objectWithKeyValues:basiDic];
    
    [self.certificationArr addObject:basiModel];
    if (self.certificationArr.count) {
        //改变数组里的数据
        JTCertificationModel *model  = self.certificationArr[0];
        NSString  *basiInfoImg =[model.basicInfoVerified isEqualToString:@"1"]?@"idcard_success":@"idcard_nomal";
        NSString  *bankImg =[model.bankCardVerified isEqualToString:@"1"]?@"bankCard_success":@"bankCard_nomal";
     
        if (![JFHSUtilsTool isBlankString:userInf.operatorTimeStr]) {
        //如果有时间戳说明是已经运营商认证返回了
            if ([model.mobileVerified isEqualToString:@"0"]&&[userInf.operatorTimeStr integerValue]<= 15 * 24 *3600) {
                //15分钟内
                //说明后台还没有拿到结果  显示认证中
                model.mobileVerified  = @"4";
            }else{
                //时间戳清零
                userInf.operatorTimeStr  = @"0";
            }
            
        }
         NSString  *mobileImg =[model.mobileVerified isEqualToString:@"1"]?@"signal_success":@"signal_nomal";
        NSString  *realnameImg =[model.realnameVerified isEqualToString:@"1"]?@"certification_success":@"certification_nomal";
        self.imageArr  = @[realnameImg,mobileImg,basiInfoImg,bankImg];
        NSArray  *cercicationArr = @[model.realnameVerified,model.mobileVerified,model.basicInfoVerified,model.bankCardVerified];
        for (NSInteger i =0; i < cercicationArr.count; i ++) {
            if ([cercicationArr[i] isEqualToString:@"1"]) {
                certicationCount ++;
            }
        }
        //保存名字和已经认证多少项
        userInf.certificationNumberStr = [NSString stringWithFormat:@"%zd",certicationCount];
        [self.certificationView getAreadyCeitication:[NSString stringWithFormat:@"%zd",certicationCount]];
        if(![JFHSUtilsTool isOtherBlankString:model.userName]){
           userInf.userNameStr  = model.userName;
        }
        userInf.idCardStr = model.idCardNo;
        [JFUserManager shareManager].currentUserInfo = userInf;
        //发送通知修改 左侧的显示状态
        [[NSNotificationCenter defaultCenter]postNotificationName:@"certificationSucessNotice" object:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"认证中心";
    self.view.backgroundColor =  [UIColor colorWithHexString:@"#F5F5F5"];
    self.certificationArr  = [NSMutableArray array];
    self.addreessBookNameArr =[NSMutableArray array];
    self.currentTime  = @"0";
    [self CertificationTableViewUI];
    [self getBasicPersonalData];
    [self headerUI];
    if (@available(iOS 11.0, *)) {
        _CertificationTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(certificateBasicInfoNoticeSucessEvent) name:@"certificateBasicInfoNoticeSucess" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(certificateNoticeAgainEvent) name:@"againCerticationnNotice" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xyAgainCerticationEvent) name:@"xyAgainCerticationNotion" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(certificationBankSucessNoticeEvent) name:@"certificationBankSucessNotice" object:nil];
    
    
}
#pragma mark -  一进入界面请求个人 信息 基本的
-(void)getBasicPersonalData{
    certicationCount = 0;
    NSString *certificationUrl  =[NSString stringWithFormat:@"%@/xjt/user",JT_MS_URL];
    JFUserInfoTool *userInf= [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:userInf.keyStr]) {
        [PPNetworkHelper setValue:userInf.keyStr forHTTPHeaderField:@"API_KEY"];
    }
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [PPNetworkHelper GET:certificationUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString  stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
              [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            NSDictionary *basiDic =responseObject[@"user"];
//                JTCertificationModel *basiModel   =[JTCertificationModel mj_objectWithKeyValues:basiDic];
            [self getEveryCertificationData:basiDic];
          
        }else{
            //其他错误 信息
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        }
        [self.CertificationTableView reloadData];
    } failure:^(NSError *error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
}
#pragma mark  - 实名认证失败后再次实名认证
-(void)certificateNoticeAgainEvent{
     [self getPartnerOrderId];
}
#pragma mark - 再次运营商认证
-(void)xyAgainCerticationEvent{
     JTCertificationModel *model =self.certificationArr[0];
    if (![model.maillistVerified isEqualToString:@"1"]) {
        //说明没上传过通讯录
        //获取x新颜认证 的orderid
        [self xyorderIDdata];
        [self certificationBgViewUI];
    }else{
        //说明还没有新颜认证
        [self xyorderIDMaillistVerifiedData];
    }
}
#pragma mark  - 认证成功  改变已经认证多少项 --基本信息e认证
-(void)certificateBasicInfoNoticeSucessEvent{
    certicationTotalCountdownTime = 120;
     [self CertificationPersonalData:certificationBasicInfoSucess];
}
#pragma mark -银行认证成功
-(void)certificationBankSucessNoticeEvent{
     certicationTotalCountdownTime = 40;
    [self CertificationPersonalData:certificationBankSucess];
}
-(void)CertificationTableViewUI{
    _CertificationTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH) style:UITableViewStylePlain];
    _CertificationTableView.backgroundColor =  [UIColor colorWithHexString:@"#F5F5F5"];
    _CertificationTableView.delegate = self;
    _CertificationTableView.dataSource  = self;
    _CertificationTableView.scrollEnabled  = NO;
    _CertificationTableView.separatorStyle  =  UITableViewCellSeparatorStyleNone;
    _CertificationTableView.tableFooterView   = [UIView new];
    [self.view addSubview:_CertificationTableView];
}
-(void)headerUI{
    _certificationView  = [[JTCertificationView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, 235 *JT_ADAOTER_WIDTH)];
    _CertificationTableView.tableHeaderView = _certificationView;
    _certificationView.certificationDelegate   =self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.imageArr.count) {
        return self.imageArr.count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView  *headerView =[UIView new];
    headerView.backgroundColor =[UIColor colorWithHexString:@"#F5F5F5"];
    return headerView;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"cell";
    JTCertificationTableViewCell *certificationCell =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!certificationCell) {
        certificationCell = [[JTCertificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    if (indexPath.row  == self.nameArr.count) {
        certificationCell.lineLable.hidden = YES;
    }
    if (self.certificationArr.count) {
        [certificationCell getLeftImg:self.imageArr[indexPath.row] leftNameStr:self.nameArr[indexPath.row]certicationModel:self.certificationArr[0]idx:indexPath.row];
    }
    
    certificationCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    return certificationCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JTCertificationModel *model =self.certificationArr[0];
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
        if (indexPath.row  ==0) {
            //实名认证
            //请求接口获取PartnerOrderId
            if ([model.realnameVerified isEqualToString:@"0"]) {
                [self getPartnerOrderId];
            }else{
                //说明已经实名认证过 的
                //为了防止用户频繁操作 点击获取当前时间戳
                if ([model.realnameVerified isEqualToString:@"2"]) {
                    if ([self.currentTime integerValue]<[model.realnameVerifiedDate integerValue]) {
                        self.currentTime= @"0";
                        JTOperatorViewController  *operatorVC =[[JTOperatorViewController alloc]init];
                        operatorVC.type  = certication_success;
                
                        operatorVC.title   = @"实名认证";
                        [self.navigationController pushViewController:operatorVC animated:YES];
                    }else{
                  
                    }
                }else{
                    JTOperatorViewController  *operatorVC =[[JTOperatorViewController alloc]init];
                    operatorVC.type  = certication_success;
                    operatorVC.title   = @"实名认证";
                    [self.navigationController pushViewController:operatorVC animated:YES];
                }
                
            }
        }else{
            if (![model.realnameVerified isEqualToString:@"1"]) {
                        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"实名认证通过之后才能继续其他的认证"];
                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            }else{
                if ([model.realnameVerified isEqualToString:@"1"]) {
                    //实名认证完之后才能进行下一项
                    if (indexPath.row == 1) {
                        //运营商认证
                        if (![model.maillistVerified isEqualToString:@"1"]) {
                            //说明没上传过通讯录
                            //获取x新颜认证 的orderid
                            [self certificationBgViewUI];
                            [self xyorderIDdata];
                        }else{
                            if([model.mobileVerified isEqualToString:@"0"]){
                                //说明还没有新颜认证
                                [self xyorderIDMaillistVerifiedData];
                            }else{
                                //已新颜认证跳转到其他 的界面
                                //说明已经认证过了
                                if ([model.mobileVerified isEqualToString:@"2"]) {
                                    if ([self.currentTime integerValue]<[model.mobileVerifiedDate integerValue]) {
                                        self.currentTime = @"0";
                                        JTOperatorViewController  *operatorVC =[[JTOperatorViewController alloc]init];
                                        operatorVC.title =@"运营商认证";
                                        //认证失败
                                        operatorVC.type  = operator_fail;
                                        [self.navigationController pushViewController:operatorVC animated:YES];
                                    }
                                }else{
                                    //operator_review 认证中
                                    JTOperatorViewController  *operatorVC =[[JTOperatorViewController alloc]init];
                                    operatorVC.title =@"运营商认证";
                                    if (userInfo.operatorTimeStr &&  [model.mobileVerified isEqualToString:@"0"]) {
                                        //说明在认证中
                                          operatorVC.type  = operator_review;
                                    }else{
                                        operatorVC.type  = operator_success;
                                    }
                                 
                                    [self.navigationController pushViewController:operatorVC animated:YES];
                                }
                                
                                
                            }
                        }
                    }else{
                        if ([model.mobileVerified isEqualToString:@"1"]) {
                            //说明运营 商认证完成
                            if (indexPath.row  == 2) {
                                //基本信息认证
                                //基本信息认证
                                //先判断用户是否已经基本信息认证
                                if ([model.basicInfoVerified isEqualToString:@"1"]) {
                                    //已经认证
                                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"基本信息已认证"];
                                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                                }else{
                                    JTBaseInformationViewController  *informationVC =[[JTBaseInformationViewController alloc]init];
                                    informationVC.xyAction  =  @"xyAction";
                                    [self.navigationController pushViewController:informationVC animated:YES];
                                }
                            }else{
                                if ([model.basicInfoVerified isEqualToString:@"1"]) {
                                    //基本信息认证完成可以进行银行卡认证
                                    //银行卡认证
                                    JTBankCardViewController *bankVC =[[JTBankCardViewController  alloc]init];
                                    if ([model.bankCardVerified isEqualToString:@"1"]) {
                                        bankVC.showType=  showSucess;
                                    }else{
                                        //银行卡认证 未认证
                                        bankVC.showType=  showApplyCard;
                                    }
                                    bankVC.xyType = @"xyAction";
                                    [self.navigationController pushViewController:bankVC animated:YES];
                                }else{
                                    //提示基本信息没完成
                                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"基本信息认证之后才能继续其他的认证"];
                                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                                }
                            }  
                        }else{
                            //提示运营商认证没完成
                            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"运营商认证之后才能继续其他的认证"];
                            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
                        }
                    }
                }
            }
        }
}
#pragma mark  - 获取实名认证的OrderId
-(void)getPartnerOrderId{
    NSString  *OrderIdUrl  =[NSString stringWithFormat:@"%@/report/udPartnerOrderId",JT_MS_URL];
    JFUserInfoTool  *user  = [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:user.keyStr]) {
        [PPNetworkHelper setValue:user.keyStr forHTTPHeaderField:@"API_KEY"];
    }
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"加载中"];
    [PPNetworkHelper GET:OrderIdUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            NSString *orderID= [NSString stringWithFormat:@"%@",responseObject[@"partnerOrderId"]];
            //获取当前的时间戳
            self.currentTime    = [NSString jk_UUIDTimestamp];
            [self UDIDSafeEvent:orderID];
        }
    } failure:^(NSError *error) {
        JTLog(@"%@",error);
         [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
}
#pragma mark-实名认证
-(void)UDIDSafeEvent:(NSString *)orderID{
    UDIDSafeAuthEngine *engin  =[[UDIDSafeAuthEngine alloc]init];
    engin.delegate  = self;
    engin.authKey = PUB_KEY;//对应开户邮件下发的pubkey值
    engin.notificationUrl  = [NSString stringWithFormat:@"%@/report/udReport/notify",JT_MS_URL];//异步通知地址
    engin.outOrderId = orderID;//商户外部订单号，必传
    engin.showInfo =  YES;//是否显示身份证ocr信息,确认信息页面
    [engin  startIdSafeFaceAuthInViewController:self];
}
#pragma mark - UDIDSafeAuthDelegate
- (void)idSafeAuthFinishedWithResult:(UDIDSafeAuthResult)result UserInfo:(id)userInfo{
    JTLog(@"userInfo=%@",userInfo);
  
    if (result == UDIDSafeAuthResult_Done) {
//        if ([userInfo[@"result_auth"]isEqualToString:@"T"]) {
//            //认证通过
//            [self CertificationFirstCell:@"#62A7E9" textStr:@"认证中"idx:0];
//            //认证成功 请求 个人信息接口 因为有延时 所以要定时器
//            certicationTotalCountdownTime = 120;
//            [self CertificationPersonalData:certificationRealNameSucess];
//        }else{
//            //认证失败
//            //直接请求个人信息接口 改变状态值
//             [self getBasicPersonalData];
//        }
        [self CertificationFirstCell:@"#62A7E9" textStr:@"认证中"idx:0];
        //认证成功 请求 个人信息接口 因为有延时 所以要定时器
        certicationTotalCountdownTime = 120;
        [self CertificationPersonalData:certificationRealNameSucess];
    }else if (result == UDIDSafeAuthResult_Error){
        //认证异常，如网络异常等
        self.currentTime= @"0";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"认证异常"];
    }else if (result == UDIDSafeAuthResult_Cancel){
        //用户取消认证操作
        self.currentTime= @"0";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"用户取消认证操作"];
    }else if (result == UDIDSafeAuthResult_UserNameError){
        //商户传入的姓名不合法
        self.currentTime= @"0";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"传入的姓名不合法"];
    }else if (result == UDIDSafeAuthResult_UserIdNumberError){
        //商户传入的身份证号码不合法
        self.currentTime= @"0";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"身份证号码不合法"];
    }else {
        //订单为空 UDIDSafeAuthResult_BillNil
        self.currentTime= @"0";
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"订单为空"];
    }
    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
     [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    
}
#pragma mark - 在个人 信息返回之前 显示
-(void)CertificationFirstCell:(NSString *)corlor textStr:(NSString *)str idx:(NSInteger)idx{
    JTCertificationModel *model  = self.certificationArr[0];
    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    NSIndexPath *index  =[NSIndexPath indexPathForRow:idx inSection:0];
    if (idx ==0) {
        //认证中
        model.realnameVerified  = @"4";
    }else if (idx ==1)
    {
        model.mobileVerified = @"4";
        
    }
    [_CertificationTableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 上传 通讯录
-(void)certificationBgViewUI{
    [self alertCerticationMsg:@"运营商认证需要先上传您的通讯录，仅用于查询个人征信，我们承诺保护用户隐私。" tipsStr:@"通讯录上传" sureStr:@"上传通讯录"cancelStr:@"稍后"];
}
#pragma mark   - 获取新颜认证的orderid
-(void)xyorderIDdata{
    NSString  *OrderIdUrl  =[NSString stringWithFormat:@"%@/report/qzTaskId",JT_MS_URL];
    JFUserInfoTool  *user  = [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:user.keyStr]) {
        [PPNetworkHelper setValue:user.keyStr forHTTPHeaderField:@"API_KEY"];
    }
    [PPNetworkHelper GET:OrderIdUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            NSString *orderID= [NSString stringWithFormat:@"%@",responseObject[@"taskId"]];
            self.xyorderID  = orderID;
            
        }
    } failure:^(NSError *error) {
        JTLog(@"%@",error);
    }];
}
#pragma makr - 说明是上传通讯录之后但没验证的
-(void)xyorderIDMaillistVerifiedData{
    NSString  *OrderIdUrl  =[NSString stringWithFormat:@"%@/report/qzTaskId",JT_MS_URL];
    JFUserInfoTool  *user  = [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:user.keyStr]) {
        [PPNetworkHelper setValue:user.keyStr forHTTPHeaderField:@"API_KEY"];
    }
    [PPNetworkHelper GET:OrderIdUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            NSString *orderID= [NSString stringWithFormat:@"%@",responseObject[@"taskId"]];
            
            [self xyCertification:orderID];
        }
    } failure:^(NSError *error) {
        JTLog(@"%@",error);
    }];
}
#pragma mark - 上传通讯录事件
-(void)alertSureBtnEvent{
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
                if (error) {
                    NSLog(@"授权失败");
                }else {
                    [self openContact];
                    NSLog(@"成功授权");
                }
            }];
        }
        else if(status == CNAuthorizationStatusRestricted)
        {
            NSLog(@"用户拒绝");
            [self alertControllerToSetup];
        }
        else if (status == CNAuthorizationStatusDenied)
        {
            NSLog(@"用户拒绝");
            [self alertControllerToSetup];
        }
        else if (status == CNAuthorizationStatusAuthorized)//已经授权
        {
            //有通讯录权限-- 进行下一步操作
            [self openContact];
        }
    }
}
-(void)openContact{
    if (@available(iOS 9.0, *)) {
        // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
        NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        
        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            //拼接姓名
            NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            
            NSArray *phoneNumbers = contact.phoneNumbers;
            //        JTLog(@"名字%@",nameStr);
            for (CNLabeledValue *labelValue in phoneNumbers) {
                //遍历一个人名下的多个电话号码
                //            NSString *label = labelValue.label;
                //   NSString *    phoneNumber = labelValue.value;
                CNPhoneNumber *phoneNumber = labelValue.value;
                
                NSString * string = phoneNumber.stringValue ;
                
                //去掉电话中的特殊字符
                string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                [self.addreessBookNameArr addObject:@{@"username":nameStr,@"phoneNumber":string}];
                
            }
            
            //    *stop = YES; // 停止循环，相当于break；
            
        }];
    }
    JTLog(@"%@",self.addreessBookNameArr);
    if (self.addreessBookNameArr.count) {
        [self addressbookTiming:self.addreessBookNameArr];
    }else{
        [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"通讯录为空"];
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
    }
}
#pragma mark  - 上传通讯录 定时
-(void)addressbookTiming:(NSMutableArray *)addressBook{
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.addressBookTime = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(4.0* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.addressBookTime, start, interval, 0);
    //设置 回调
    dispatch_source_set_event_handler(self.addressBookTime, ^{
        personalCount += 4;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self submitAddressbookData:addressBook];
        });
        
    });
    if (personalCount  == 120) {
        //2两分钟之后停止定时
        dispatch_cancel(self.addressBookTime);
        personalCount =  0;
         [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }
    //启动 定时器
    dispatch_resume(self.addressBookTime);
}
-(void)submitAddressbookData:(NSMutableArray *)bookArr{
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    NSString *addressUrl =[NSString stringWithFormat:@"%@/xjt/user/maillists",JT_MS_URL];
    NSDictionary *dic  = @{@"maillists":bookArr};
    JTLog(@"%@",dic);
    [JFHttpsTool requestType:@"POST" passwordStr:@"" putWithUrl:addressUrl withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
        JTLog(@"%@",data);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
            //通讯上传成功 之后 进行新颜运营商认证
            dispatch_cancel(self.addressBookTime);
            if (self.xyorderID) {
                
                [self xyCertification:self.xyorderID];
            }
            
        }
    } withErrorCodeTwo:^{
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    } withErrorBlock:^(NSError * _Nonnull error) {
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
}
#pragma mark -  新颜认证事件
-(void)xyCertification:(NSString *)xyorderID{
    JFUserInfoTool *userInfo   =[JFUserManager shareManager].currentUserInfo;
    [[XYCrawlerSDK sharedSDK] startFunctionOfCarrierWithTaskId:xyorderID mobile:[[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"] password:@"" idCard:userInfo.idCardStr realName:userInfo.userNameStr inputEditing:NO showIdNameInput:YES resultCallBack:^(XYCrawlerSDKFunction function, int code, NSString *token, NSString *message) {
        JTLog(@"运营商-认证结果：%@%@",token,message);
      //保存当前的s时间戳  用于判断 运营商15分钟内后台h都没有返回结果
      
        if (code) {
            [self CertificationFirstCell:@"#FF4D4F" textStr:@"认证失败"idx:1];
            certicationTotalCountdownTime = 120;
            [self CertificationPersonalData:certificationMobilSucess];
            if (code  ==1) {
                self.currentTime  =[NSString jk_UUIDTimestamp];
                userInfo.operatorTimeStr =[NSString jk_UUIDTimestamp];
            }else{
//                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
//
//                //其余状态均为失败 直接提示用户即可
//                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:message];
//                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            }
        }
    }];
    [JFUserManager shareManager].currentUserInfo=  userInfo;
}
-(void)alertControllerToSetup
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"申请借款需要授权'通讯录',请打开手机设置->隐私->通讯录对'小金条'设为允许" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
         [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [goAction setValue:[UIColor colorWithHexString:@"#62A7E9"] forKey:@"_titleTextColor"];
    [cancelAction setValue:[UIColor colorWithHexString:@"#666666"] forKey:@"titleTextColor"];
    [alertVC addAction:goAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(NSArray *)nameArr{
    if (!_nameArr) {
        _nameArr =  @[@"实名认证",@"运营商认证",@"基本信息认证",@"银行卡认证"];
    }
    return _nameArr;
}
-(NSArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr =  @[@"certification_success",@"signal_success",@"idcard_success",@"bankCard_success"];
    }
    return _selectedArr;
}
-(void)certificationleftBarButtonItemEvent{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-各项认证调用 实名认证  运营商认证  银行卡认证 均有延时
-(void)CertificationPersonalData:(NSInteger)type{
    certicationCount  =0;
    [self.certificationArr removeAllObjects];
     [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [self CertificationData:type];
}
@end
