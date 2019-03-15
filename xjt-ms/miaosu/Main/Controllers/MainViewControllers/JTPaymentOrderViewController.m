//
//  JTPaymentOrderViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTPaymentOrderViewController.h"
#import "JTDetailOrderTableViewCell.h"
#import "JTLoanOrderTableViewCell.h"
@interface JTPaymentOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSArray *nameArr;
@property (nonatomic, strong)UITableView *paymentOrderTb;
@property (nonatomic, strong)NSMutableArray *payMArr;
@end

@implementation JTPaymentOrderViewController
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
    self.title   = @"续还记录";
    self.view.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
    self.payMArr = [NSMutableArray array];
//
    [self paymentOrderTbUI];
    if (@available(iOS 11.0, *)) {
        _paymentOrderTb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self payOrderListData];
}
#pragma mark - 续还记录数据请求
-(void)payOrderListData{
    NSString *pay_url  = [NSString stringWithFormat:@"%@/xjt/user/latestRepayment",JT_MS_URL];
    JFUserInfoTool *userInfo  =[JFUserManager shareManager].currentUserInfo;
    [PPNetworkHelper setValue:userInfo.keyStr forHTTPHeaderField:@"API_KEY"];
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [PPNetworkHelper GET:pay_url parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            NSArray  *renewArr = responseObject[@"renewalRecords"];
            [self.payMArr removeAllObjects];
            if (renewArr.count  == 0 ) {
                // 此时没有数据 显示占位拖欠
                [self emptyUI];
            }else{
                //正常解析 数据
                for (NSDictionary *payDic in responseObject[@"renewalRecords"]) {
                    JTLoanModel *payModel =[JTLoanModel mj_objectWithKeyValues:payDic];
                    [self.payMArr addObject:payModel];
                }
            }
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeMessage"]];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            });
            if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"2"]) {
                [self againLogin];
            }
        }
        [self.paymentOrderTb  reloadData];
    } failure:^(NSError *error) {
     [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    }];
}
-(void)paymentOrderTbUI{
    self.paymentOrderTb   =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH) style:UITableViewStyleGrouped];
    self.paymentOrderTb.delegate  = self;
    self.paymentOrderTb.dataSource = self;
    [self.view addSubview:self.paymentOrderTb];
    self.paymentOrderTb.tableFooterView  = [UIView new];
    self.paymentOrderTb.backgroundColor  = [UIColor clearColor];
    self.paymentOrderTb.separatorStyle  =UITableViewCellSeparatorStyleNone;
}
-(void)emptyUI{
    JTEmptyView *emptyView  =[JTEmptyView new];
    [self.view addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(105  * JT_ADAOTER_WIDTH);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(120*JT_ADAOTER_WIDTH);
    }];
    [emptyView getEmptyImg:@"paymentOrderEmpty" emptyTitle:@"您没有欠款~"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.payMArr.count) {
        return self.payMArr.count;
    }return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

   return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.payMArr.count) {
        if (section  ==0) {
            return 20;
        }else{
            return 0.0001;
        }
    }return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 45;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.payMArr.count) {
        if (section ==0) {
            UIView *headerView =[UIView new];
            headerView.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
        }return nil;
    }return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (self.payMArr.count) {
//    if (section ==1) {
//    UIView *footerView =[UIView new];
//    footerView.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
//    UIButton *firstBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:343* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
//    [firstBtn setTitle:@"我要续期" forState:UIControlStateNormal];
//    UIButton *secondBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:343* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
//    [secondBtn setTitle:@"立即还款" forState:UIControlStateNormal];
//    [footerView addSubview:firstBtn];
//    [footerView addSubview:secondBtn];
//    if (JT_IS_iPhone5) {
//        firstBtn.titleLabel.font  = kFontSystem(16);
//        secondBtn.titleLabel.font  = kFontSystem(16);
//    }else{
//        firstBtn.titleLabel.font  = kFontSystem(18);
//        secondBtn.titleLabel.font  = kFontSystem(18);
//    }
//    [firstBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(343* JT_ADAOTER_WIDTH, 46* JT_ADAOTER_WIDTH));
//        make.centerX.equalTo(footerView);
//        make.top.equalTo(footerView.mas_top).offset(26* JT_ADAOTER_WIDTH);
//    }];
//    [secondBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(343* JT_ADAOTER_WIDTH, 46* JT_ADAOTER_WIDTH));
//        make.centerX.equalTo(footerView);
//        make.top.equalTo(firstBtn.mas_bottom).offset(13* JT_ADAOTER_WIDTH);
//    }];
//    [firstBtn addTarget:self action:@selector(firstBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [secondBtn addTarget:self action:@selector(secondBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    return footerView;
//    }else{
//        UIView *secondFooterView =[UIView new];
//        secondFooterView.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
//        return secondFooterView;
//    }
//    }
    return nil;
}
#pragma mark - 我要续期
-(void)firstBtnClick{
    
}
-(void)secondBtnClick{
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString  *cell = @"cellID";
    JTDetailOrderTableViewCell *secondCell =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!secondCell) {
        secondCell  =[[JTDetailOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    if (self.payMArr.count) {
        [secondCell getPayLeftData:self.nameArr payModel:self.payMArr[indexPath.section]index:indexPath.row];
    }
    if (indexPath.section==0 &&indexPath.row ==1) {
        secondCell.lineLable.hidden = NO;
    }
    secondCell.selectionStyle =UITableViewCellSelectionStyleNone;
    secondCell.backgroundColor = [UIColor whiteColor];
    return secondCell;
}
-(NSArray *)nameArr{
    if (!_nameArr) {
        _nameArr =@[@[@"还款记录",@"操作时间"],@[@"续期记录",@"操作时间"]];
    }
    return _nameArr;
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
