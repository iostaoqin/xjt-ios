//
//  JXPagingMainTableView.h
//  JXPagingView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFPagerMainTableViewEditGestureDelegate <NSObject>

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end

@interface JFPagerMainTableViewEdit : UITableView
@property (nonatomic, weak) id<JFPagerMainTableViewEditGestureDelegate> gestureDelegate;
@end
