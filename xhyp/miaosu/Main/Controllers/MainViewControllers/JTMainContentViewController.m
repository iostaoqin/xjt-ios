//
//  JTMainContentViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTMainContentViewController.h"
#import "JTMessageCenterViewController.h"
#import "HomePopupTipsView.h"
#import "JTHomeHeaderView.h"
#import "JFMainHeaderNewCollectionViewCell.h"
#import "JTHomeThirdView.h"
#import "JTLoanOrderViewController.h"
#import "JTPaymentOrderViewController.h"
#import "JTBorrowingViewController.h"
#import "JTCertificationViewController.h"
NSInteger certicationMainCount = 0;
@interface JTMainContentViewController ()<homeDelegate,UICollectionViewDelegate,UICollectionViewDataSource,closePopupDelegate>

@property (nonatomic, strong)UIScrollView *bottomScrollView;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)HomePopupTipsView *popupView;
@property (nonatomic, strong)JTHomeHeaderView *headerView;
@property (nonatomic, strong)NSArray *nameArray;
@property (nonatomic, strong)NSArray *imgArray;
@property (nonatomic,strong)UICollectionView *firstCollection;
@property (nonatomic,strong)JTHomeThirdView *thirdHomeView;
@property (nonatomic, strong)NSMutableArray *loanArray;


@end

@implementation JTMainContentViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginSucessNotice" object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"personalSucessNotice" object:nil];

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    /**获取配置信息**/
    [self loanPropertiesData];
    /**请求通知信息list**/
    [self notificationlistsData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self headerHomeUI];
    if (@available(iOS 11.0, *)) {
        self.bottomScrollView.contentInsetAdjustmentBehavior  =UIScrollViewContentInsetAdjustmentNever;
    }
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSucessNoticeEvent) name:@"loginSucessNotice" object:nil];
    //
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(personalSucessNoticeEvent) name:@"personalSucessNotice" object:nil];
    certicationMainCount   = 0;
    self.loanArray=[NSMutableArray array];
    /**获取个人信息**/
    [self personalData];
    
   
}

#pragma mark  - 登录成功之后重新请求用户信息
-(void)personalSucessNoticeEvent{
    certicationMainCount  =0;
     [self personalData];
}
#pragma mark  - 请求配置信息
-(void)loanPropertiesData{
    NSString *loanStr   = [NSString stringWithFormat:@"%@/xjt/user/loanProperties",JT_MS_URL];
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:userInfo.keyStr]) {
        [PPNetworkHelper setValue:userInfo.keyStr forHTTPHeaderField:@"API_KEY"];
    }else{
         [PPNetworkHelper setValue:@"" forHTTPHeaderField:@"API_KEY"];
    }
     [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@"加载中"];
    [PPNetworkHelper GET:loanStr parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            [self.loanArray removeAllObjects];
            //请求成功 刷新数据
            JTLoanModel *loanModel = [JTLoanModel mj_objectWithKeyValues:responseObject];
            if (![JFHSUtilsTool isBlankString:loanModel.repaymentNeedDate]) {
                
                loanModel.repaymentNeedDate =[JFHSUtilsTool getDateStringWithTimeStr: loanModel.repaymentNeedDate showType:@"yyyy-MM-dd"];
            }
            
            [self.headerView getLineofCredit:loanModel];
            [self.thirdHomeView getLoanModel:loanModel];
            [self.loanArray addObject:loanModel];
        }else{
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
        JTLog(@"%@",error);
        if (error.code== -1009) {
            //断开互联网的连接
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"似乎已断开与互联网的连接。"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            });
            
        }
    }];
}
#pragma mark  -请求通知信息
-(void)notificationlistsData{
    JFUserInfoTool *userinfo =[JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:userinfo.keyStr]) {
    NSString *noticeurl  =[NSString stringWithFormat:@"%@/xjt/messages",JT_MS_URL];
    
    [PPNetworkHelper setValue:userinfo.keyStr forHTTPHeaderField:@"API_KEY"];

    [PPNetworkHelper GET:noticeurl parameters:nil success:^(id responseObject) {
        JTLog(@"请求通知信息=%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //unreadCount  根据这个值来判断 是否显示红点
            [[NSNotificationCenter defaultCenter]postNotificationName:@"messagesNotification" object:[NSString stringWithFormat:@"%@",responseObject[@"unreadCount"]]];
        }
    } failure:^(NSError *error) {
    
    }];
        
    }
}
#pragma mark  - 请求 个人信息接口
-(void)personalData{
    JFUserInfoTool *userInf= [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:userInf.keyStr]) {
       
        NSString *certificationUrl  =[NSString stringWithFormat:@"%@/xjt/user",JT_MS_URL];
        [PPNetworkHelper setValue:userInf.keyStr forHTTPHeaderField:@"API_KEY"];
        [PPNetworkHelper GET:certificationUrl parameters:nil success:^(id responseObject) {
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
                NSDictionary *basiDic =responseObject[@"user"];
                NSArray  *cercicationArr = @[[NSString stringWithFormat:@"%@",basiDic[@"realnameVerified"]],[NSString stringWithFormat:@"%@",basiDic[@"mobileVerified"]],[NSString stringWithFormat:@"%@",basiDic[@"basicInfoVerified"]],[NSString stringWithFormat:@"%@",basiDic[@"bankCardVerified"]]];
                for (NSInteger i =0; i < cercicationArr.count; i ++) {
                    if ([cercicationArr[i] isEqualToString:@"1"]) {
                        certicationMainCount ++;
                    }
                }
                //保存名字和已经认证多少项
              
                if([JFHSUtilsTool isOtherBlankString:basiDic[@"userName"]]){
                    JTLog(@"456");
                }else{
                   userInf.userNameStr  = [NSString stringWithFormat:@"%@",basiDic[@"userName"]];
                }
                userInf.certificationNumberStr = [NSString stringWithFormat:@"%zd",certicationMainCount];
                userInf.xteleNumberStr  = basiDic[@"phoneNumber"];
                userInf.idCardStr  = basiDic[@"idCardNo"];
                [JFUserManager shareManager].currentUserInfo = userInf;
                [[NSUserDefaults standardUserDefaults]setValue:basiDic[@"phoneNumber"] forKey:@"teleValue"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"persoalDataSucessNotice" object:nil];
            }
            JTLog(@"%@",responseObject);
        } failure:^(NSError *error) {
           
        }];
    }
}

