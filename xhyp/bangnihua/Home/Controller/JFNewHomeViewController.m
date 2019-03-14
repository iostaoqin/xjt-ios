//
//  JFNewHomeViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFNewHomeViewController.h"
#import "JFNewHeaderEditView.h"
#import "JFHeaderNewCollectionViewCell.h"
#import "JFNewHeaderCollectionReusableViewEdit.h"
#import "JFHomeNewEditTableViewCell.h"
#import "JFBigNewEditViewController.h"
#import "JFEditSucessViewController.h"
#import "JFGiveDataViewController.h"
#import "JFEditHomeView.h"
#import "JFPagerViewEdit.h"
#import "JFNewHomeEditCycleView.h"
#import "JFEditHomeSecondNewCollectionViewCell.h"
static const CGFloat JXheightForHeaderInSection = 40 ;
@interface JFNewHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JXCategoryViewDelegate,JFPagerViewEditDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong)UITableView  *homeTabelView;
@property (nonatomic, strong)UIView *headerView;
/**最新口子**/
@property (nonatomic, strong)JFNewHeaderEditView *firstHeaderView;
/***轮播图**/
@property (nonatomic, strong)JFNewHomeEditCycleView *cycleView;

@property (nonatomic, strong)UICollectionView *firstCollectionView;
@property (nonatomic, strong)NSArray *nameArray;
@property (nonatomic, strong)NSArray *imgArray;
@property (nonatomic, strong)UICollectionView *secondCollectionView;
/* 身份证*/
@property (nonatomic, strong)NSMutableArray *secondAtrray;
/*最新口子 轮播图*/
@property (nonatomic, strong)NSMutableArray *latestCycleArray;
/*最新口子*/
@property (nonatomic, strong)NSMutableArray *latestArray;
/*今日推荐部分*/
@property (nonatomic, strong)NSMutableArray *recommendationArr;
@property (nonatomic,strong)JFPagerViewEdit  *pageingView;

@property (nonatomic, strong)JXCategoryTitleView *categoryView;
@property (nonatomic, assign)CGFloat JXTableHeaderViewHeight;
@property (nonatomic, strong)NSString *headerShowType;//最新口子和轮播图
/*web数据 */
@property (nonatomic, strong)NSMutableArray *webArr;
/*💕Super数据提交神策 */
@property (nonatomic, strong)NSMutableArray *policyArr;
@property (nonatomic, strong)UILabel *otherNameLable;
@property (nonatomic, assign)BOOL  isrequestSuccess;//
@end

