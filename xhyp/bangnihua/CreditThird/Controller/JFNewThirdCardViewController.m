//
//  JFNewThirdCardViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFNewThirdCardViewController.h"
#import "JFNewDataCollectionViewCell.h"
#import "JFCardTableViewCell.h"
#import "JFNewDeatilCardViewController.h"
#import "TNewMJRefreshAutoNormalFooterEdit.h"
#import "JFCreditCollectionReusableView.h"
static NSInteger pageSize = 10;
@interface JFNewThirdCardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

@property  (nonatomic,  strong)UICollectionView *cardCollectionView;
@property (nonatomic, strong)UITableView *cardTableView;
@property (nonatomic, strong)NSMutableArray *cardArr;
@property (nonatomic, assign)NSInteger page;//分页的页数
@property (nonatomic, strong)NSMutableArray *allCardArr;
@property (nonatomic, strong)NSString *cityStr;
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, assign)BOOL locationYesOrNo;//防止定位成功循环
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic,strong)JFUserInfoTool *userInfo;
@property (nonatomic,  strong)UIButton *comeBackTopBtn;//回滚到顶部
@end

@implementation JFNewThirdCardViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshDataNotice" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"rollbackNotice" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        _cardTableView.estimatedRowHeight = 0;
        _cardTableView.estimatedSectionFooterHeight = 0;
        _cardTableView.estimatedSectionHeaderHeight = 0;
        _cardTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    _userInfo =[JFUserManager shareManager].currentUserInfo;
    self.cardArr =[NSMutableArray array];
    self.allCardArr  =[NSMutableArray array];
    [self setupTableView];
    [self setupCollectionView];
    _page = 1;
    //    [self jamRefreshFooterNew];
    [self jamRefreshHeaderNew];
    self.locationYesOrNo  =  NO;
    [self location];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDataNotice:) name:@"refreshDataNotice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rollbackNoticeEvent) name:@"rollbackNotice" object:nil];
}
#pragma mark  - 回滚到顶部
-(void)rollbackNoticeEvent{
    if (self.view.window == nil) return;
    //判断当前的view是否与窗口重合 nil代表屏幕左上角
    if (![self.view hu_intersectsWithAnotherView:nil]) return;
    [_cardTableView.mj_header beginRefreshing];
}
#pragma mark - 每次点击tabbar都请求数据  提交神策数据 
-(void)refreshDataNotice:(NSNotification *)notice{
    NSDictionary  *dic =  notice.userInfo;
    NSString *third_decodeString = [JFHSUtilsTool decodeFromPercentEscapeString:third_tab_text];
    
    if ([dic[@"tab_name"]isEqualToString:third_decodeString]) {
        if ([_cardTableView.mj_header isRefreshing]) {
            //正在刷新
        }else{
            [self jamRefreshHeaderNew];
        }
    }
    
}
-(void)setupCollectionView{
    UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((JT_ScreenW-1)/2, 85 * JT_ADAOTER_WIDTH);
    flowLayout.minimumLineSpacing  =  1;
    flowLayout.minimumInteritemSpacing  =0;
    UICollectionView *collectionVC = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, 212 * JT_ADAOTER_WIDTH) collectionViewLayout:flowLayout];
    collectionVC.delegate  =self;
    collectionVC.dataSource = self;
    //    collectionVC.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    collectionVC.backgroundColor  = [UIColor  clearColor];
    _cardTableView.tableHeaderView  = collectionVC;
    _cardCollectionView = collectionVC;
    
    
    //h注册
    [_cardCollectionView registerClass:[JFNewDataCollectionViewCell class] forCellWithReuseIdentifier:@"cardCollection"];
    //注册尾部
    [_cardCollectionView registerClass:[JFCreditCollectionReusableView class]forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.cardArr.count) {
        return self.cardArr.count;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JFNewDataCollectionViewCell *cardCell = (JFNewDataCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cardCollection" forIndexPath:indexPath];
    [cardCell getCardModelData:self.cardArr[indexPath.row]];
    cardCell.backgroundColor   = [UIColor whiteColor];
    return cardCell;
}
#pragma mark -增补视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] ) {
        JFCreditCollectionReusableView *footerView;
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        //        footerView.backgroundColor  = [UIColor colorWithHexString:@"#DDDDDD"];
        return footerView;
    }
    
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section{
    if (self.cardArr.count) {
        return CGSizeMake(0, 40 *JT_ADAOTER_WIDTH);
    }return CGSizeMake(0, 0);
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    JFNewDataCollectionViewCell *cell  =(JFNewDataCollectionViewCell *)[_cardCollectionView cellForItemAtIndexPath:index];
    JFThirdNewModel *cardModel  = self.cardArr[indexPath.row];
    if ([JFHSUtilsTool isBlankString:_userInfo.xuserloginIdStr]) {
//        [CLShanYanSDKManager preGetPhonenumber];
        [JFShanYanRequestEditTool requestNewCard:self jumpToVC:@"JFNewDeatilCardViewController" jumVCParameter:cardModel.categoryId categorySelectedIdx:indexPath.row tittlName:cell.nameLable.text categray:cardModel city:[JFHSUtilsTool isBlankString:self.cityStr]?@"":self.cityStr];
    }else{
        JFNewDeatilCardViewController *newVC = [[JFNewDeatilCardViewController alloc]init];
        newVC.hidesBottomBarWhenPushed  = YES;
        newVC.title =  cell.nameLable.text;
        newVC.cardModel  = cardModel;
        newVC.categoryIdx  = [NSString stringWithFormat:@"%zd",indexPath.row + 1];
        newVC.cityStr  =[JFHSUtilsTool isBlankString:self.cityStr]?@"":self.cityStr;
        [self.navigationController pushViewController:newVC animated:YES];
    }
    JTLog(@"indexPath.row=%zd",indexPath.row);
    [self getLogRequestData:cardModel selecedIdx:indexPath.row + 1 showType:@"1"];
    
}
#pragma mark -提交日志参数 及提交神策数据
-(void)getLogRequestData:(JFThirdNewModel *)logModel selecedIdx:(NSInteger)idx showType:(NSString *)show{
    if ([show isEqualToString:@"1"]) {

        [JFSHLogEditTool logRequestCookId:@"" eventTagName:logModel.name eventAction:@"" firstEventValue:logModel.categoryId secondEventValue:[NSString  stringWithFormat:@"%zd",idx] showType:LogShowType_Card];
        NSDictionary *dic=  @{@"category_id":logModel.categoryId,@"category_pos":[NSString  stringWithFormat:@"%zd",idx],@"category_name":logModel.name};
        [JFHSUtilsTool submitSensorsAnalytics:@"CreditCardCategoryClick" parameter:dic];
    }else{
        [JFSHLogEditTool logRequestCookId:@"" eventTagName:logModel.creditName eventAction:@"" firstEventValue:logModel.creditId secondEventValue:[NSString  stringWithFormat:@"%zd",idx] showType:LogShowType_Card];
        //提交神策数据
        NSDictionary *dic=  @{@"credit_card_id":logModel.creditId,@"pos":[NSString  stringWithFormat:@"%zd",idx],@"credit_card_url":logModel.bankUrl,@"credit_card_url":logModel.bankUrl};
        //立即申请
        [JFHSUtilsTool submitSensorsAnalytics:@"CreditCardClick" parameter:dic];
    }
    
    
}
#pragma mark - tableview
-(void)setupTableView{
    
    _cardTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, JT_NAV, JT_ScreenW, JT_ScreenH   -  kTabBarHeight -JT_NAV) style:UITableViewStyleGrouped];
    [self.view addSubview:_cardTableView];
    
    _cardTableView.delegate  = self;
    _cardTableView.dataSource = self;
    _cardTableView.tableFooterView = [UIView new];
    _cardTableView.backgroundColor = [UIColor clearColor];
    _cardTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.allCardArr.count) {
        return self.allCardArr.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130   *JT_ADAOTER_WIDTH ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section  == 0) {
        return 0.0001;
    }
    return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell  = @"cellID";
    JFCardTableViewCell *cardCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!cardCell) {
        cardCell = [[JFCardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    cardCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cardCell.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [cardCell getCradModelData:self.allCardArr[indexPath.section]];
    return cardCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    JFThirdNewModel *cardModel  =self.allCardArr[indexPath.section];
    NSMutableArray  *temArr  = [NSMutableArray array];
    [temArr addObject:cardModel.creditName];
    [temArr addObject:cardModel.creditId];
    [temArr addObject:@"2"];
    if ([JFHSUtilsTool isBlankString:_userInfo.xuserloginIdStr]) {
//        [CLShanYanSDKManager preGetPhonenumber];
        [JFShanYanRequestEditTool requestShanYan:self jumpToVC:@"JFWebNewEditViewController" jumVCParameter:cardModel.bankUrl cityStr:@""tittlName:@""webArray:[temArr copy]];
    }else{
        JFWebNewEditViewController *webVC =[[JFWebNewEditViewController alloc]init];
        webVC.url = cardModel.bankUrl;
        webVC.webArr  = [temArr copy];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    [self  getLogRequestData:cardModel selecedIdx:indexPath.section + 1 showType:@"2"];
}

-(void)jamRefreshHeaderNew  {
    WEAKSELF;
    _cardTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf jamHeaderRefresh];
    }];
    [_cardTableView.mj_header beginRefreshing];
}
- (void)jamRefreshFooterNew {
    WEAKSELF;
    //    TNewMJRefreshAutoNormalFooterEdit *footerRefresh = [TNewMJRefreshAutoNormalFooterEdit footerWithRefreshingBlock:^{
    //        [weakSelf jamDownloadMore];
    //
    //    }];
    //    _cardTableView.mj_footer = footerRefresh;
    
    //    __weak JFNewThirdCardViewController *recentVC = self;
    //    _cardTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [weakSelf jamDownloadMore];
    //    }];
    MJRefreshAutoNormalFooter *footer  =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf jamDownloadMore];
    }];
    [footer setTitle:load_text_tips forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _cardTableView.mj_footer = footer;
    
}


