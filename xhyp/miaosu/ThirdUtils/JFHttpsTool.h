//
//  JFHttpsTool.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/2.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFHttpsTool : AFHTTPSessionManager
+(instancetype)sharedClient;
+(NSURLSessionDataTask  *)requestType:(NSString *)type passwordStr:(NSString *)password putWithUrl:(NSString  *)url withParameter:(NSDictionary  *)dic withSuccess:(void(^)(id data,NSString *msg))successBlock
                     withErrorCodeTwo:(void(^)(void))errorCodeTwo
                       withErrorBlock:(void(^)(NSError *error))errorBlock;


@end

NS_ASSUME_NONNULL_END