@implementation JFNewHomeViewController
-(void)dealloc{

     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hongbaoAction" object:nil];
      [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshDataNotice" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //d发送通知给红包动画
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hongbaoAction" object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"jxUserInfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    self.view.backgroundColor  = [UIColor colorWithHexString:@"#F5F5F5"];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.isNeedHeader = YES;
    self.isNeedFooter = NO;
    self.isrequestSuccess  = YES;
    self.secondAtrray  = [NSMutableArray array];
    self.latestArray = [NSMutableArray array];
    self.latestCycleArray= [NSMutableArray array];
    self.recommendationArr  = [NSMutableArray array];
    self.webArr  = [NSMutableArray array];
    self.policyArr=  [NSMutableArray  array];
    //
    [self cycleAndVestbagData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshHomeDataNotice:) name:@"refreshDataNotice" object:nil];
    
}
-(void)refreshHomeDataNotice:(NSNotification *)notice{
    //回到顶部
    NSDictionary  *dic =  notice.userInfo;
    if ([dic[@"tab_name"]isEqualToString:first_tab_text]) {
         [self.categoryView selectItemAtIndex:0];
//        [self cycleAndVestbagData];
    }
//    if (self.headerView.window == nil) return;
//    //判断当前的view是否与窗口重合 nil代表屏幕左上角
//    if (![self.headerView hu_intersectsWithAnotherView:nil]) return;
//
    
    
    
}
#pragma mark  - 头部布局
-(void)headerUI:(NSString *)showType{
    //    WEAKSELF;
    /**请求总接口**/
    [self requestAllData];
    self.headerShowType   = showType;
    if ([showType  isEqualToString:home_show_cycleOrLatestProducts_text]) {
        //显示最新口子布局
        [self.cycleView removeFromSuperview];
        _JXTableHeaderViewHeight = 310 *JT_ADAOTER_WIDTH;
        self.headerView.frame  = CGRectMake(0, 0, JT_ScreenW, _JXTableHeaderViewHeight  *JT_ADAOTER_WIDTH);
        /**头部倒计时部分**/
         [_headerView addSubview:self.firstHeaderView];
    }else{
        //轮播图
        [self.firstHeaderView removeFromSuperview];
        _JXTableHeaderViewHeight  = 390*JT_ADAOTER_WIDTH;
        self.headerView.frame  = CGRectMake(0, 0, JT_ScreenW, _JXTableHeaderViewHeight  *JT_ADAOTER_WIDTH);
        /**轮播图部分**/
       [_headerView addSubview:self.cycleView];
    }
    /** give_card_text  big_give_text**/
    [self setupFirstCollecton:showType];
  
    [self setupSecondCollecton];
   
}
#pragma mark -  今日推荐布局
-(void)recommendationUI{
    if (self.recommendationArr.count) {
        NSMutableArray *temArr  = [NSMutableArray array];
        [self.recommendationArr enumerateObjectsUsingBlock:^(JFEditHomemodel *giveModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [temArr addObject:giveModel.tagName];
        }];
        [self.view  addSubview:self.pageingView];
    
        self.categoryView.titles = [temArr copy];
        _categoryView.contentScrollView = self.pageingView
        .listContainerView.collectionView;
        [self.otherNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.categoryView.mas_left).offset(300 * JT_ADAOTER_WIDTH);
            make.right.equalTo(self.categoryView.mas_right).offset(-10*JT_ADAOTER_WIDTH);
            make.top.bottom.equalTo(self.categoryView);
        }];
        
    }
}
-(void)setupFirstCollecton:(NSString *)showType{
    WEAKSELF;
    [_headerView addSubview:self.firstCollectionView];
     [_firstCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.headerView);
        make.height.mas_equalTo(110 * JT_ADAOTER_WIDTH);
    }];
    if ([showType isEqualToString:home_show_cycleOrLatestProducts_text]) {
        [_firstCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.firstHeaderView.mas_bottom).offset(-10*JT_ADAOTER_WIDTH);
        }];
    }else{
        [_firstCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.cycleView.mas_bottom).offset(-10*JT_ADAOTER_WIDTH);
        }];
    }
}
-(void)setupSecondCollecton{
    WEAKSELF;
    [_headerView addSubview:self.secondCollectionView];
    [_secondCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.headerView);
        make.height.mas_equalTo(110  * JT_ADAOTER_WIDTH);
        make.top.equalTo(weakSelf.firstCollectionView.mas_bottom);
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.pageingView.frame = self.view.bounds;
}
#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JFPagerViewEdit *)pagerView {
    return self.headerView;
}
- (NSUInteger)tableHeaderViewHeightInPagerView:(JFPagerViewEdit *)pagerView {
    return _JXTableHeaderViewHeight;
}
- (NSUInteger)heightForPinSectionHeaderInPagerView:(JFPagerViewEdit *)pagerView {
    return JXheightForHeaderInSection  *JT_ADAOTER_WIDTH;
}
- (UIView *)viewForPinSectionHeaderInPagerView:(JFPagerViewEdit *)pagerView {
    return self.categoryView;
}
-(NSInteger)numberOfListsInPagerView:(JFPagerViewEdit *)pagerView{
    if (self.recommendationArr.count) {
        
        return self.recommendationArr.count;
    }return 0;
}
-(id<JFPagerViewEditListViewDelegate>)pagerView:(JFPagerViewEdit *)pagerView initListAtIndex:(NSInteger)index{
    JFEditHomeView *homeVC = [[JFEditHomeView alloc]init];
    homeVC.temVC = self;
    JFEditHomemodel *homeModel =self.recommendationArr[index];
    homeVC.homeModel  = homeModel;
    homeVC.isNeedFooter  =self.isNeedFooter;
    homeVC.isNeedHeader  = self.isNeedHeader;
    [homeVC dropdownRefreshHeader];
    return homeVC;
}
#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickedItemContentScrollViewTransitionToIndex:(NSInteger)index {
    [self.pageingView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}
