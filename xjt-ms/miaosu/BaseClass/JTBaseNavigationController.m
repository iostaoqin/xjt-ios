//
//  JTBaseNavigationController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseNavigationController.h"
#import "JTBorrowingViewController.h"
#import "JTMainContentViewController.h"
@interface JTBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation JTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏的背景颜色及字体大小
    __weak JTBaseNavigationController *weakSelf = self;
    weakSelf.navigationBar.titleTextAttributes = @{NSFontAttributeName:kFontSystem(20),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffffff"]};
    //设置背景颜色渐变
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_NAV)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
   [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#10ACDC"] CGColor],(id)[UIColor colorWithHexString:@"#00D4C7"].CGColor]];//渐变数组
    gradientLayer.locations = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = backView.frame;
    [backView.layer addSublayer:gradientLayer];
     [self.navigationBar setBackgroundImage:[self convertViewToImage:backView] forBarMetrics:UIBarMetricsDefault];
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
#pragma mark -- UIGestureRecognizerDelegate

// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1 ) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}
//触发之后是否响应手势事件
//处理侧滑返回与UISlider的拖动手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //如果手势是触摸的UISlider滑块触发的，侧滑返回手势就不响应
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
   
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;      //关闭手势
//    }
    return YES;
}

-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需  要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