- (void)jamHeaderRefresh {
    self.semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    WEAKSELF;
    dispatch_group_async(group, queue, ^{
        //请求1
        [weakSelf requestCardData];
    });
    dispatch_group_async(group, queue, ^{
        //请求2
        weakSelf.page= 1;
        [weakSelf getCradData:weakSelf.page isRefrash:YES];
    });
    dispatch_group_notify(group, queue, ^{
        
        dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            JTLog(@"任务均完成，刷新界面");
            [weakSelf.cardTableView reloadData];
            [weakSelf.cardCollectionView reloadData];
        });
        
    });
    
}
- (void)jamDownloadMore {
    [self getCradData:self.page isRefrash:NO];
}
-(void)getCradData:(NSInteger)pageNumber isRefrash:(BOOL)update{
    WEAKSELF;
    NSString *cardUrl = [NSString stringWithFormat:@"%@/manager/bnh/creditCardList",HS_USER_URL];
    NSDictionary *dic=  @{@"pageNo":[NSString stringWithFormat:@"%zd",pageNumber],@"pageSize":[NSString stringWithFormat:@"%zd",pageSize]};
    NSDictionary *userDic=  @{@"os":@"ios",@"appName":app_name_type};
    NSString *url   =[JFHSUtilsTool conectUrl:[userDic  mutableCopy] url:cardUrl];
    [PPNetworkHelper GET:url parameters:dic success:^(id responseObject) {
        JTLog(@"列表数据=%@",responseObject);
        //这里是记录 是刷新请求 是 走信号量的判断
        if (update ) {
            dispatch_semaphore_signal(self.semaphore);
        }
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //获取当前的pages 用于判断是否还需要请求下一页数据 后台@写的牛逼
            JTLog(@"最终页数=%@",responseObject[@"pageInfo"][@"pages"]);
            NSInteger allPages  = [responseObject[@"pageInfo"][@"pages"] integerValue];
            
            if (update) {
                [weakSelf.allCardArr removeAllObjects];
                //                weakSelf.page = 1;
                //                if (weakSelf.cardTableView.mj_footer.state == MJRefreshStateNoMoreData ) {
                //                }
                [weakSelf jamRefreshFooterNew];
                //                weakSelf.cardTableView.mj_footer.hidden  = YES;
            }
            
            JTLog(@"页数增加=%zd",weakSelf.page);
            for (NSDictionary *allCardDic in responseObject[@"pageInfo"][@"list"]) {
                
                JFThirdNewModel *cardModel = [JFThirdNewModel mj_objectWithKeyValues:allCardDic];
                [self.allCardArr addObject:cardModel];
                
            }
            [weakSelf.cardTableView.mj_header endRefreshing];
            [weakSelf.cardTableView.mj_footer endRefreshing];
            if (allPages <= self.page) {
                [weakSelf.cardTableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (update == NO) {
                //代表是 加载更多 不需要信号量的请求
                [weakSelf.cardTableView reloadData];
            }
            //            weakSelf.cardTableView.mj_footer.hidden  = NO;
            weakSelf.page ++;
            
        }else {
            //提示错误信息 记录
            [[JFHudMsgTool  shareHusMsg]msgHud:MBProgressHUDModeText msgStr: responseObject[@"resultCodeDesc"]];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            [weakSelf.cardTableView.mj_header endRefreshing];
            [weakSelf.cardTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [weakSelf.cardTableView.mj_header endRefreshing];
        if (weakSelf.cardTableView.mj_footer.state == MJRefreshStateNoMoreData ) {
            
        }else {
            [weakSelf.cardTableView.mj_footer endRefreshing];
        }
        //这里是记录 是刷新请求 是 走信号量的判断
        if (update ) {
            dispatch_semaphore_signal(self.semaphore);
        }
    }];
}
#pragma mark- 请求数据
-(void)requestCardData{
    WEAKSELF;
    NSString *cardUrl  = [NSString stringWithFormat:@"%@/manager/bnh/cardCategorieList",HS_USER_URL];
    [PPNetworkHelper GET:cardUrl parameters:nil success:^(id responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //请求成功
            [weakSelf.cardArr removeAllObjects];
            for (NSDictionary *cardDic in responseObject[@"cardCategories"]) {
                JFThirdNewModel *cardModel =[JFThirdNewModel mj_objectWithKeyValues:cardDic];
                [weakSelf.cardArr addObject:cardModel];
            }
            dispatch_semaphore_signal(weakSelf.semaphore);
        }else {
            //这里应该提示 错误信息
            dispatch_semaphore_signal(weakSelf.semaphore);
        }
        // [weakSelf.cardCollectionView reloadData];
    } failure:^(NSError *error) {
        //这里应该提示 错误信息
        dispatch_semaphore_signal(weakSelf.semaphore);
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
                weakSelf.cityStr = city;
            }
        }];
    }
    
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
