//
//  JFUserLoginViewController.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/24.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFBaseViewControllerEdit.h"
#import "JFThirdNewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JFUserLoginViewController : JFBaseViewControllerEdit
@property (nonatomic, strong)NSString *jumControllerVC;//跳转的界面
@property (nonatomic, strong)NSString *requestStr;//跳转界面的参数
//creditCard界面
@property (nonatomic, strong)NSString *cityStr;//跳转界面的参数
@property (nonatomic, strong)NSString *titleStr;//页面title
@property (nonatomic, strong)UIImageView *portraintImg;//头像
@property (nonatomic, strong)UILabel *nameLable;//更改i姓名
@property (nonatomic, strong)NSArray *loginWebArr;//用于神策数据提交
@property (nonatomic,assign)NSInteger catagreIdx;//办creditCard界面
@property (nonatomic, strong)JFThirdNewModel *cardNewModel;//跳转界面的参数
@end

NS_ASSUME_NONNULL_END
