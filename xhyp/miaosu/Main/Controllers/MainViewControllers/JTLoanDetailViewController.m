//
//  JTLoanDetailViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTLoanDetailViewController.h"
#import "JTDetailOrderTableViewCell.h"
@interface JTLoanDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *detailTb;
@property (nonatomic, strong)NSArray *nameArr;
@end

@implementation JTLoanDetailViewController
-(void)leftBarButtonItemEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  = @"订单详情";
    self.view.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
    [self addRightButtonItemWithImage:[JFHSUtilsTool decodeFromPercentEscapeString:loan_agreement_text] selected:@"title"];
    [self loanDetailTbUI];
    if (@available(iOS 11.0, *)) {
        _detailTb.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
-(void)loanDetailTbUI{
    self.detailTb   =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH) style:UITableViewStyleGrouped];
    self.detailTb.delegate  = self;
    self.detailTb.dataSource = self;
//    self.detailTb.tableHeaderView  = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];//解决顶部 多出的部分
    [self.view addSubview:self.detailTb];
    self.detailTb.tableFooterView  = [UIView new];
    self.detailTb.backgroundColor  = [UIColor clearColor];
    self.detailTb.separatorStyle  =UITableViewCellSeparatorStyleNone;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*JT_ADAOTER_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 95*JT_ADAOTER_WIDTH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120 *JT_ADAOTER_WIDTH;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString  *cell = @"cellID";
    JTDetailOrderTableViewCell *detailCell =[tableView dequeueReusableCellWithIdentifier:cell];
    if (!detailCell) {
        detailCell  =[[JTDetailOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    if (indexPath.row == 2) {
        detailCell.lineLable.hidden = NO;
    }
    detailCell.selectionStyle =UITableViewCellSelectionStyleNone;
    [detailCell getNameLeftStr:self.nameArr[indexPath.row]rightDetailStr:@""];
    
    return detailCell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =[UIView new];
    headerView.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
    UILabel *titleNameLable =[UILabel new];
    [headerView addSubview:titleNameLable];
    titleNameLable.text  = @"已放款";
    titleNameLable.textColor =[UIColor colorWithHexString:@"#333333"];
    
    [titleNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(16  *JT_ADAOTER_WIDTH);
        make.top.equalTo(headerView.mas_top).offset(16  *JT_ADAOTER_WIDTH);
    }];
    UILabel *detailNameLabel =[UILabel new];
    [headerView addSubview:detailNameLabel];
    detailNameLabel.textColor  =[UIColor colorWithHexString:@"#666666"];
    detailNameLabel.numberOfLines  = 0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; // 行间距设置为30
    [paragraphStyle setLineSpacing:6];
    NSString *testString = [JFHSUtilsTool decodeFromPercentEscapeString:loan_detail_text];
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    detailNameLabel.attributedText  =setString;
    if (JT_IS_iPhone5) {
        titleNameLable.font  =kFontSystem(14);
        detailNameLabel.font  =kFontSystem(11);
    }else{
        titleNameLable.font  = kFontSystem(16);
        detailNameLabel.font  =kFontSystem(13);
    }
    [detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleNameLable);
        make.right.equalTo(headerView.mas_right).offset(-16 *JT_ADAOTER_WIDTH);
        make.top.equalTo(titleNameLable.mas_bottom).offset(10 *JT_ADAOTER_WIDTH);
    }];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView =[UIView new];
     footerView.backgroundColor =[UIColor colorWithHexString:@"F5F5F5"];
    UIButton *firstBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:343* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
    [firstBtn setTitle:@"我要续期" forState:UIControlStateNormal];
    UIButton *secondBtn =[self.view buttonCreateGradientWithCornerRadius:6 btnWidth:343* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
    [secondBtn setTitle:@"立即还款" forState:UIControlStateNormal];
    [footerView addSubview:firstBtn];
     [footerView addSubview:secondBtn];
    if (JT_IS_iPhone5) {
      firstBtn.titleLabel.font  = kFontSystem(16);
        secondBtn.titleLabel.font  = kFontSystem(16);
    }else{
         firstBtn.titleLabel.font  = kFontSystem(18);
        secondBtn.titleLabel.font  = kFontSystem(18);
    }
    [firstBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343* JT_ADAOTER_WIDTH, 46* JT_ADAOTER_WIDTH));
        make.centerX.equalTo(footerView);
        make.top.equalTo(footerView.mas_top).offset(13* JT_ADAOTER_WIDTH);
    }];
    [secondBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(343* JT_ADAOTER_WIDTH, 46* JT_ADAOTER_WIDTH));
        make.centerX.equalTo(footerView);
        make.top.equalTo(firstBtn.mas_bottom).offset(13* JT_ADAOTER_WIDTH);
    }];
    [firstBtn addTarget:self action:@selector(firstBtnClick) forControlEvents:UIControlEventTouchUpInside];
     [secondBtn addTarget:self action:@selector(secondBtnClick) forControlEvents:UIControlEventTouchUpInside];
    return footerView;
}
#pragma mark - 我要续期 
-(void)firstBtnClick{
    
}
-(void)secondBtnClick{
    
}
-(NSArray *)nameArr{
    if (!_nameArr) {
        _nameArr =@[@"订单编号",@"申请日期",@"设备名称",@"借款金额",@"到账卡号",@"借款期限",@"借款期限",@"借款到期日",@"还款金额"];
    }
    return _nameArr;
}
-(void)rightBarButtonItemEvent:(id)sender{
    //协议
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
