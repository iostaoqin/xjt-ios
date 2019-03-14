//
//  JFShanYanRequestEditTool.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/8.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFUserLoginViewController.h"
#import "JFNewDeatilCardViewController.h"
#import "JFEditeUsersInformationViewController.h"
#import "JFSettingUsersViewConntroller.h"
NS_ASSUME_NONNULL_BEGIN

@interface JFShanYanRequestEditTool : NSObject
+(instancetype)shareShanYan;
/***
 *currentVC  当前页面
 * jumVC     跳转的界面
 * parameter 携带的参数
 * webArray  神策提交参数
 */
+(void)requestShanYan:(UIViewController *)currentVC jumpToVC:(NSString *)jumVC jumVCParameter:(NSString *)parameter cityStr:(NSString *)city tittlName:(NSString *)title webArray:(NSArray *)webArr;
/***
 *用于我的界面 头像 的修改  及名称
 *currentVC  当前页面
 * jumVC     跳转的界面
 * parameter 携带的参数
 */
+(void)requestShanYan:(UIViewController *)currentVC jumpToVC:(NSString *)jumVC jumVCParameter:(NSString *)parameter jumVCImg:(UIImageView *)loginImg loginNameLable:(UILabel *)loginName;
/***
 *用于新人办card
 *currentVC  当前页面
 * jumVC     跳转的界面
 * parameter 携带的参数
 */
+(void)requestNewCard:(UIViewController *)currentVC jumpToVC:(NSString *)jumVC jumVCParameter:(NSString *)parameter categorySelectedIdx:(NSInteger )categoryIdx tittlName:(NSString *)title categray:(JFThirdNewModel *)cardModel city:(NSString *)city;
@end

NS_ASSUME_NONNULL_END
