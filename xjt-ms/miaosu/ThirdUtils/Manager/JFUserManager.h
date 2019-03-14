//
//  JFUserManager.h
//  petassistant
//
//  Created by Daisy  on 2018/10/10.
//  Copyright © 2018年 com.wp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFUserManager : NSObject
+ (instancetype)shareManager;

@property (nonatomic, strong) JFUserInfoTool *currentUserInfo;
@end
