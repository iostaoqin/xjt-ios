//
//  TNewMJRefreshAutoNormalFooterEdit.m
//  Logistics
//
//  Created by 9tong on 2018/8/16.
//  Copyright © 2018年 hdk. All rights reserved.
//

#import "TNewMJRefreshAutoNormalFooterEdit.h"

@implementation TNewMJRefreshAutoNormalFooterEdit
#pragma mark - 重写父类的方法
- (void)prepare {
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self setTitle:@" " forState:MJRefreshStateIdle];
    [self setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    [self setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"上拉可以加载更多" forState:MJRefreshStateWillRefresh];
    [self setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
    
}

@end