#pragma mark - collectionDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView  == _firstCollectionView) {
        
        return self.nameArray.count;
    }else{
   
        if (self.secondAtrray.count) {
            return self.secondAtrray.count;
        }
        return 0;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == _firstCollectionView) {
        
        return UIEdgeInsetsMake(0, 15 *JT_ADAOTER_WIDTH, 0, 15*JT_ADAOTER_WIDTH);//分别为上、左、下、右
    }else{
        return UIEdgeInsetsZero;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _firstCollectionView) {
        JFHeaderNewCollectionViewCell *firstCell = (JFHeaderNewCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"priceCollection" forIndexPath:indexPath];
        firstCell.backgroundColor  =[UIColor clearColor];
        [firstCell getHeaderImg:self.imgArray[indexPath.row] nameStr:self.nameArray[indexPath.row]];
        return firstCell;
    } else {
        JFEditHomeSecondNewCollectionViewCell *secondCell = (JFEditHomeSecondNewCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"secondCollection" forIndexPath:indexPath];
        
        secondCell.headerImg.backgroundColor  = [UIColor clearColor];
     
        [secondCell getSecondData:self.secondAtrray[indexPath.row]];
        return secondCell;
    }
}
#pragma mark-  查看更多
-(void)checkMoreGesture{
    //判断用户是否获取到剪切板的内容
    //若没有 就跳转到登录界面获取userid 用于神测
       self.tabBarController.selectedIndex  = 1;
}
#pragma mark -增补视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && collectionView == _firstCollectionView) {
        JFNewHeaderCollectionReusableViewEdit *headerView;
        if (indexPath.section == 0) {
            headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        }
        headerView.backgroundColor  = [UIColor clearColor];
        return headerView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section{
    if (collectionView == _firstCollectionView) {
        return CGSizeMake(0, 40 * JT_ADAOTER_WIDTH);
    } else {
        return CGSizeMake(0, 0);
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _firstCollectionView) {
        JFHeaderNewCollectionViewCell *firstCell = (JFHeaderNewCollectionViewCell *)[_firstCollectionView cellForItemAtIndexPath:indexPath];
        JFUserInfoTool *userInfo  = [JFUserManager shareManager].currentUserInfo;
        if (indexPath.row == 2) {
            //检查用户是否登录
            //1.没有登录 走闪验 或者手机验证码
            //big_give_text
            if ([JFHSUtilsTool isBlankString:userInfo.loginSuccessKey]) {
                //yes  代表用户 没有 登录
//                [CLShanYanSDKManager preGetPhonenumber];
                [JFShanYanRequestEditTool requestShanYan:self jumpToVC:@"JFBigNewEditViewController" jumVCParameter:@""cityStr:@"" tittlName:@""webArray:@[]];
            }else{
                if (self.isrequestSuccess) {
                        [self creatBigLoanData:firstCell.nameLable.text  selectedIdx:indexPath.row];
                    self.isrequestSuccess = NO;
                }
           
                
            }
        }else{
            self.tabBarController.selectedIndex  = indexPath.row + 1;
            if (indexPath.row ==1) {
                //give_card_text money 
                [self submitHomeSensorsAnalyties:@"1001" businessName:firstCell.nameLable.text businessTab:@"JFNewThirdCardViewController" posIdx:[NSString stringWithFormat:@"%zd",indexPath.row + 1] gotoSuccess:@"1"];
                //发送 通知  给办creditCard  回滚到顶部
                [[NSNotificationCenter defaultCenter]postNotificationName:@"rollbackNotice" object:nil];
                
            }else{
             
                [self submitHomeSensorsAnalyties:@"1000" businessName:firstCell.nameLable.text businessTab:@"JFGiveDataViewController" posIdx:[NSString stringWithFormat:@"%zd",indexPath.row + 1] gotoSuccess:@"1"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshFirstDataNotice" object:nil];
            }
        }
    }else{
        JFEditHomemodel *model  =self.secondAtrray[indexPath.row];
        //判断用户是否获取到剪切板的内容
        //若没有 就跳转到登录界面获取userid 用于神测
        //请求对应的接口  获取webURL
        [self getSecondCollection:model.areaId areaTagId:model.areaTagId selected:indexPath.row];
    }
}
-(void)submitHomeSensorsAnalyties:(NSString *)businessId businessName:(NSString *)name  businessTab:(NSString  *)tabVC  posIdx:(NSString *)pos gotoSuccess:(NSString *)gotoStr{
    NSDictionary *dic =  @{@"business_id":businessId,@"business_name":name,@"business_tab":tabVC,@"pos":pos,@"goto_success":gotoStr};
    [JFHSUtilsTool submitSensorsAnalytics:@"BusinessClick" parameter:dic];
}
#pragma mark -  请求总接口  
-(void)requestAllData{
    WEAKSELF;
    NSString  *allUrl  = [NSString stringWithFormat:@"%@/manager/pf/loanTags",HS_USER_URL];
    NSDictionary *userDic=  @{@"os":@"ios",@"appName":app_name_type};
    NSString *url   =[JFHSUtilsTool conectUrl:[userDic  mutableCopy] url:allUrl];
    [PPNetworkHelper GET:url parameters:@{} success:^(id responseObject) {
        JTLog(@"%@",responseObject);
         [self.secondAtrray removeAllObjects];//清空数组
        [self.latestCycleArray removeAllObjects];
        [self.recommendationArr removeAllObjects];
        if ([[NSString  stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            //请求成功
            //处理areaId  为201以后的数据
            for (NSDictionary  *homeDic in responseObject[@"areaTags"]) {
                if ([[NSString stringWithFormat:@"%@",homeDic[@"areaId"]]isEqualToString:@"201"]||[[NSString stringWithFormat:@"%@",homeDic[@"areaId"]]isEqualToString:@"202"]) {
                    //存入model  最新口子
                    JFEditHomemodel *model = [JFEditHomemodel mj_objectWithKeyValues:homeDic];
                    [self.latestCycleArray addObject:model];
                }
                //解析身份证 黑户专享  部分数据
               
                if ([[NSString stringWithFormat:@"%@",homeDic[@"areaId"]]isEqualToString:@"203"]) {
                    JFEditHomemodel *secondModel = [JFEditHomemodel mj_objectWithKeyValues:homeDic];
                    [self.secondAtrray addObject:secondModel];
                }
                //解析今日推荐部分 areaId 204
                if ([[NSString stringWithFormat:@"%@",homeDic[@"areaId"]]isEqualToString:@"204"]) {
                    JFEditHomemodel *thirdModel = [JFEditHomemodel mj_objectWithKeyValues:homeDic];
                    [self.recommendationArr addObject:thirdModel];
                }
            }
            [self recommendationUI];
            //刷新数据
            [weakSelf.secondCollectionView reloadData];
            [weakSelf.homeTabelView reloadData];
            //请求 总数据成功之后 ----最新口子接口 or 轮播图
            if (self.latestCycleArray.count) {
                
                [self latestDataOrCycle];
            }
        }
        
        
    } failure:^(NSError *error) {
        JTLog(@"%@",error);
    }];
}
#pragma mark - 判断用户是否已经申请big_text
-(void)getBigLoanData:(NSString *)titleName selectedIdx:(NSInteger)idx{
    //    WEAKSELF;
    NSString *isApply_url  = [NSString stringWithFormat:@"%@/manager/bnh/check/largeApply",HS_USER_URL];
    NSDictionary *userDic=  @{@"os":@"ios",@"appName":app_name_type};
    NSString *url   =[JFHSUtilsTool conectUrl:[userDic  mutableCopy] url:isApply_url];
    JFUserInfoTool *userInfo  = [JFUserManager shareManager].currentUserInfo;
    [PPNetworkHelper setValue:userInfo.loginSuccessKey forHTTPHeaderField:@"API_KEY"];
    
    [PPNetworkHelper GET:url parameters:@{} success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        //resultCode  0 跳转到申请 界面
        //提示用户 已经申请
        self.isrequestSuccess = YES;
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"4"]) {
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:responseObject[@"resultCodeMessage"]];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
             [self submitHomeSensorsAnalyties:@"1002" businessName:titleName businessTab:@"JFBigNewEditViewController" posIdx:[NSString stringWithFormat:@"%zd",idx + 1] gotoSuccess:@"0"];
        }else{
            //跳转big_give_text界面
            JFBigNewEditViewController  *bigVC  = [[JFBigNewEditViewController alloc]init];
            bigVC.title = titleName;
            bigVC.bigLoanIdx = idx;
            bigVC.hidesBottomBarWhenPushed =  YES;
            [self.navigationController pushViewController:bigVC animated:YES];
              [self submitHomeSensorsAnalyties:@"1002" businessName:titleName businessTab:@"JFBigNewEditViewController" posIdx:[NSString stringWithFormat:@"%zd",idx + 1] gotoSuccess:@"1"];
        }
    } failure:^(NSError *error) {
        JTLog(@"big_give_text错误信息error= %@",error);
         self.isrequestSuccess = YES;
    }];
}
-(void)creatBigLoanData:(NSString *)titleName selectedIdx:(NSInteger)idx{
    [self getBigLoanData:titleName selectedIdx:idx];
}
#pragma mark -  最新口子数据or轮播图
-(void)latestDataOrCycle{
    WEAKSELF;
    JFEditHomemodel *latestModel;
    NSDictionary *dic;
    //由于要做点击tababr的时候需要重新请求数据
    //做判断  当 后台没有没有切换的时候  不需要请求数据
    
    if ([self.headerShowType isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"showTypeRequest"]] && self.latestArray.count) {
        //若没变化
        return;
    }else{
        
 
    if ([self.headerShowType isEqualToString:home_show_cycleOrLatestProducts_text]) {
        /**最新口子**/
        latestModel  =self.latestCycleArray[0];
        dic =  @{@"areaTagId":latestModel.areaTagId,@"getConfig":@"true",@"os":@"ios",@"appName":app_name_type};
    }else{
        /**轮播图数据**/
        latestModel  =self.latestCycleArray[1];
        dic =  @{@"areaTagId":latestModel.areaTagId,@"areaId":latestModel.areaId,@"os":@"ios",@"appName":app_name_type};
    }
    NSString *latestUrl = [NSString stringWithFormat:@"%@/manager/pf/platforms",HS_USER_URL];
    
  
    NSString *dataUrl =  [JFHSUtilsTool conectUrl:[dic mutableCopy] url:latestUrl];
  
    [PPNetworkHelper GET:dataUrl parameters:nil success:^(id responseObject) {
        JTLog(@"最新口子=%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            [self.latestArray removeAllObjects];
            [self.webArr removeAllObjects];
            [self.policyArr removeAllObjects];
            if ([weakSelf.headerShowType isEqualToString:home_show_cycleOrLatestProducts_text]) {
                //
                for (NSDictionary  *webDic in responseObject[@"areaTags"][0][@"platforms"]) {
                    JFEditHomemodel *webModel = [JFEditHomemodel mj_objectWithKeyValues:webDic];
                    [self.webArr addObject:webModel];
                }
                for (NSDictionary *temDic in responseObject[@"areaTags"]) {
                    JFEditLogModel *temModel  = [JFEditLogModel mj_objectWithKeyValues:temDic];
                    [self.policyArr addObject:temModel];
                }
                for (NSDictionary *dic in responseObject[@"area9Config"]) {
                    JFEditHomemodel *latestModel =[JFEditHomemodel mj_objectWithKeyValues:dic];
                    [self.latestArray addObject:latestModel];
                }
                
                //传送倒计时数据
                [weakSelf.firstHeaderView getLatestData:self.latestArray];
                
                //r提交日志
                //判断platforms数组 是否为空 为空不传platformId
                NSArray *temArr  =responseObject[@"areaTags"][0][@"platforms"];
                if (temArr.count) {
                   [weakSelf getLogData:[NSString stringWithFormat:@"%@",responseObject[@"areaTags"][0][@"platforms"][0][@"platformId"]]];
                }
                
            }else{
                for (NSDictionary *dic in responseObject[@"areaTags"][0][@"platforms"]) {
                    JFEditHomemodel *latestModel =[JFEditHomemodel mj_objectWithKeyValues:dic];
                    [self.latestArray addObject:latestModel];
                }
                for (NSDictionary *temDic in responseObject[@"areaTags"]) {
                    JFEditLogModel *temModel  = [JFEditLogModel mj_objectWithKeyValues:temDic];
                    [self.policyArr addObject:temModel];
                }
                //轮播图数据
                [weakSelf.cycleView getCycleData:self.latestArray];
            }
        }
    } failure:^(NSError *error) {
        JTLog(@"error = %@",error);
    }];
        
    }
    [[NSUserDefaults standardUserDefaults]setValue:self.headerShowType forKey:@"showTypeRequest"];
    [[NSUserDefaults  standardUserDefaults]synchronize];
}
#pragma mark - 最新口子提交日志 
-(void)getLogData:(NSString *)platformId {
    JFEditHomemodel *latestModel  =self.latestCycleArray[0];
    [JFSHLogEditTool logRequestCookId:platformId eventTagName:latestModel.tagName eventAction:latestModel.areaId firstEventValue:latestModel.pos secondEventValue:@"1"showType:LogShowType_Home];
}
#pragma mark  - 倒计时 view点击跳转webview界面
-(void)headerViewGesture{
    if (self.webArr.count) {
        JFEditHomemodel *webModel = self.webArr[0];
        [self jumpWebView:webModel];
        [self creditGive:webModel loginModel:self.policyArr[0]];
    }
    
}
#pragma matk - 轮播图点击事件
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    JFEditHomemodel *cycleModel = self.latestArray[index];
    [self jumpWebView:cycleModel];
    [self getCycleLogData:[NSString stringWithFormat:@"%@",cycleModel.platformId] selecIndx:index];
    [self creditGive:cycleModel loginModel:self.policyArr[0]];
}
#pragma marl -轮播图提交日志
-(void)getCycleLogData:(NSString *)platformId selecIndx:(NSInteger)idx{
    JFEditHomemodel *latestModel  =self.latestCycleArray[1];
    [JFSHLogEditTool logRequestCookId:platformId eventTagName:latestModel.tagName eventAction:latestModel.areaId firstEventValue:latestModel.pos secondEventValue:[NSString stringWithFormat:@"%zd",idx]showType:LogShowType_Home];
}
-(void)jumpWebView:(JFEditHomemodel *)webModel{
    //判断用户是否获取到剪切板的内容
    //若没有 就跳转到登录界面获取userid 用于神测
    JFUserInfoTool *userInfo  = [JFUserManager shareManager].currentUserInfo;
    NSMutableArray  *temArr  = [NSMutableArray array];
    [temArr addObject:webModel.name];
    [temArr addObject:webModel.platformId];
    [temArr addObject:@"1"];
    if ([JFHSUtilsTool isBlankString:userInfo.xuserloginIdStr]) {
        [JFShanYanRequestEditTool requestShanYan:self jumpToVC:@"JFWebNewEditViewController" jumVCParameter:webModel.url cityStr:@"" tittlName:@""webArray:[temArr copy]];
    }else{
        JFWebNewEditViewController *webVC =[[JFWebNewEditViewController alloc]init];
        webVC.url = webModel.url;
        webVC.webArr  = [temArr copy];
        [webVC setImgBlock:^{
            JTLog(@"不做操作");
        }];
        webVC.hidesBottomBarWhenPushed  = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}
#pragma mark  - collectionview第二部分对应的webURL

-(void)getSecondCollection:(NSString *)areaId  areaTagId:(NSString *)areaTagIdStr selected:(NSInteger)idx{
    NSMutableArray *temArray  =[NSMutableArray array];
    NSMutableArray *webArray  =[NSMutableArray array];
    NSString *second =  [NSString stringWithFormat:@"%@/manager/pf/platforms",HS_USER_URL];
    NSDictionary * dic =  @{@"areaTagId":areaTagIdStr,@"areaId":areaId,@"os":@"ios",@"appName":app_name_type};
    NSString *url   =[JFHSUtilsTool conectUrl:[dic  mutableCopy] url:second];
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
            JTLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]] isEqualToString:@"0"]) {
            //请求数据成功
            [temArray removeAllObjects];
            [webArray removeAllObjects];
            for (NSDictionary  *logDic in responseObject[@"areaTags"]) {
                JFEditLogModel *logModel  = [JFEditLogModel mj_objectWithKeyValues:logDic];
                [temArray addObject:logModel];
            }
            //解析跳转web界面数据
            for (NSDictionary *webDic in responseObject[@"areaTags"][0][@"platforms"]) {
                JFEditHomemodel *webModel = [JFEditHomemodel mj_objectWithKeyValues:webDic];
                [webArray addObject:webModel];
            }
            if (webArray.count) {
                //没有数据就不跳转和提交神策数据
                [self jumpWebView:webArray[0]];
                //请求日志接口
                [self getRequestLogData:temArray[0] requestIdx:idx];
                //提交💕Super产品神策 数据
                [self creditGive:webArray[0] loginModel:temArray[0]];
            }
           
        }
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark -  点击提交💕Super神策数据
-(void)creditGive:(JFEditHomemodel *)giveModel loginModel:(JFEditLogModel *)logModel{
 
    NSDictionary  *dic =  @{@"area_id":logModel.areaId,@"pos":[NSString stringWithFormat:@"%@",logModel.pos],@"product_id":giveModel.platformId,@"product_name":giveModel.name,@"product_url":giveModel.url};
    [[SensorsAnalyticsSDK sharedInstance]track:@"ProductClick" withProperties:dic];

}
#pragma mark - 请求是否首页显示轮播图接口
-(void)cycleAndVestbagData{
    NSString *url  = [NSString stringWithFormat:@"%@/manager/mgt/appVersion/info",HS_USER_URL];
    NSDictionary  *dic  = @{@"productName":app_name_type,@"marketingName":@"ios",@"version":@"2.0"};
    NSDictionary *userDic=  @{@"os":@"ios",@"appName":app_name_type};
    NSString *cyclyUrl   =[JFHSUtilsTool conectUrl:[userDic  mutableCopy] url:url];
    NSString *requestUrl   =   [JFHSUtilsTool conectUrl:[dic mutableCopy] url:cyclyUrl];
    [PPNetworkHelper GET:requestUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            NSString *showType = [NSString stringWithFormat:@"%@",responseObject[@"headerModel"]];
         
    
            [self headerUI:showType];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark- 请求日志接口

-(void)getRequestLogData:(JFEditLogModel *)logModel requestIdx:(NSInteger)idx{
    NSDictionary *logDic = logModel.platforms[0];
    [JFSHLogEditTool logRequestCookId:[NSString stringWithFormat:@"%@",logDic[@"platformId"]] eventTagName:logModel.tagName eventAction:logModel.areaId firstEventValue:logModel.pos secondEventValue:[NSString stringWithFormat:@"%zd",idx]showType:LogShowType_Home];
}
-(NSArray *)nameArray{
    if (!_nameArray) {
      NSString *big_decod=  [JFHSUtilsTool  decodeFromPercentEscapeString:big_give_text];
         NSString *second_decodeKey =[JFHSUtilsTool stringXORDeocodeWithPlainText:second_tab_text secretKey:codeKey];
        _nameArray = @[second_decodeKey,[JFHSUtilsTool decodeFromPercentEscapeString:give_card_text],big_decod];
    }
    return _nameArray;
}
-(NSArray *)imgArray{
    if (!_imgArray) {
        _imgArray = @[@"newImgHomeLoan",@"newImgcard",@"NewLoanImg"];
    }
    return _imgArray;
}
-(UIView *)headerView{
    if (!_headerView) {
        _headerView= [[UIView alloc]init];
        [self.view  addSubview:_headerView];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}
#pragma mark- 最新口子
-(JFNewHeaderEditView *)firstHeaderView{
    if (!_firstHeaderView) {
        /**_firstHeaderView 添加手势  点击跳转h5界面**/
        _firstHeaderView = [[JFNewHeaderEditView alloc]init];
          _firstHeaderView.frame  =CGRectMake(0, 0, JT_ScreenH, 100 * JT_ADAOTER_WIDTH);
        [_firstHeaderView  setGradientBackgroundColor:@"#24ADFF" secondColor:@"#2985FF"];
        UITapGestureRecognizer *getsture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewGesture)];
        _firstHeaderView.userInteractionEnabled = YES;
        [_firstHeaderView addGestureRecognizer:getsture];
    }
    return _firstHeaderView;
}
#pragma mark  - 轮播图
-(JFNewHomeEditCycleView *)cycleView{
    if (!_cycleView) {
        _cycleView =  [[JFNewHomeEditCycleView alloc]init];
        _cycleView.homeCycle.delegate  = self;
        _cycleView.backgroundColor =[UIColor whiteColor];
        _cycleView.frame  =CGRectMake(0, 0, JT_ScreenW, 180 * JT_ADAOTER_WIDTH);
    }
    return _cycleView;
}
-(UICollectionView *)firstCollectionView{
    if (!_firstCollectionView) {
        UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(105 * JT_ADAOTER_WIDTH, 70 * JT_ADAOTER_WIDTH);
        _firstCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _firstCollectionView.delegate  =self;
        _firstCollectionView.dataSource = self;
        _firstCollectionView.backgroundColor = [UIColor clearColor];
        //h注册
        [_firstCollectionView registerClass:[JFHeaderNewCollectionViewCell class] forCellWithReuseIdentifier:@"priceCollection"];
        //注册尾部
        [_firstCollectionView registerClass:[JFNewHeaderCollectionReusableViewEdit class]forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"];
    }
    return _firstCollectionView;
}

-(UICollectionView *)secondCollectionView{
    if (!_secondCollectionView) {
        UICollectionViewFlowLayout *secondflowLayout =  [[UICollectionViewFlowLayout alloc]init];
        secondflowLayout.itemSize = CGSizeMake(JT_ScreenW/4, 110 * JT_ADAOTER_WIDTH);
        secondflowLayout.minimumLineSpacing= 0;
        secondflowLayout.minimumInteritemSpacing  =  0;
        UICollectionView *secondCollectionVC = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:secondflowLayout];
        secondCollectionVC.delegate  =self;
        secondCollectionVC.dataSource = self;
        secondCollectionVC.backgroundColor = [UIColor clearColor];
        _secondCollectionView = secondCollectionVC;
        //h注册
        [_secondCollectionView registerClass:[JFEditHomeSecondNewCollectionViewCell class] forCellWithReuseIdentifier:@"secondCollection"];
    }
    return _secondCollectionView;
}
-(JFPagerViewEdit *)pageingView{
    if (!_pageingView) {
        _pageingView = [[JFPagerViewEdit alloc]initWithDelegate:self];
    }
    return _pageingView;
}
#pragma mark-查看更多
-(UILabel *)otherNameLable{
    if (!_otherNameLable) {
        _otherNameLable  = [UILabel new];
        [self.categoryView addSubview:_otherNameLable];
        _otherNameLable.text = header_checkmore_text;
        _otherNameLable.font  = kFontSystem(12);
        _otherNameLable.textColor  = [UIColor colorWithHexString:@"999999"];
        UITapGestureRecognizer *gesture   = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkMoreGesture)];
        _otherNameLable.userInteractionEnabled  = YES;
        [_otherNameLable addGestureRecognizer:gesture];
    }
    return _otherNameLable;
}
-(JXCategoryTitleView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JXheightForHeaderInSection *JT_ADAOTER_WIDTH)];
        _categoryView.delegate = self;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.backgroundColor=[UIColor colorWithHexString:@"#F5F5F5"];
        _categoryView.defaultSelectedIndex = 0;
        _categoryView.titleColor = [UIColor colorWithHexString:@"#666666"];
        _categoryView.titleSelectedFont  = kFontSystem(15);
        _categoryView.titleSelectedColor = UIColor.blackColor;
    }
    return _categoryView;
}
@end
