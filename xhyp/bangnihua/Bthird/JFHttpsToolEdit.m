//
//  JFHttpsToolEdit.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/2.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFHttpsToolEdit.h"

@implementation JFHttpsToolEdit
+(instancetype)sharedClient{
    static JFHttpsToolEdit *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JFHttpsToolEdit alloc] initWithBaseURL:nil];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer  =[AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer  serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        
        
    });
    return _sharedClient;
    
    
}
+(NSURLSessionDataTask  *)requestType:(NSString *)type  putWithUrl:(NSString  *)url withParameter:(NSDictionary  *)dic withSuccess:(void(^)(id data,NSString *msg))successBlock
                     withErrorCodeTwo:(void(^)(void))errorCodeTwo
                       withErrorBlock:(void(^)(NSError *error))errorBlock{
    NSURLSessionDataTask  *task;
    NSString  *urlStr = url;
     NSString *putStr = [JFHSUtilsTool convertToJsonData:dic];
    NSData *putData = [putStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request  =  [[AFJSONRequestSerializer serializer]requestWithMethod:type URLString:urlStr parameters:nil error:nil];
    [request setHTTPBody:putData];
    JFUserInfoTool  *user  = [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:user.loginSuccessKey]) {
        [request setValue:user.loginSuccessKey forHTTPHeaderField:@"API_KEY"];
    }
    [request setValue:[NSString stringWithFormat:@"%lu",putData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [[[JFHttpsToolEdit sharedClient]dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
         NSInteger errorCode = [dic[@"resultCode"] integerValue];
        NSString *msg = dic[@"resultCodeMessage"];
        //成功返回
        successBlock(dic,msg);
        if (errorCode == 0) {
           
        }else{
            //提示用户
//            [[JFHudMsgEditTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:msg];
//            [[JFHudMsgEditTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            
        }
         errorBlock(error);
        
        
    }]resume];
    return task;
}
@end
