//
//  JTBaseViewController.m
//  xiaojintiao
//
//  Created by Daisy  on 2019/2/14.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseViewController.h"
#import "JTRenewalView.h"
@interface JTBaseViewController ()<renewalViewDelegate>
@property (nonatomic, strong)UIView *renewalBgView;
@property (nonatomic, strong)JTRenewalView *renewalContentView;
@property (nonatomic, strong)dispatch_source_t baseTimer;
@end

@implementation JTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        self.automaticallyAdjustsScrollViewInsets   = NO;
    }
    [self chageNavigationBgColor];
}
-(void)chageNavigationBgColor{
    //如果是用户操作了新颜认证 需要重新设置导航栏 的背景颜色
    //设置背景颜色渐变
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_NAV)];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#10ACDC"] CGColor],(id)[UIColor colorWithHexString:@"#00D4C7"].CGColor]];//渐变数组
    gradientLayer.locations = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = backView.frame;
    [backView.layer addSublayer:gradientLayer];
    [self.navigationController.navigationBar setBackgroundImage:[self convertViewToImage:backView] forBarMetrics:UIBarMetricsDefault];
    
    [self addLeftButtonItemWithImage:@"Path" slected:@"Path"];
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
- (void)addLeftButtonItemWithImage:(NSString *)name slected:(NSString *)nameSelected{
    if (!name && !nameSelected) {
        return;
    }
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([nameSelected isEqualToString:@"title"]) {
        [btnLeft setTitle:name forState:UIControlStateNormal];
        btnLeft.titleLabel.font = kFontSystem(14);
        [btnLeft setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    }else{
        
        [btnLeft setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [btnLeft setImage:[UIImage imageNamed:nameSelected] forState:UIControlStateSelected];
        [btnLeft setImage:[UIImage imageNamed:nameSelected] forState:UIControlStateHighlighted];
        [btnLeft setFrame:CGRectMake(0, 0, 3 * kMySize(btnLeft.imageView.image.size.width), kMySize(btnLeft.imageView.image.size.height))];
        btnLeft.contentMode = UIViewContentModeCenter;
        [btnLeft setImageEdgeInsets:UIEdgeInsetsMake(0, -kMySize(btnLeft.imageView.image.size.width) -10, 0, 0)];
    }
//    btnLeft.backgroundColor  =[UIColor redColor];
    [btnLeft addTarget:self action:@selector(leftBarButtonItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
- (void)addRightButtonItemWithImage:(NSString *)name selected:(NSString *)nameSel{
    if (!name && !nameSel) {
        return;
    }
    
    UIButton *btnRight;
    //    btnRight.backgroundColor = kColorRed;
    
    if ([nameSel isEqualToString:@"title"]) {//只设置title
        btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRight setTitle:name forState:UIControlStateNormal];
        if (JT_IS_iPhone5) {
            btnRight.titleLabel.font = kFontSystem(14);
        }else{
            btnRight.titleLabel.font = kFontSystem(16);
        }
        [btnRight setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        btnRight.contentMode = UIViewContentModeCenter;
        CGFloat width = [name sizeOfNSStringWithFont:btnRight.titleLabel.font].width;
        [btnRight setFrame:CGRectMake(0, 0, 2*width, 44)];
        [btnRight setTitleEdgeInsets:UIEdgeInsetsMake(0, width, 0, 0)];
    } else {//设置图片
        btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btnRight setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        [btnRight setImage:[UIImage imageNamed:nameSel] forState:UIControlStateSelected];
        [btnRight setImage:[UIImage imageNamed:nameSel] forState:UIControlStateHighlighted];
        
        [btnRight setFrame:CGRectMake(0, 0, 2 * kMySize(btnRight.imageView.image.size.width), kMySize(btnRight.imageView.image.size.height))];
        
        [btnRight setImageEdgeInsets:UIEdgeInsetsMake(0, kMySize(btnRight.imageView.image.size.width), 0, 0)];
    }
    [btnRight addTarget:self action:@selector(rightBarButtonItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)getCodeBtn:(UIButton *)codeBtn{
    __block int timeout = 60; //（秒）倒计时时间
    if (self.baseTimer) {
         dispatch_source_cancel(self.baseTimer);
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.baseTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.baseTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.baseTimer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(self.baseTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置 特别注明：UI的改变一定要在主线程中进行
                if (codeBtn!=nil) {
                    [codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    codeBtn.userInteractionEnabled = YES;
                }
            });
        }else{
            
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (codeBtn !=nil) {
                    [codeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                    codeBtn.userInteractionEnabled = NO;
                }
            });
            timeout--;
            
        }
    });
    dispatch_resume(self.baseTimer);
    
}
-(void)leftBarButtonItemEvent:(UIButton  *)sender{
    
}
- (void)rightBarButtonItemEvent:(UIButton *)sender {
  
}
-(void)renewalUI:(NSArray *)nameArr showType:(NSString *)type tele:(NSString *)xteleNumberStr{
    self.renewalBgView.hidden = NO;
    self.renewalContentView.hidden = NO;
    [_renewalContentView getFirstContent:nameArr showType:type televalue:xteleNumberStr];
}
-(UIView *)renewalBgView{
    if (!_renewalBgView) {
        _renewalBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JT_ScreenW, JT_ScreenH)];
        _renewalBgView.backgroundColor = [UIColor blackColor];
        _renewalBgView.alpha = .5;
         [[UIApplication sharedApplication].keyWindow addSubview:_renewalBgView];
    }
    return _renewalBgView;
}
-(void)getCodeEventClick:(UIButton *)codeBtn{
    
}
-(void)firstRenewalBtnEventClick:(UIButton  *)codebtn{
   
}
-(void)secondRenewalBtnEventClick:(NSString *)codeStr{
    
}
-(void)closeWindsEventClick{
    
}
-(void)RenewalCancelBtnEventClick{
//    [_renewalBgView removeFromSuperview];
    _renewalBgView.hidden = YES;
    _renewalContentView.hidden = YES;
    _renewalContentView.secondCodeTextFied.text = @"";
//    [_renewalContentView removeFromSuperview];
}
-(void)codeEvent:(UIButton *)codebtn{
//    [_renewalBgView removeFromSuperview];
//    [_renewalContentView removeFromSuperview];
    [self getCodeEventClick:codebtn];
}
-(void)fistBtnEventClick:(UIButton *)codebtn{
//    [_renewalBgView removeFromSuperview];
//    [_renewalContentView removeFromSuperview];
    _renewalBgView.hidden = YES;
    _renewalContentView.hidden = YES;
    _renewalContentView.secondCodeTextFied.text = @"";
    [self firstRenewalBtnEventClick:codebtn];
}
-(void)secondBtnEventClick:(NSString *)codeStr{
    //验证码传值
    [self secondRenewalBtnEventClick:codeStr];
}
-(void)closeBtnEventClick{
    [self closeWindsEventClick];
}
-(void)cancelBtnEventClick{
    [self RenewalCancelBtnEventClick];
}
#pragma mark -获取验证弹出的稍后事件
-(void)cancelCodeSecondBtnEventClick{
    _renewalBgView.hidden = YES;
    _renewalContentView.hidden = YES;
}
-(void)alertCerticationMsg:(NSString *)msg tipsStr:(NSString *)tips sureStr:(NSString *)sureStr cancelStr:(NSString *)cancel{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:tips message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到认证页面
//        JTCertificationViewController  *certicationVC =[[JTCertificationViewController alloc]init];
//        [self.navigationController pushViewController:certicationVC animated:YES];
        [self alertSureBtnEvent];
    }];
    [sureAction setValue:[UIColor colorWithHexString:@"#62A7E9"] forKey:@"_titleTextColor"];
    [cancelAction setValue:[UIColor colorWithHexString:@"#666666"] forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
-(void)alertSureBtnEvent{
    
}
-(void )againLogin{
    JTLoginViewController *loginVC  =[[JTLoginViewController alloc]init];
    JTBaseNavigationController *nav = [[JTBaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}
-(JTRenewalView *)renewalContentView{
    if (!_renewalContentView) {
        _renewalContentView =[JTRenewalView new];
        _renewalContentView.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_renewalContentView];
        _renewalContentView.delegate  = self;
        [_renewalContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(JT_ScreenW, JT_ScreenH));
            make.center.equalTo([UIApplication sharedApplication].keyWindow);
        }];
    }
    return _renewalContentView;
}
@end
