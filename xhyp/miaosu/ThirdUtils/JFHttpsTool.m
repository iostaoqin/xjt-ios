//
//  JFHttpsTool.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/2.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFHttpsTool.h"

@implementation JFHttpsTool
+(instancetype)sharedClient{
    static JFHttpsTool *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JFHttpsTool alloc] initWithBaseURL:nil];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer  =[AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer  serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        
        
    });
    return _sharedClient;
    
    
}
+(NSURLSessionDataTask  *)requestType:(NSString *)type passwordStr:(NSString *)password putWithUrl:(NSString  *)url withParameter:(NSDictionary  *)dic withSuccess:(void(^)(id data,NSString *msg))successBlock
                     withErrorCodeTwo:(void(^)(void))errorCodeTwo
                       withErrorBlock:(void(^)(NSError *error))errorBlock{
    NSURLSessionDataTask  *task;
    NSString  *urlStr = url;
     NSString *putStr = [JFHSUtilsTool convertToJsonData:dic];
    NSData *putData = [putStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request  =  [[AFJSONRequestSerializer serializer]requestWithMethod:type URLString:urlStr parameters:nil error:nil];
    [request setHTTPBody:putData];

    //密码MD5加密
    if (![JFHSUtilsTool isBlankString:password]) {
        [request setValue:password forHTTPHeaderField:@"password"];
    }
    JFUserInfoTool  *user  = [JFUserManager shareManager].currentUserInfo;
    if (![JFHSUtilsTool isBlankString:user.keyStr]) {
        [request setValue:user.keyStr forHTTPHeaderField:@"API_KEY"];
    }
    
    [request setValue:[NSString stringWithFormat:@"%lu",putData.length] forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [[[JFHttpsTool sharedClient]dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers  error:nil];
//            NSInteger errorCode = [dic[@"resultCode"] integerValue];
            NSString *msg = dic[@"resultCodeMessage"];
            //成功返回
            successBlock(dic,msg);
        }
        
//        if (errorCode == 0) {
//
//        }else{
            //提示用户
//            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:msg];
//            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            
//        }
         errorBlock(error);
        
        
    }]resume];
    return task;
}
@end
