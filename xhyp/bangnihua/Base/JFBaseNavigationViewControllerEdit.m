//
//  JFBaseNavigationViewControllerEdit.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/24.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFBaseNavigationViewControllerEdit.h"

@interface JFBaseNavigationViewControllerEdit ()<UIGestureRecognizerDelegate>

@end

@implementation JFBaseNavigationViewControllerEdit

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏的背景颜色及字体大小
    __weak JFBaseNavigationViewControllerEdit *weakSelf = self;
    weakSelf.navigationBar.titleTextAttributes = @{NSFontAttributeName:kFontSystem(20),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]};
    weakSelf.navigationBar.barTintColor = [UIColor whiteColor];
    
    //获取系统自带滑动手势的target对象
//    id target = self.interactivePopGestureRecognizer.delegate;
//    //创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
//    pan.delegate = self;
//    [self.view addGestureRecognizer:pan];
//    //禁止使用系统自带的滑动手势
//    self.interactivePopGestureRecognizer.enabled = NO;
    
}
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
