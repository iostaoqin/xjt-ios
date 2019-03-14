//
//  JFGiveDataViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/27.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFGiveDataViewController.h"
#import "JFHomeNewEditTableViewCell.h"


@interface JFGiveDataViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_topBtn;//tableview回滚到顶部
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *giveMarr;
@property(nonatomic, assign)NSInteger selectedSetion;//选中的section
@property (nonatomic, strong)JFDataFooterView *footerView;
@property (nonatomic, strong)UIButton *topBtn;//创建悬浮的button
@property (nonatomic,strong)NSString *posStr;
@property (nonatomic,strong)NSString *areaIdStr;
@end

@implementation JFGiveDataViewController
- (void)loadDataForFirst {
    //第一次才加载，后续触发的不处理
    //    if (!self.isDataLoaded) {
    //        [self requestData:YES];
    //        self.isDataLoaded = YES;
    //    }
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"webSuccessNotice" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshDataNotice" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshFirstDataNotice" object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self  setTableView];
    self.selectedSetion  = 0;
    self.giveMarr = [NSMutableArray array];
    [self dropdownRefreshHeader];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(webVcSuccessedNotion) name:@"webSuccessNotice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshGiveDataNotice:) name:@"refreshDataNotice" object:nil];
    //回滚到顶部
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rallBackFirstData) name:@"refreshFirstDataNotice" object:nil];
    //创建悬浮的button
    self.topBtn.hidden = YES;
}
#pragma mark  - 回滚到顶部事件
-(void)rallBackFirstData{
    //tb回滚 到顶部
    if (self.giveMarr.count) {
        
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
-(void)setTableView{
    _tableView =  [[UITableView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH -kTabBarHeight -  JT_NAV -  flowerHeight -20) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView  = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];//解决顶部 多出的部分
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.tableFooterView =[UIView new];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
}
#pragma mark - tableview回滚到顶部
-(void)rollbackBtn{
    self.topBtn.hidden   = YES;
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == self.giveMarr.count -1) {
    //        return 0.00001;
    //    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.giveMarr.count) {
        if (section  == self.giveMarr.count - 1) {
            if (self.giveMarr.count > 0) {
                return  40;
            }
        }else{
            
            return CGFLOAT_MIN;
        }
    }
    return CGFLOAT_MIN;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.giveMarr.count > 0) {
        return  self.giveMarr.count;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section== self.giveMarr.count  - 1) {
        UIView *footer = [UIView new];
        _footerView = [[JFDataFooterView alloc]init];
        
        [footer addSubview:_footerView];
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footer);
        }];
        return footer;
    }else{
        return nil;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"cellId";
    JFHomeNewEditTableViewCell *dataCell  = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!dataCell) {
        dataCell  =[[JFHomeNewEditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    
    [dataCell getGiveData:self.giveMarr[indexPath.section]];
    dataCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dataCell.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    return dataCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断用户是否获取到剪切板的内容
    //若没有 就跳转到登录界面获取userid 用于神测
    self.selectedSetion  = indexPath.section;
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    
    JFGiveModel *giveModel = self.giveMarr[indexPath.section];
    NSMutableArray  *temArr  = [NSMutableArray array];
    [temArr addObject:giveModel.name];
    [temArr addObject:giveModel.platformId];
    [temArr addObject:@"1"];
    if ([JFHSUtilsTool isBlankString:userInfo.xuserloginIdStr]) {
//        [CLShanYanSDKManager preGetPhonenumber];
        [JFShanYanRequestEditTool requestShanYan:self.temVC jumpToVC:@"JFWebNewEditViewController" jumVCParameter:giveModel.url cityStr:@"" tittlName:@""webArray:[temArr copy]];
    }else{
        
        JFWebNewEditViewController *webVC =  [[JFWebNewEditViewController alloc]init];
        webVC.url  = giveModel.url;
        webVC.webArr  = [temArr copy];
        [webVC setImgBlock:^{
            
        }];
        webVC.hidesBottomBarWhenPushed  = YES;
        [ _temVC.navigationController pushViewController:webVC animated:YES];
    }
    [self getLogData:[NSString stringWithFormat:@"%@",giveModel.platformId] selectedIdx:indexPath.section];
    //提交产品神策数据
    NSDictionary  *dic =  @{@"area_id":self.areaIdStr,@"pos":[NSString stringWithFormat:@"%zd",indexPath.section + 1],@"product_id":giveModel.platformId,@"product_name":giveModel.name,@"product_url":giveModel.url};
    [[SensorsAnalyticsSDK sharedInstance]track:@"ProductClick" withProperties:dic];
    
}
#pragma mark-give大全日志
-(void)getLogData:(NSString *)platformIdStr selectedIdx:(NSInteger)idx{
    [JFSHLogEditTool logRequestCookId:platformIdStr eventTagName:self.giveModel.tagName eventAction: [NSString stringWithFormat:@"%@",self.giveModel.areaId] firstEventValue: [NSString stringWithFormat:@"%@",self.giveModel.pos] secondEventValue:[NSString stringWithFormat:@"%zd",idx]showType:LogShowType_Home];
}
#pragma mark-web界面修改give💕大全界面的section 图标
-(void)webVcSuccessedNotion{
    if (self.giveMarr.count) {
    NSIndexPath *selectedIdx= [NSIndexPath indexPathForRow:0 inSection:self.selectedSetion];
    JFGiveModel *giveModel = self.giveMarr[self.selectedSetion];
    JFHomeNewEditTableViewCell *cell   =(JFHomeNewEditTableViewCell *)[_tableView cellForRowAtIndexPath:selectedIdx];
    NSIndexSet *selectedSetion=[[NSIndexSet alloc]initWithIndex:self.selectedSetion];
    //获取当前日期  年月日时分
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    giveModel.desc1  =[NSString stringWithFormat:@"您%@浏览过",dateStr];
    cell.priceImg.image =[UIImage imageNamed:@"new_img_ts"];
    [self.tableView reloadSections:selectedSetion withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma mark-点击tabbar的 监听事件 提交神策数据 
-(void)refreshGiveDataNotice:(NSNotification *)notice{
    NSDictionary  *dic =  notice.userInfo;
     NSString *decodeKey =[JFHSUtilsTool stringXORDeocodeWithPlainText:second_tab_text secretKey:codeKey];
    if ([dic[@"tab_name"]isEqualToString:decodeKey]) {
        if ([_tableView.mj_header isRefreshing]) {
            JTLog(@"正在刷新");
        }else{
            [self dropdownRefreshHeader];
        }
    }
    
}
#pragma mark - 下拉刷新
-(void)dropdownRefreshHeader{
    __weak JFGiveDataViewController *dataVc  = self;
    _tableView.mj_header  = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        [dataVc getGiveData];
    }];
    [_tableView.mj_header beginRefreshing];
}
-(void)getGiveData{
    WEAKSELF;
    NSString *requstUrl = [NSString stringWithFormat:@"%@/manager/pf/platforms",HS_USER_URL];
    NSDictionary *dic  = @{@"os":@"ios",@"appName":app_name_type,@"areaTagId":self.giveModel.areaTagId};
    //拼接字符串
    NSString *requstStr = [JFHSUtilsTool conectUrl:[dic mutableCopy] url:requstUrl];
    [PPNetworkHelper GET:requstStr parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [self.giveMarr removeAllObjects];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //请求成功
            self.posStr = [NSString  stringWithFormat:@"%@",responseObject[@"areaTags"][0][@"pos"]];
            self.areaIdStr = [NSString  stringWithFormat:@"%@",responseObject[@"areaTags"][0][@"areaId"]];
            for (NSDictionary *loanDic in responseObject[@"areaTags"][0][@"platforms"]) {
                JFGiveModel *giveModel  =[JFGiveModel mj_objectWithKeyValues:loanDic];
                
                [self.giveMarr addObject:giveModel];
            }
            
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark -  监听tableView的 滑动事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.giveMarr.count) {
        if (scrollView.contentOffset.y >=JT_ScreenH) {
            
            self.topBtn.hidden = NO;
        }else{
            self.topBtn.hidden = YES;
        }
    }
}
-(UIButton *)topBtn{
    if (!_topBtn) {
        _topBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_topBtn];
        [_topBtn setImage:[UIImage imageNamed:@"getLocationtop"] forState:UIControlStateNormal];
        [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70 *JT_ADAOTER_WIDTH, 70*JT_ADAOTER_WIDTH));
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight-15);
        }];
        [self.view bringSubviewToFront:_topBtn];
        [_topBtn  addTarget:self action:@selector(rollbackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
}

- (void)listDidDisappear {
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
