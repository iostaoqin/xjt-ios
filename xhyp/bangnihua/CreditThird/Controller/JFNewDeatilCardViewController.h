//
//  JFNewDeatilCardViewController.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFBaseViewControllerEdit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFNewDeatilCardViewController : JFBaseViewControllerEdit
@property (nonatomic, strong)NSString *cityStr;
@property (nonatomic, strong)NSString *whereVC;
@property (nonatomic, strong)NSString *categoryID;
@property (nonatomic, strong)JFThirdNewModel *cardModel;
@property (nonatomic,  strong)NSString *categoryIdx;//点击分类的idx  从1开始
@end

NS_ASSUME_NONNULL_END