#pragma mark - 登录成功
-(void)loginSucessNoticeEvent{
    //首次登录成功  弹窗
    NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
    if (![TimeOfBootCount valueForKey:@"loginFirstTime"]) {
        [TimeOfBootCount setValue:@"loginFirstTC" forKey:@"loginFirstTime"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self tangchuangUI];
        });
        }
    
}
-(void)headerHomeUI{

    _headerView  = [[JTHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, 235 *JT_ADAOTER_WIDTH)];
    [self.view addSubview:_headerView];
    _headerView.delegate =self;
     [self.view addSubview:self.firstCollection];
    [_firstCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.width.mas_equalTo(JT_ScreenW);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(115 *JT_ADAOTER_WIDTH);
      
    }];
    _thirdHomeView = [JTHomeThirdView new];
    [self.view addSubview:_thirdHomeView];
    _thirdHomeView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [_thirdHomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstCollection.mas_bottom).offset(20 *JT_ADAOTER_WIDTH);
        make.width.mas_equalTo(JT_ScreenW);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(170 *JT_ADAOTER_WIDTH);
    }];
    [_thirdHomeView getRefresh:@"1"];
    //button
    CGFloat font;
    if (JT_IS_iPhone5) {
        font = 16;
    }else{
        font = 18;
    }
    UIButton *borrowingBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:343* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
    [self.view addSubview:borrowingBtn];
    [borrowingBtn setTitle:[JFHSUtilsTool decodeFromPercentEscapeString:borrowing_price_text] forState:UIControlStateNormal];
    borrowingBtn.titleLabel.font = kFontSystem(font);
    [borrowingBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343* JT_ADAOTER_WIDTH, 46* JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.thirdHomeView.mas_bottom).offset(37* JT_ADAOTER_WIDTH);
    }];
   
    //goloan
    [borrowingBtn addTarget:self action:@selector(borrowingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //高度是否超过一整屏幕
//    CGFloat height =_headerView.frame.size.height +115 *JT_ADAOTER_WIDTH + 220 *JT_ADAOTER_WIDTH + 83 *JT_ADAOTER_WIDTH+ 40 *JT_ADAOTER_WIDTH;
//    if (height > JT_ScreenH) {
//        self.view.contentSize   = CGSizeMake(0, height);
//    }
    //
    UITapGestureRecognizer *thirdTapGesture   =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thirdGestureEvent)];
    [_thirdHomeView.nameLable addGestureRecognizer:thirdTapGesture];
    _thirdHomeView.nameLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *arrowImgTapGesture   =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thirdGestureEvent)];
    [_thirdHomeView.arrowImg addGestureRecognizer:arrowImgTapGesture];
    _thirdHomeView.arrowImg.userInteractionEnabled = YES;
    
}
#pragma mark  - 进入详情界面
-(void)thirdGestureEvent{
    //检查用户是否登录
    JFUserInfoTool *userInfo  =[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.keyStr]) {
        //跳转到登录界面
        JTLoginViewController *loginVC  =[[JTLoginViewController alloc]init];
        JTBaseNavigationController *nav = [[JTBaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        [self.sideMenuViewController hideMenuViewController];
    }else{
        //订单
        JTLoanOrderViewController *loanVC =[[JTLoanOrderViewController alloc]init];
        [self.navigationController pushViewController:loanVC animated:YES];
    }
}
#pragma mark - 去borrowing
-(void)borrowingBtnClick{
        JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    if (self.loanArray.count) {
        
    
    JTLoanModel *model  =self.loanArray[0];
 
        if ([userInfo.certificationNumberStr isEqualToString:CERICATION]) {
            JTBorrowingViewController *borrowVC =[[JTBorrowingViewController  alloc]init];
            borrowVC.maxValue = [NSString stringWithFormat:@"%ld",[model.maxAmount integerValue]/100];
            borrowVC.minValue = [NSString stringWithFormat:@"%ld",[model.minMount integerValue]/100];
            borrowVC.feedarr =model.propertys;
            [self.navigationController pushViewController:borrowVC animated:YES];
        }else{
           
            if ([JFHSUtilsTool isBlankString:userInfo.keyStr]) {
                JTLoginViewController *loginVC  =[[JTLoginViewController alloc]init];
                JTBaseNavigationController *nav = [[JTBaseNavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:nav animated:YES completion:nil];
                [self.sideMenuViewController hideMenuViewController];
            }else{
                if ([JFHSUtilsTool isBlankString:userInfo.certificationNumberStr]||[userInfo.certificationNumberStr isEqualToString:@"0"]) {
                    [self alertCerticationMsg:@"请先完成认证" tipsStr:@"认证提示" sureStr:@"去认证"cancelStr:@"稍后"];
                    
                }else{
                    [self alertCerticationMsg:@"请完成所有认证" tipsStr:@"认证提示" sureStr:@"去认证"cancelStr:@"稍后"];
                }
            }
        }
    }
}
-(void)alertSureBtnEvent{
    //跳转到认证页面
    JTCertificationViewController  *certicationVC =[[JTCertificationViewController alloc]init];
    [self.navigationController pushViewController:certicationVC animated:YES];
}
-(void)rightBarButtonItemEvent{
    JFUserInfoTool *userInfo  =[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.keyStr]) {
        //跳转到登录界面
        JTLoginViewController *loginVC  =[[JTLoginViewController alloc]init];
        JTBaseNavigationController *nav = [[JTBaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        [self.sideMenuViewController hideMenuViewController];
        
    }else{
        JTMessageCenterViewController *messageVC  =[[JTMessageCenterViewController alloc]init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }
    
}
-(void)leftBarButtonItemEvent{
    [self.sideMenuViewController presentLeftMenuViewController];
}
#pragma mark - collectionDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.nameArray.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
     return UIEdgeInsetsMake(0, 15 *JT_ADAOTER_WIDTH, 0, 15*JT_ADAOTER_WIDTH);//分别为上、左、下、右
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JFMainHeaderNewCollectionViewCell *firstCell = (JFMainHeaderNewCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"priceCollection" forIndexPath:indexPath];
    firstCell.backgroundColor  =[UIColor clearColor];
    [firstCell getHeaderImg:self.imgArray[indexPath.row] nameStr:self.nameArray[indexPath.row]];
    return firstCell;
}
#pragma mark -  collection点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //检查用户是否登录
    JFUserInfoTool *userInfo  =[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.keyStr]) {
        //跳转到登录界面
        JTLoginViewController *loginVC  =[[JTLoginViewController alloc]init];
        JTBaseNavigationController *nav = [[JTBaseNavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        [self.sideMenuViewController hideMenuViewController];
    }else{
        
    if (indexPath.row  ==0) {
        //订单
        JTLoanOrderViewController *loanVC =[[JTLoanOrderViewController alloc]init];
        [self.navigationController pushViewController:loanVC animated:YES];
    }else{
        JTPaymentOrderViewController *payOrderVc  =[[JTPaymentOrderViewController alloc]init];
        [self.navigationController pushViewController:payOrderVc animated:YES];
    }
    }
}
-(void)tangchuangUI{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = .5;
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBGViewGesture)];
    [_bgView addGestureRecognizer:tap];
    
    _popupView =[HomePopupTipsView new];
    _popupView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_popupView];
    _popupView.popupDelegate = self;
    [_popupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(JT_ScreenW - 80 * JT_ADAOTER_WIDTH, 360* JT_ADAOTER_WIDTH));
        make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left).offset(40* JT_ADAOTER_WIDTH);
        make.centerY.equalTo([UIApplication sharedApplication].keyWindow);
    }];
}
-(void)tapBGViewGesture{
    [_bgView removeFromSuperview];
    [_popupView removeFromSuperview];
}
#pragma mark - 关闭弹窗
-(void)closePopupEvent{
    [self tapBGViewGesture];
}

-(UICollectionView *)firstCollection{
    if (!_firstCollection) {
        UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((JT_ScreenW  - 45 ) /2,115 * JT_ADAOTER_WIDTH);
        _firstCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _firstCollection.delegate  =self;
        _firstCollection.dataSource = self;
        //h注册
        [_firstCollection registerClass:[JFMainHeaderNewCollectionViewCell class] forCellWithReuseIdentifier:@"priceCollection"];
       _firstCollection.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
       
    }
    return _firstCollection;
}
-(NSArray *)nameArray{
    if (!_nameArray) {
        _nameArray = @[[JFHSUtilsTool decodeFromPercentEscapeString:credit_order_text],[JFHSUtilsTool decodeFromPercentEscapeString:credit_order_detail_text]];
    }
    return _nameArray;
}
-(NSArray *)imgArray{
    if (!_imgArray) {
        _imgArray = @[@"order",@"repaymentDetail"];
    }
    return _imgArray;
}
-(void)getCodeEventClick{
    
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
