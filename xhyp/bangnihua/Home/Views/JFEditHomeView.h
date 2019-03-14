//
//  JFEditHomeView.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/6.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFPagerViewEdit.h"
NS_ASSUME_NONNULL_BEGIN

@interface JFEditHomeView : UIView<JFPagerViewEditListViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *giveMarr;
@property (nonatomic, strong)UIViewController *temVC;
@property (nonatomic, assign) BOOL isNeedFooter;
@property (nonatomic, assign) BOOL isNeedHeader;
@property (nonatomic, assign) BOOL isHeaderRefreshed;   //默认为YES
@property (nonatomic, strong)JFEditHomemodel *homeModel;//
@property (nonatomic, strong)JFDataFooterView *footerView;
-(void)dropdownRefreshHeader;
@end

NS_ASSUME_NONNULL_END
