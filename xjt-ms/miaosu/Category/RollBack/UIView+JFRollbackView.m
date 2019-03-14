//
//  UIView+JFRollbackView.m
//  tengwan
//
//  Created by 陶陶琴 on 2017/4/10.
//  Copyright © 2017年 深圳藤蔓信息科技有限公司. All rights reserved.
//

#import "UIView+JFRollbackView.h"

@implementation UIView (TWRollbackView)
/** 判断self和anotherView是否重叠 */
- (BOOL)hu_intersectsWithAnotherView:(UIView *)anotherView
{
    
    //如果anotherView为nil，那么就代表keyWindow
    if (anotherView == nil) anotherView = [UIApplication sharedApplication].keyWindow;
    
    
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    
    CGRect anotherRect = [anotherView convertRect:anotherView.bounds toView:nil];
    
    //CGRectIntersectsRect是否有交叉
    return CGRectIntersectsRect(selfRect, anotherRect);
}
@end
