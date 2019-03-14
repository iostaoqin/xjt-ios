//
//  JFGiveNewViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFGiveNewViewController.h"
#import "JFGiveDataViewController.h"

@interface JFGiveNewViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)JXCategoryTitleView *categoryView;
@property (strong, nonatomic)  JXCategoryListContainerView *listContainerView;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)UILabel *tipsLable;
@property (nonatomic, strong)NSMutableArray  *titleArr;
@property (nonatomic, strong)NSMutableArray  *tagNameArr;
@end

@implementation JFGiveNewViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshFirstDataNotice" object:nil];
    
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshDataNotice" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
      [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:@"jxUserInfo"];
    [[NSUserDefaults standardUserDefaults]synchronize]; self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.titleArr  = [NSMutableArray array];
    self.tagNameArr =[NSMutableArray array];
    [self requestAllData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshFirstData) name:@"refreshFirstDataNotice" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshFirstData) name:@"refreshDataNotice" object:nil];
}
-(void)refreshFirstData{
    [self.categoryView selectItemAtIndex:0];
    
}
#pragma mark -  得到all_give_data全部的数据
-(void)requestAllData{

    NSString  *allUrl  = [NSString stringWithFormat:@"%@/manager/pf/loanTags",HS_USER_URL];
    NSDictionary *dic = @{@"os":@"ios",@"appName":app_name_type};
    NSString *url   =[JFHSUtilsTool conectUrl:[dic  mutableCopy] url:allUrl];
    [PPNetworkHelper  GET:url parameters:@{} success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        if ([[NSString  stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            
            //解析  第二个tabarareaId 205
            for (NSDictionary  *homeDic in responseObject[@"areaTags"]) {
                if ([[NSString stringWithFormat:@"%@",homeDic[@"areaId"]]isEqualToString:@"205"]) {
                    JFEditHomemodel *model = [JFEditHomemodel mj_objectWithKeyValues:homeDic];
                    [self.titleArr addObject:model];
                    
                }
            }
            //遍历数组得到tagName
            [self.titleArr enumerateObjectsUsingBlock:^(JFEditHomemodel  *tagNameModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.tagNameArr addObject:tagNameModel.tagName];
            }];
            JTLog(@"%@",self.tagNameArr);
            
            [self configUI];
            
            [self.categoryView reloadData];
        }
    } failure:^(NSError *error) {
    
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
#pragma mark - JXCategoryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}
-(void)configUI{
    self.categoryView = [[JXCategoryTitleView alloc]initWithFrame:CGRectMake(0, JT_NAV, JT_ScreenW, flowerHeight)];
    [self.view addSubview:self.categoryView];
    self.categoryView.delegate = self;
    self.categoryView.averageCellSpacingEnabled = NO;
    self.categoryView.titles = [self.tagNameArr copy];
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titleColor = [UIColor colorWithHexString:@"#666666"];
    self.categoryView.titleSelectedFont  = kFontSystem(15);
    self.categoryView.titleSelectedColor = UIColor.blackColor;
    
    self.tipsLable = [[UILabel alloc]init];
    self.tipsLable.text = [JFHSUtilsTool decodeFromPercentEscapeString:give_tips_text  ];
    self.tipsLable.backgroundColor = [UIColor colorWithHexString:@"#FEFCEB"];
    self.tipsLable.textColor  = [UIColor colorWithHexString:@"#FF7A45"];
    self.tipsLable.font  = kFontSystem(14);
    self.tipsLable.textAlignment  = NSTextAlignmentCenter;
    [self.view addSubview:self.tipsLable];
    [self.tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@flowerHeight);
        make.top.equalTo(self.categoryView.mas_bottom);
    }];
    
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithParentVC:self delegate:self];
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.tipsLable.mas_bottom);
    }];
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    JFGiveDataViewController *loadeVC = [[JFGiveDataViewController alloc]init];
    JFEditHomemodel *model = self.titleArr[index];
    loadeVC.temVC  =self;
    loadeVC.giveModel = model;
    return loadeVC;
}
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    if (self.tagNameArr.count) {
       return self.tagNameArr.count;
    }return 0;
    
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
