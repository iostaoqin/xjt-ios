//
//  JFNewDeatilCardViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFNewDeatilCardViewController.h"
#import "JFDataCradNewTableViewCell.h"
#import "JFCardNewOtherTableViewCell.h"
@interface JFNewDeatilCardViewController ()<UITableViewDelegate, UITableViewDataSource,selecedCardDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong)UITableView *cardTableView;
@property (nonatomic,  strong)NSMutableArray *cycleImgArr;//轮播图数组
@property (nonatomic ,assign)NSInteger showIndex;
@end

@implementation JFNewDeatilCardViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor  colorWithHexString:@"#F5F5F5"];
    [self addLeftButtonItemWithImage:@"mine_comeBack_img" slected:@"mine_comeBack_img"];
    self.cycleImgArr  = [NSMutableArray array];
    self.showIndex = 0;
    [self  getNewCardData];
    [self  cardTb];
    [self bottomView];
    
}
#pragma mark  -得到creditCard相关信息
-(void)getNewCardData{
    WEAKSELF;
    if ([JFHSUtilsTool isBlankString:self.categoryID]) {
        self.categoryID   =  self.cardModel.categoryId;
    }
    NSString *cardUrl = [NSString stringWithFormat:@"%@/manager/bnh/creditCard/%@",HS_USER_URL,self.categoryID];
    NSDictionary *dic = @{@"os":@"ios",@"appName":app_name_type,@"cityName":self.cityStr};
    NSString *car = [JFHSUtilsTool conectUrl:[dic mutableCopy] url:cardUrl];
    car =  [car stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [PPNetworkHelper GET:car parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //
            JTLog(@"%@",responseObject);
            [self.cycleImgArr removeAllObjects];
            for (NSDictionary *carDic in responseObject[@"creditCards"]) {
                JFThirdNewModel *newCarModel =[JFThirdNewModel mj_objectWithKeyValues:carDic];
                [self.cycleImgArr addObject:newCarModel];
            }
            JFThirdNewModel *newCarModel = self.cycleImgArr[0];
            [self  submitSensorsAnalyty:@"1"shoyModel:newCarModel submitType:@"CreditCardView"];
        }
        [weakSelf.cardTableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark -  第一次进入界面的时候提交神策数据
-(void)submitSensorsAnalyty:(NSString *)posIdx shoyModel:(JFThirdNewModel *)newCarModel submitType:(NSString *)type{
    if (self.cycleImgArr.count) {
        //请求数据成功之后
        NSDictionary *dic = @{@"category_id":self.cardModel.categoryId,@"category_pos":self.categoryIdx,@"category_name":self.cardModel.name,@"credit_card_id":newCarModel.creditId,@"credit_card_url":newCarModel.bankUrl,@"pos":posIdx};
        [JFHSUtilsTool submitSensorsAnalytics:type parameter:dic];
    }
}
-(void)leftBarButtonItemEvent:(id)sender{
    if ([self.whereVC isEqualToString:@"JFUserLoginViewController"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)cardTb{
    _cardTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, JT_NAV, JT_ScreenW, JT_ScreenH   - 80 * JT_ADAOTER_WIDTH-JT_NAV) style:UITableViewStyleGrouped];
    [self.view addSubview:_cardTableView];
    _cardTableView.delegate = self;
    _cardTableView.dataSource = self;
    _cardTableView.scrollEnabled = NO;
    _cardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cardTableView.tableHeaderView  = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];//解决顶部 多出的部分
    _cardTableView.tableFooterView  = [UIView new];
    _cardTableView.backgroundColor =[UIColor clearColor];
    
}
-(void)bottomView{
    UIView *bottomView =[UIView new];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(JT_ScreenW);
        make.height.mas_equalTo(80 * JT_ADAOTER_WIDTH);
        
    }];
    UIButton *applyBtn =[self.view buttonCreateWithNorStr:immediatelyApply_tips_text nomalBgColor:@"#47A3FF" textFont:18 cornerRadius:23];
    [bottomView addSubview:applyBtn];
    [applyBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(290 *  JT_ADAOTER_WIDTH, 46  * JT_ADAOTER_WIDTH));
        make.center.equalTo(bottomView);
    }];
    [applyBtn  addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==   1) {
        return 40;
    }
    return 0.00001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 240;
    }else{
        return 225;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view  = [UIView new];
    view.backgroundColor=  [UIColor  colorWithHexString:@"#F5F5F5"];
    return view;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *footView  = [UIView new];
        footView.backgroundColor=  [UIColor  colorWithHexString:@"#F5F5F5"];
        UILabel *nameLable =[UILabel new];
        [footView addSubview:nameLable];
        nameLable.text  = [JFHSUtilsTool decodeFromPercentEscapeString:card_new_text];
        nameLable.textColor  =[UIColor colorWithHexString:@"#999999"];
        nameLable.font  = kFontSystem(14);
        [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footView);
        }];
        return footView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section  ==0 ) {
        static NSString *cell  =  @"JFDataCradNewTableViewCell";
        JFDataCradNewTableViewCell *cardCell  = [tableView dequeueReusableCellWithIdentifier:cell];
        if (!cardCell) {
            cardCell =[[JFDataCradNewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        }
        cardCell.selectionStyle  = UITableViewCellSelectionStyleNone;
        [cardCell getCycleImd:self.cycleImgArr];
        cardCell.cardDelegate  = self;
        cardCell.sdcycleView.delegate =self;
        return cardCell;
    } else {
        static NSString *cell  =  @"JFCardNewOtherTableViewCell";
        JFCardNewOtherTableViewCell *cardOtherCell  = [tableView dequeueReusableCellWithIdentifier:cell];
        if (!cardOtherCell) {
            cardOtherCell =[[JFCardNewOtherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        }
        cardOtherCell.selectionStyle  = UITableViewCellSelectionStyleNone;
        if (self.cycleImgArr.count) {
            [cardOtherCell getFirstData:self.cycleImgArr showIndx:self.showIndex];;
        }
        
        return cardOtherCell;
    }
}
//#pragma mark  - 滑动事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    [self analyticalCycleData:index];
    //神策事件
    JFThirdNewModel *newCarModel = self.cycleImgArr[index];
    [self submitSensorsAnalyty:[NSString  stringWithFormat:@"%zd",index + 1] shoyModel:newCarModel submitType:@"CreditCardView"];
    
}
#pragma mark - 左点击事件
-(void)leftEventClickIdx:(NSInteger)index{
    JTLog(@"左点击事=%zd",index);
    [self analyticalCycleData:index];
}
#pragma Mark- 右点击事件
-(void)rightEventClickIdx:(NSInteger)index{
    JTLog(@"右点击事件=%zd",index);
    [self analyticalCycleData:index];
}
-(void)analyticalCycleData:(NSInteger)index{
    self.showIndex  = index;
    NSIndexPath *indexPath=  [NSIndexPath indexPathForRow:0 inSection:1];
    JFCardNewOtherTableViewCell *cardDetailCell = (JFCardNewOtherTableViewCell *)[_cardTableView cellForRowAtIndexPath:indexPath];
    [cardDetailCell getFirstData:self.cycleImgArr showIndx:index];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [_cardTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark -立即申请事件
-(void)applyBtnClick{
    JFThirdNewModel *cardModel  = self.cycleImgArr[self.showIndex];;
    NSMutableArray  *temArr  = [NSMutableArray array];
    [temArr addObject:cardModel.creditName];
    [temArr addObject:cardModel.creditId];
    [temArr addObject:@"2"];
    JFWebNewEditViewController *webVC  = [[JFWebNewEditViewController alloc]init];
    webVC.url  = cardModel.bankUrl;
    webVC.webArr  = [temArr mutableCopy];
    [self.navigationController pushViewController:webVC animated:YES];
    //提交申请神策事件
    [self submitSensorsAnalyty:[NSString stringWithFormat:@"%zd",self.showIndex + 1] shoyModel:cardModel submitType:@"CreditCardClick"];
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
