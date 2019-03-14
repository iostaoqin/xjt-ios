//
//  JFShanYanRequestEditTool.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/8.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFShanYanRequestEditTool.h"

@implementation JFShanYanRequestEditTool
+(instancetype)shareShanYan{
    static JFShanYanRequestEditTool *_shanYan = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shanYan = [[JFShanYanRequestEditTool alloc]init];
          [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    });
    return _shanYan;
}
+(void)requestShanYan:(UIViewController *)currentVC jumpToVC:(NSString *)jumVC jumVCParameter:(NSString *)parameter cityStr:(NSString *)city tittlName:(NSString *)title webArray:(NSArray *)webArr{
//    //电信定制界面
//    CLCTCCUIConfigure *ctccUIConfigure  =[ CLCTCCUIConfigure new];
//    ctccUIConfigure.logoImg = [UIImage imageNamed:@"new_login_Logo_img"];
//    ctccUIConfigure.viewController=currentVC;
//
//    //移动定制界面
//    CLCMCCUIConfigure * cmccUIConfigure = [CLCMCCUIConfigure new];
//    cmccUIConfigure.logoImg = [UIImage imageNamed:@"new_login_Logo_img"];
//    cmccUIConfigure.viewController = currentVC;
//    //联通定制界面
//    CLCUCCUIConfigure * cuccUIConfigure = [CLCUCCUIConfigure new];
//    cuccUIConfigure.UAPageContentLogo  =[UIImage imageNamed:@"new_login_Logo_img"];
//    cuccUIConfigure.viewController.view.backgroundColor =[UIColor redColor];
//    cuccUIConfigure.viewController = currentVC;
//
////    UACustomModel *model = [[UACustomModel alloc]init];
////
////    model.logBtnText  = @"测试";
////
////    [TYRZUILogin customUIWithParams:model customViews:^(UIView *customAreaView) {
////        customAreaView.backgroundColor =[UIColor redColor];
////    }];
//
//
//
//
//
//
//
//
//    //提示框
//      [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
//      [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
//    [CLShanYanSDKManager  quickAuthLoginWithConfigureCTCC:ctccUIConfigure CMCC:cmccUIConfigure CUCC:cuccUIConfigure timeOut:4 complete:^(CLCompleteResult * _Nonnull completeResult) {
//
//        if (completeResult.error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (completeResult.code == 1011) {
//                    JTLog(@"用户取消免密登录");
//                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"取消免密登录"];
//                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
//                }else{
//                    if (completeResult.code  == 1009) {
//                        //
//                        JTLog(@"此手机无SIM卡");
//                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
//                        //走常规的登录
//                        [self  loginRootVC:currentVC jumtoVC:jumVC parameter:parameter cityStr:city titleName:title];
//                    }else if (completeResult.code == 1008){
//                        //打开蜂窝数据
//                         [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
//
//                    }else{
//                         [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
//                       //网络状况不稳定，切换至验证码登录
//                         [self  loginRootVC:currentVC jumtoVC:jumVC parameter:parameter cityStr:city titleName:title];
//                    }
//                }
//            });
//        }else{
//             [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
//            NSLog(@"quickAuthLogin Success:%@",completeResult.data);
//
//            NSString * telecom = [completeResult.data valueForKey:@"telecom"];
//            NSString *urlStr = nil;
//            if ([telecom isEqualToString:@"CMCC"]) {
//                urlStr = [SY_SDK_URL stringByAppendingString:@"open/flashsdk/mobile-query-m"];
//            }else if ([telecom isEqualToString:@"CUCC"]){
//                urlStr = [SY_SDK_URL stringByAppendingString:@"open/flashsdk/mobile-query-u"];
//            }else if ([telecom isEqualToString:@"CTCC"]) {
//                urlStr = [SY_SDK_URL stringByAppendingString:@"open/flashsdk/mobile-query-t"];
//            }else{
//                //
//                JTLog(@"此手机无SIM卡或不是联通卡");
//                return ;
//            }
//            if (urlStr) {
//                NSLog(@"tokenParamr:%@",completeResult.data);
//
//                //闪验成功之后上传到后台 再设置rootvc
//                NSDictionary *dic  = @{@"appId":completeResult.data[@"appId"],@"accessToken":completeResult.data[@"accessToken"],@"telecom":completeResult.data[@"telecom"],@"timestamp":completeResult.data[@"timestamp"],@"randoms":completeResult.data[@"randoms"],@"sign":completeResult.data[@"sign"],@"version":completeResult.data[@"version"],@"device":completeResult.data[@"device"],@"platform":@"prod-ios"};
//                NSString  *url  = [NSString stringWithFormat:@"%@/manager/mgt/bnh/userLogin",HS_USER_URL];
//                [JFHttpsToolEdit requestType:@"POST" putWithUrl:url withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
//                    JTLog(@"%@",data);
//                    if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
//                        //请求成功 存储key
//                        JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
//                        userInfo.loginSuccessKey= [NSString stringWithFormat:@"%@",data[@"key"]];
//                        userInfo.xuserloginIdStr  = [NSString stringWithFormat:@"%@",data[@"userId"]];
//                        [JFUserManager  shareManager].currentUserInfo =  userInfo;
//                        //调用神策的登录接口 把匿名id和 登录成功h之后获取id关联
//                        [[SensorsAnalyticsSDK sharedInstance]login:[NSString stringWithFormat:@"%@",data[@"userId"]]];
//                        if ([jumVC isEqualToString:@"JFEditeUsersInformationViewController"]||[jumVC isEqualToString:@"JFBigNewEditViewController"]) {
//                            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginAgainNotice" object:nil];
//                        }
//                        //一系列操作
//                        [self jumVCEvent:jumVC webUrl:parameter currentVC:currentVC cityStr:city titlName:title];
//                        //上传日志
//                         [self uploadLog];
//                    }
//                } withErrorCodeTwo:^{
//
//                } withErrorBlock:^(NSError * _Nonnull error) {
//
//                }];
//            }
//        }
//    }];
    //走常规的登录 闪验砍掉
    [self  loginRootVC:currentVC jumtoVC:jumVC parameter:parameter cityStr:city titleName:title webArr:webArr];
}
+(void)requestNewCard:(UIViewController *)currentVC jumpToVC:(NSString *)jumVC jumVCParameter:(NSString *)parameter categorySelectedIdx:(NSInteger )categoryIdx tittlName:(NSString *)title categray:(JFThirdNewModel *)cardModel city:( NSString *)city{
    [self loginNewCard:currentVC jumpToVC:jumVC jumVCParameter:parameter categorySelectedIdx:categoryIdx tittlName:title  cardModel:cardModel cityStr:city];
}
+(void)loginNewCard:(UIViewController *)currentVC  jumpToVC:(NSString  *)cardJumVC jumVCParameter:(NSString *)parameter categorySelectedIdx:(NSInteger )categoryIdx tittlName:(NSString *)cardTitle cardModel:(JFThirdNewModel  *)model cityStr:(NSString  *)city{
    JFUserLoginViewController *loginVC =  [[JFUserLoginViewController alloc]init];
    loginVC.jumControllerVC  = cardJumVC;
    loginVC.requestStr  = parameter;
    loginVC.catagreIdx  = categoryIdx;
    loginVC.titleStr = cardTitle;
    loginVC.cardNewModel  =  model;
    loginVC.cityStr  = city;
    loginVC.hidesBottomBarWhenPushed = YES;
    [currentVC.navigationController pushViewController:loginVC animated:YES];

}
+(void)loginRootVC:(UIViewController *)shanyanVC jumtoVC:(NSString *)jumVC  parameter:(NSString *)parameterStr cityStr:(NSString *)str titleName:(NSString *)name webArr:(NSArray  *)webArr{
    JFUserLoginViewController *loginVC =  [[JFUserLoginViewController alloc]init];
    loginVC.jumControllerVC  = jumVC;
    loginVC.requestStr  = parameterStr;
    loginVC.cityStr  = str;
    loginVC.titleStr = name;
    loginVC.loginWebArr   =  webArr;
    loginVC.hidesBottomBarWhenPushed = YES;
    [shanyanVC.navigationController pushViewController:loginVC animated:YES];
}
//授权页 点击自定义控件绑定的方法
-(void)otherLoginWayBtnCliced:(UIButton *)sender{
    JTLog(@"点击自定义控件绑定的方法");
}
//用于我的界面 头像 的修改  及名称
+(void)requestShanYan:(UIViewController *)currentVC jumpToVC:(NSString *)jumVC jumVCParameter:(NSString *)parameter jumVCImg:(UIImageView *)loginImg loginNameLable:(UILabel *)loginName{
//    [CLShanYanSDKManager preGetPhonenumber];
////customUIWithParams
//
//    //电信定制界面
//    CLCTCCUIConfigure *ctccUIConfigure  =[ CLCTCCUIConfigure new];
//    ctccUIConfigure.logoImg = [UIImage imageNamed:@"new_login_Logo_img"];
//    ctccUIConfigure.viewController=currentVC;
//
//    //移动定制界面
//    CLCMCCUIConfigure * cmccUIConfigure = [CLCMCCUIConfigure new];
//    cmccUIConfigure.logoImg = [UIImage imageNamed:@"new_login_Logo_img"];
//    cmccUIConfigure.viewController = currentVC;
//    //联通定制界面
//    CLCUCCUIConfigure * cuccUIConfigure = [CLCUCCUIConfigure new];
//    cuccUIConfigure.UAPageContentLogo  =[UIImage imageNamed:@"new_login_Logo_img"];
//    cuccUIConfigure.viewController.view.backgroundColor =[UIColor redColor];
//    cuccUIConfigure.viewController = currentVC;
//    cuccUIConfigure.otherWayHidden   = NO;
//
//    //提示框
//    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
//    [CLShanYanSDKManager  quickAuthLoginWithConfigureCTCC:ctccUIConfigure CMCC:cmccUIConfigure CUCC:cuccUIConfigure timeOut:4 complete:^(CLCompleteResult * _Nonnull completeResult) {
//           [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
//        if (completeResult.error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (completeResult.code == 1011) {
//                    JTLog(@"用户取消免密登录");
//                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"取消免密登录"];
//                    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
//                }else{
//                    if (completeResult.code  == 1009) {
//                        //
//                        JTLog(@"此手机无SIM卡");
//                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
//
//                    }else if (completeResult.code == 1008){
//                        //打开蜂窝数据
//                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
//
//                    }else{
//                        [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
//                        //网络状况不稳定，切换至验证码登录
//                       [self  loginRootVC:currentVC jumtoVC:jumVC parameter:parameter loginImg:loginImg titleNameLable:loginName];
//                    }
//                }
//            });
//        }else{
//            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
//            NSLog(@"quickAuthLogin Success:%@",completeResult.data);
//
//            NSString * telecom = [completeResult.data valueForKey:@"telecom"];
//            NSString *urlStr = nil;
//            if ([telecom isEqualToString:@"CMCC"]) {
//                urlStr = [SY_SDK_URL stringByAppendingString:@"open/flashsdk/mobile-query-m"];
//            }else if ([telecom isEqualToString:@"CUCC"]){
//                urlStr = [SY_SDK_URL stringByAppendingString:@"open/flashsdk/mobile-query-u"];
//            }else if ([telecom isEqualToString:@"CTCC"]) {
//                urlStr = [SY_SDK_URL stringByAppendingString:@"open/flashsdk/mobile-query-t"];
//            }else{
//                //
//                JTLog(@"此手机无SIM卡或不是联通卡");
//                return ;
//            }
//            if (urlStr) {
//                NSLog(@"tokenParamr:%@",completeResult.data);
//
//                //闪验成功之后上传到后台 再设置rootvc
//                NSDictionary *dic  = @{@"appId":completeResult.data[@"appId"],@"accessToken":completeResult.data[@"accessToken"],@"telecom":completeResult.data[@"telecom"],@"timestamp":completeResult.data[@"timestamp"],@"randoms":completeResult.data[@"randoms"],@"sign":completeResult.data[@"sign"],@"version":completeResult.data[@"version"],@"device":completeResult.data[@"device"],@"platform":@"prod-ios"};
//                NSString  *url  = [NSString stringWithFormat:@"%@/manager/mgt/bnh/userLogin",HS_USER_URL];
//                [JFHttpsToolEdit requestType:@"POST" putWithUrl:url withParameter:dic withSuccess:^(id  _Nonnull data, NSString * _Nonnull msg) {
//                    JTLog(@"%@",data);
//                    if ([[NSString stringWithFormat:@"%@",data[@"resultCode"]]isEqualToString:@"0"]) {
//                        //请求成功 存储key
//                        JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
//                        userInfo.loginSuccessKey= [NSString stringWithFormat:@"%@",data[@"key"]];
//                        userInfo.xuserloginIdStr  = [NSString stringWithFormat:@"%@",data[@"userId"]];
//                        [JFUserManager  shareManager].currentUserInfo =  userInfo;
//                        //调用神策的登录接口 把匿名id和 登录成功h之后获取id关联
//                        [[SensorsAnalyticsSDK sharedInstance]login:[NSString stringWithFormat:@"%@",data[@"userId"]]];
//                        //跳转 一系列操作
//                         [self jumVCMineEvent:jumVC webUrl:parameter currentVC:currentVC loginImgControls:loginImg nameLable:loginName];
//                        if ([jumVC isEqualToString:@"JFEditeUsersInformationViewController"]||[jumVC isEqualToString:@"JFBigNewEditViewController"]) {
//                            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginAgainNotice" object:nil];
//                        }
//                        [self uploadLog];
//                    }
//                } withErrorCodeTwo:^{
//
//                } withErrorBlock:^(NSError * _Nonnull error) {
//
//                }];
//            }
//        }
//    }];
    //走常规的登录 闪验 砍掉
    
    [self  loginRootVC:currentVC jumtoVC:jumVC parameter:parameter loginImg:loginImg titleNameLable:loginName];
}
+(void)loginRootVC:(UIViewController *)shanyanVC jumtoVC:(NSString *)jumVC  parameter:(NSString *)parameterStr loginImg:(UIImageView *)imgStr titleNameLable:(UILabel *)name{
    JFUserLoginViewController *loginVC =  [[JFUserLoginViewController alloc]init];
    loginVC.jumControllerVC  = jumVC;
    loginVC.requestStr  = parameterStr;
    loginVC.portraintImg  = imgStr;
    loginVC.nameLable = name;
    loginVC.hidesBottomBarWhenPushed = YES;
    [shanyanVC.navigationController pushViewController:loginVC animated:YES];
}
#pragma Mark-跳转一系列操作
+(void)jumVCEvent:(NSString *)jumControllerVC webUrl:(NSString *)requestStr currentVC:(UIViewController *)currentVC  cityStr:(NSString *)cityStr titlName:(NSString *)nameStr{
    if ([jumControllerVC isEqualToString:@"JFGiveNewViewController"]) {
        //首页点击
//        self.tabBarController.selectedIndex  = 1;
    }else if([jumControllerVC isEqualToString:@"JFWebNewEditViewController"]){
        //跳转到web界面
        JFWebNewEditViewController *webVC =[[JFWebNewEditViewController alloc]init];
        webVC.url = requestStr;
        webVC.whereVC = @"JFUserLoginViewController";
        [webVC setImgBlock:^{
            JTLog(@"不做操作");
        }];
        webVC.hidesBottomBarWhenPushed  = YES;
        [currentVC.navigationController pushViewController:webVC animated:YES];
    }else if([jumControllerVC isEqualToString:@"JFBigNewEditViewController"]){
        //big 直接返回 当前界面  我的界面 w姓名/请登录  退出登录时
        [currentVC.navigationController popViewControllerAnimated:YES];
    }else if ([jumControllerVC isEqualToString:@"JFNewDeatilCardViewController"]){
        //new card界面
        JFNewDeatilCardViewController *newVC = [[JFNewDeatilCardViewController alloc]init];
        newVC.hidesBottomBarWhenPushed  = YES;
        newVC.title = nameStr ;
        newVC.categoryID  = requestStr;
        newVC.cityStr = cityStr;
        newVC.whereVC = @"JFUserLoginViewController";
        [currentVC.navigationController pushViewController:newVC animated:YES];
    }
}
#pragma mark  - 我的界面
+(void)jumVCMineEvent:(NSString *)jumControllerVC webUrl:(NSString *)requestStr currentVC:(UIViewController *)currentVC  loginImgControls:(UIImageView  *)portraintImg nameLable:(UILabel *)nameLableControls{
    
    if([jumControllerVC isEqualToString:@"JFEditeUsersInformationViewController"]){
        JFEditeUsersInformationViewController *settingVC = [[JFEditeUsersInformationViewController  alloc]init];
        settingVC.hidesBottomBarWhenPushed   = YES;
        settingVC.title  =  requestStr;
        settingVC.whereVC = @"JFUserLoginViewController";
        [settingVC setImgBlock:^(NSString *imgUrl) {
            [portraintImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"login_img_portrait"]];
        }];
        [currentVC.navigationController pushViewController:settingVC animated:YES];
    }else if([jumControllerVC isEqualToString:@"JFSettingUsersViewConntroller"]){
        JFSettingUsersViewConntroller  *editeVC  = [[JFSettingUsersViewConntroller alloc]init];
        editeVC.hidesBottomBarWhenPushed   = YES;
        editeVC.title  =  requestStr;
        editeVC.whereVC = @"JFUserLoginViewController";
        [editeVC setMineBlock:^(NSString *name) {
            nameLableControls.text  = name;
        }];
        [currentVC.navigationController pushViewController:editeVC animated:YES];
    }
    
    
}
#pragma mark -  上传日志信息
+(void)uploadLog{
    JFUserInfoTool *user  =[JFUserManager shareManager].currentUserInfo;
    NSString *loginUrl  =[NSString stringWithFormat:@"%@/manager/mgt/user/log",HS_USER_URL];
    NSDictionary *dic  = @{@"os":@"ios",@"appName":app_name_type,@"userId":user.xuserloginIdStr,@"channelCode":@"prod-ios",@"eventAction":@"login",@"eventValue":@"1"};
    NSString *submitUrl =[JFHSUtilsTool conectUrl:[dic mutableCopy] url:loginUrl];
    JTLog(@"%@",submitUrl);
    [PPNetworkHelper setValue:user.loginSuccessKey forHTTPHeaderField:@"API_KEY"];
    [PPNetworkHelper setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    JTLog(@"%@",user.loginSuccessKey);
    [PPNetworkHelper POST:submitUrl parameters:nil success:^(id responseObject) {
        JTLog(@"上传日志=%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
}
@end
