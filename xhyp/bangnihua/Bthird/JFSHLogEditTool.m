//
//  JFSHLogEditTool.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/10.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFSHLogEditTool.h"

@implementation JFSHLogEditTool
+(instancetype)requestLogMsg{
    static JFSHLogEditTool *_logMsg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _logMsg = [[JFSHLogEditTool alloc]init];
    });
    return _logMsg;
}
+(void)logRequestCookId:(NSString *)cookieId   eventTagName:(NSString *)tagName eventAction:(NSString *)eventActionId firstEventValue:(NSString *)firstValue secondEventValue:(NSString *)secondValue showType:(LogShowType )logType{
    JFUserInfoTool *userInfo  = [JFUserManager shareManager].currentUserInfo;
    NSString *logUrl =[NSString stringWithFormat:@"%@/manager/mgt/user/log",HS_USER_URL];
    NSDictionary *dic;
    if (logType  == LogShowType_Home) {
        //首页
        if ([JFHSUtilsTool isBlankString:userInfo.xuserloginIdStr]) {
            dic = @{@"channelCode":@"prod-ios",@"eventName":@"bnh",@"cookieId":cookieId,@"eventLabel":tagName,@"eventAction":eventActionId,@"eventValue":firstValue,@"eventValue2":secondValue,@"os":@"ios",@"appName":app_name_type};
        }else{
            
            dic = @{@"userId":userInfo.xuserloginIdStr,@"channelCode":@"prod-ios",@"eventName":@"bnh",@"cookieId":cookieId,@"eventLabel":tagName,@"eventAction":eventActionId,@"eventValue":firstValue,@"eventValue2":secondValue,@"os":@"ios",@"appName":app_name_type};
        }
    }else if (logType == LogShowType_Card){
        //办creditCard界面
        if ([JFHSUtilsTool isBlankString:userInfo.xuserloginIdStr]) {
            dic = @{@"channelCode":@"prod-ios",@"eventName":@"CreditCard",@"eventLabel":tagName,@"eventAction":@"click",@"eventValue":firstValue,@"eventValue2":secondValue,@"os":@"ios",@"appName":app_name_type};
        }else{
            dic = @{@"userId":userInfo.xuserloginIdStr,@"channelCode":@"prod-ios",@"eventName":@"CreditCard",@"eventLabel":tagName,@"eventAction":@"click",@"eventValue":firstValue,@"eventValue2":secondValue,@"os":@"ios",@"appName":app_name_type};
        }
    }else{
        //big_申请成功
        if ([JFHSUtilsTool isBlankString:userInfo.xuserloginIdStr]) {
            dic = @{@"channelCode":@"bnh",@"eventName":@"user",@"eventAction":@"largeLoan",@"os":@"ios",@"appName":app_name_type};
        }else{
            dic = @{@"userId":userInfo.xuserloginIdStr,@"channelCode":@"bnh",@"eventName":@"user",@"eventAction":@"largeLoan",@"os":@"ios",@"appName":app_name_type};
        }
    }
    NSString *submitUrl =[JFHSUtilsTool conectUrl:[dic mutableCopy] url:logUrl];
    if (![JFHSUtilsTool isBlankString:userInfo.xuserloginIdStr]) {
        
        [PPNetworkHelper setValue:userInfo.loginSuccessKey forHTTPHeaderField:@"API_KEY"];
    }
    [PPNetworkHelper setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [PPNetworkHelper POST:submitUrl parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
}
@end
