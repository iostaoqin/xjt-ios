//
//  JFEditHomeView.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/6.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFEditHomeView.h"
#import "JFHomeNewEditTableViewCell.h"
@interface JFEditHomeView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, assign)NSInteger selectedSetion;
@property (nonatomic,strong)NSString *posStr;
@property (nonatomic,strong)NSString *areaIdStr;
@end

@implementation JFEditHomeView
-(void)dealloc{
    self.scrollCallback = nil;
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"webSuccessNotice" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshDataNotice" object:nil];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isHeaderRefreshed = NO;
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - kTabBarHeight) style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor clearColor];
          self.tableView.tableHeaderView  = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];//解决顶部 多出的部分
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [UIView new];
        [self addSubview:self.tableView];
        self.giveMarr =  [NSMutableArray array];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(webVcSuccessedNotion) name:@"webSuccessNotice" object:nil];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshHomeDataNotice:) name:@"refreshDataNotice" object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}
-(void)setIsNeedHeader:(BOOL)isNeedHeader{
    WEAKSELF;
    _isNeedHeader =  isNeedHeader;
    if (self.isNeedHeader) {
        self.tableView.mj_header  =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
        }];
    }else{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_header removeFromSuperview];
        self.tableView.mj_header = nil;
    }
}
-(void)setIsNeedFooter:(BOOL)isNeedFooter{
    WEAKSELF;
    _isNeedFooter = isNeedFooter;
    if (self.isNeedFooter) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
            });
        }];
    }else {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer removeFromSuperview];
        self.tableView.mj_footer = nil;
    }
}
#pragma mark - 下拉刷新
-(void)dropdownRefreshHeader{
    if (!self.isHeaderRefreshed) {
           [self beginRefreshImmediately];
    }
    
}
-(void)beginRefreshImmediately{
    if (self.isNeedHeader) {
        [self.tableView.mj_header beginRefreshing];
        [self getGiveData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isHeaderRefreshed = YES;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    }else {
        self.isHeaderRefreshed = YES;
        [self.tableView reloadData];
    }
}
#pragma mark  - tabbr点击事件刷新数据 提交神策数据
-(void)refreshHomeDataNotice:(NSNotification *)notice{
    //tabbar的追中事件 tab_name
    NSDictionary  *dic =  notice.userInfo;
    if ([dic[@"tab_name"]isEqualToString:first_tab_text]) {

        [self getGiveData];
    }
    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    
    
}
-(void)getGiveData{
    WEAKSELF;
    NSString *requstUrl = [NSString stringWithFormat:@"%@/manager/pf/platforms",HS_USER_URL];
    NSDictionary *dic  = @{@"os":@"ios",@"appName":app_name_type,@"areaTagId":self.homeModel.areaTagId};
    //拼接字符串
    NSString *requstStr = [JFHSUtilsTool conectUrl:[dic mutableCopy] url:requstUrl];
    [PPNetworkHelper GET:requstStr parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        [self.giveMarr removeAllObjects];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //请求成功
            [self.giveMarr removeAllObjects];
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
#pragma mark - UITableViewDataSource, UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.00001;
    }
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell  = @"cellId";
    JFHomeNewEditTableViewCell *dataCell  = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!dataCell) {
        dataCell  =[[JFHomeNewEditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    
    [dataCell getGiveData:self.giveMarr[indexPath.section]];
//    dataCell.logoImg.transform = CGAffineTransformMakeScale(0, 0);
    dataCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dataCell.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    return dataCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JFGiveModel *giveModel = self.giveMarr[indexPath.section];
    JFUserInfoTool *userInfo  =[JFUserManager  shareManager].currentUserInfo;
    self.selectedSetion  = indexPath.section;
    NSMutableArray  *temArr  = [NSMutableArray array];
    [temArr addObject:giveModel.name];
    [temArr addObject:giveModel.platformId];
    [temArr addObject:@"1"];
    if ([JFHSUtilsTool isBlankString:userInfo.xuserloginIdStr]) {
        [JFShanYanRequestEditTool requestShanYan:_temVC jumpToVC:@"JFWebNewEditViewController" jumVCParameter: giveModel.url cityStr:@"" tittlName:@""webArray:[temArr copy]];
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
    //提交神策数据
    NSDictionary  *dic =  @{@"area_id":self.areaIdStr,@"pos":[NSString stringWithFormat:@"%zd",indexPath.section + 1],@"product_id":giveModel.platformId,@"product_name":giveModel.name,@"product_url":giveModel.url};
    [[SensorsAnalyticsSDK sharedInstance]track:@"ProductClick" withProperties:dic];
}
-(void)getLogData:(NSString *)platformIdStr selectedIdx:(NSInteger)idx{
    [JFSHLogEditTool logRequestCookId:platformIdStr eventTagName:self.homeModel.tagName eventAction: [NSString stringWithFormat:@"%@",self.homeModel.areaId] firstEventValue: [NSString stringWithFormat:@"%@",self.homeModel.pos] secondEventValue:[NSString stringWithFormat:@"%zd",idx]showType:LogShowType_Home];
}
#pragma mark-web界面修改💕界面的section 图标
-(void)webVcSuccessedNotion{
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
}


#pragma mark - JXPagingViewListViewDelegate

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self;
}
@end
