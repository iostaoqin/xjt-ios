//
//  JFGiveDataViewController.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/27.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFBaseViewControllerEdit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFGiveDataViewController : JFBaseViewControllerEdit<JXCategoryListContentViewDelegate>
@property (nonatomic, strong)UIViewController *temVC;
@property (nonatomic,  strong)JFEditHomemodel  *giveModel;
@end

NS_ASSUME_NONNULL_END
