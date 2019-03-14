//
//  ViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/24.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "ViewController.h"
#import "JFBaseNavigationViewControllerEdit.h"
#import "JTMainContentViewController.h"
@interface ViewController ()<UITabBarControllerDelegate>
@property (nonatomic,  strong)NSString *versionStr;//显示的是马甲包还是正式版本
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    NSString *url  = [NSString stringWithFormat:@"%@/manager/mgt/appVersion/info",HS_USER_URL];
//    NSDictionary  *dic  = @{@"productName":app_name_type,@"marketingName":@"ios",@"version":@"2.0",@"os":@"ios",@"appName":app_name_type};
//    NSString *vesturl   =[JFHSUtilsTool conectUrl:[dic  mutableCopy] url:url];
//    [PPNetworkHelper GET:vesturl parameters:nil success:^(id responseObject) {
//        JTLog(@"%@",responseObject);
//        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
//            
//            if ([[NSString  stringWithFormat:@"%@",responseObject[@"onlineModel"]]isEqualToString:@"prod"]) {
//                //onlineModel -prod (正式版本)
//                NSString *str =[[NSUserDefaults standardUserDefaults]valueForKey:@"showTypeVersion"];
//                if (![str isEqualToString:@"prod"]) {
//                    //清空数据
//                    JFUserInfoTool *userInfo=[[JFUserInfoTool alloc]init];
//                    
//                    if (![JFHSUtilsTool isBlankString:[[NSUserDefaults standardUserDefaults]valueForKey:@"loginUserID"]]) {
//                        userInfo.userIdStr  =[[NSUserDefaults standardUserDefaults]valueForKey:@"loginUserID"];
//                    }
//                    
//                    [JFUserManager  shareManager].currentUserInfo  = userInfo;
//                }
//                
//                [self  officialVersion];
//                self.versionStr = @"1";
//                
//                
//            }else{
//                NSString *str =[[NSUserDefaults standardUserDefaults]valueForKey:@"showTypeVersion"];
//                if (![str isEqualToString:@"dev"]) {
//                    //清空数据
//                    JFUserInfoTool *userInfo=[[JFUserInfoTool alloc]init];
//                    [JFUserManager shareManager].currentUserInfo  = userInfo;
//                }
//                    [self xiaojintiao];
//              
//            }
//            
//        }
//    } failure:^(NSError *error) {
//        
//    }];
    [self  officialVersion];
    self.versionStr = @"1";
}
-(void)xiaojintiao{
  
//    self.tabBarController.tabBar.hidden = YES;
   
}
#pragma mark -  正式 包
-(void)officialVersion{
    //第二个tabbar title
    NSString *second_decodeKey =[JFHSUtilsTool stringXORDeocodeWithPlainText:second_tab_text secretKey:codeKey];
    //第三个tabbar title
    NSString *cardTitle  =[JFHSUtilsTool decodeFromPercentEscapeString:third_tab_text];
    [self addChildVC:[[JFNewHomeViewController alloc]init] title:@"" image:@"img_nomal_home" selectedImage:@"img_home_selected" tabItemTitle:first_tab_text];
    
    [self addChildVC:[[JFGiveNewViewController alloc]init] title:second_decodeKey image:@"img_noaml_loan" selectedImage:@"new_img_loan_selected" tabItemTitle:second_decodeKey];
    [self addChildVC:[[JFNewThirdCardViewController alloc]init] title:cardTitle image:@"new_img_creditCard" selectedImage:@"new_img_creditCard_selected" tabItemTitle:cardTitle];
    [self addChildVC:[[JFFourthMineViewController alloc]init] title:fourth_tab_text image:@"new_nomal_mine" selectedImage:@"new_img_selected_mine" tabItemTitle:fourth_tab_text];
    self.delegate  = self;
    self.currentIdx  = 0;//默认是0
}
- (void)addChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selecImage tabItemTitle:(NSString *)itemTitle{
    //设置自控制器的名字
    childVC.title = title;
    childVC.tabBarItem.title = itemTitle;
    //设置控制器的图片
    childVC.tabBarItem.image =[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置选中子空置器的图片
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selecImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    JFBaseNavigationViewControllerEdit *nac = [[JFBaseNavigationViewControllerEdit  alloc]initWithRootViewController:childVC];
    
    //设置tabbar的字体颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"b3b3b3"];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //tabar背景颜色
    //    self.tabBarController  = [UIColor whiteColor];
    
    //添加子控制器
    [self addChildViewController:nac];
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([self.versionStr isEqualToString:@"1"]) {
        self.currentIdx = tabBarController.selectedIndex;
        if (self.currentIdx  == tabBarController.selectedIndex) {
            //d发送通知 重新请求数据 把idx 和title传出去 用于神策数据 提交
            NSDictionary *tabDic = @{@"tab_name":tabBarController.selectedViewController.tabBarItem.title,@"pos":[NSString  stringWithFormat:@"%lu",tabBarController.selectedIndex + 1]};
            //提交神策数据   tab
            [JFHSUtilsTool submitSensorsAnalytics:@"TabClick" parameter:tabDic];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshDataNotice" object:nil userInfo:tabDic];
        }
    }
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index =[self.tabBar.items indexOfObject:item];
    if (index !=  self.currentIdx) {
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [arry addObject:btn];
            }
        }
        //添加动画
        
        //放大效果，并回到原位
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数，控制动画运行的节奏
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = 0.2;       //执行时间
        animation.repeatCount = 1;      //执行次数
        animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
        animation.fromValue = [NSNumber numberWithFloat:0.9];   //初始伸缩倍数
        animation.toValue = [NSNumber numberWithFloat:1.2];     //结束伸缩倍数
        [[arry[index] layer] addAnimation:animation forKey:nil];
        

        
        self.currentIdx = index;
    }
}
@end
