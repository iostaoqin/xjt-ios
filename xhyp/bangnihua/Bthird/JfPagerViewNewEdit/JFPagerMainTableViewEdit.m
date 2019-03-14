//
//  JFPagerMainTableViewEdit.m
//  JFPagerViewEdit
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JFPagerMainTableViewEdit.h"

@interface JFPagerMainTableViewEdit ()<UIGestureRecognizerDelegate>

@end

@implementation JFPagerMainTableViewEdit

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.gestureDelegate && [self.gestureDelegate respondsToSelector:@selector(mainTableViewGestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.gestureDelegate mainTableViewGestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }else {
        return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    }
}

@end
