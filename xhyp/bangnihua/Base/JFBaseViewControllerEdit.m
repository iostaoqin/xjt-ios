//
//  JFBaseViewControllerEdit.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/24.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFBaseViewControllerEdit.h"

@interface JFBaseViewControllerEdit ()
@property (nonatomic, strong)UIView *batteryView;
@end

@implementation JFBaseViewControllerEdit

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets   = NO;
    }
}
-(void)changeBatteryColor:(NSString *)colorStr{
    self.batteryView.backgroundColor  = [UIColor colorWithHexString:colorStr];
}
-(UIView *)batteryView{
    if (!_batteryView) {
        CGFloat statwidth = [[UIApplication sharedApplication]statusBarFrame].size.width;
        CGFloat statheight = [[UIApplication sharedApplication]statusBarFrame].size.height;
        _batteryView = [[UIView alloc]initWithFrame:CGRectMake(0,0, statwidth, statheight)];
        [self.view addSubview:_batteryView];
    }
    return _batteryView;
}
-(void)addLeftFirstBtn:(NSString *)firstLeftBtnStr secondBtn:(NSString *)secondLeftBtnStr{
    if (!firstLeftBtnStr && !secondLeftBtnStr) {
        return;
    }
    UIButton *firstBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstBtn setImage:[UIImage imageNamed:firstLeftBtnStr] forState:UIControlStateNormal];
    [firstBtn setImage:[UIImage imageNamed:firstLeftBtnStr] forState:UIControlStateSelected];
    [firstBtn setImage:[UIImage imageNamed:firstLeftBtnStr] forState:UIControlStateHighlighted];
    [firstBtn setFrame:CGRectMake(-50, 0, 30, 44)];
    [firstBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [firstBtn addTarget:self action:@selector(firstleftEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondBtn setTitle:secondLeftBtnStr forState:UIControlStateNormal];
    secondBtn.titleLabel.font = kFontSystem(14);
        [secondBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    CGFloat width = [secondLeftBtnStr sizeOfNSStringWithFont:secondBtn.titleLabel.font].width;
    secondBtn.frame = CGRectMake(0, 0, width, 44);
        [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -width / 2 - 10, 0, 0)];
    [secondBtn addTarget:secondBtn action:@selector(secondleftEvent) forControlEvents:UIControlEventTouchUpInside];
    //添加在导航栏左侧
    UIBarButtonItem *firstItem =[[UIBarButtonItem alloc]initWithCustomView:firstBtn];
    UIBarButtonItem *secondItem =[[UIBarButtonItem alloc]initWithCustomView:secondBtn];
    self.navigationItem.leftBarButtonItems  = @[firstItem,secondItem];
}
-(void)firstleftEvent{
    
}
-(void)secondleftEvent{
    
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
        [btnLeft setFrame:CGRectMake(-50, 0, 30, 44)];
        btnLeft.contentMode = UIViewContentModeCenter;
        [btnLeft setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    }
    [btnLeft addTarget:self action:@selector(leftBarButtonItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
-(void)leftBarButtonItemEvent:(UIButton  *)sender{
    
}
#pragma mark   - 左侧两个按钮均是图片
- (void)addLeftButtonItemWithImage:(NSString *)nameImg secondImg:(NSString *)secondImg{
    if (!nameImg && !secondImg) {
        return;
    }
    //
    UIButton *firstBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstBtn setImage:[UIImage imageNamed:nameImg] forState:UIControlStateNormal];
    [firstBtn setImage:[UIImage imageNamed:nameImg] forState:UIControlStateSelected];
    [firstBtn setImage:[UIImage imageNamed:nameImg] forState:UIControlStateHighlighted];
    [firstBtn setFrame:CGRectMake(-50, 0, 30, 44)];
    [firstBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [firstBtn addTarget:self action:@selector(firstCloseImgEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondBtn setImage:[UIImage imageNamed:secondImg] forState:UIControlStateNormal];
    [secondBtn setImage:[UIImage imageNamed:secondImg] forState:UIControlStateSelected];
    [secondBtn setImage:[UIImage imageNamed:secondImg] forState:UIControlStateHighlighted];
    CGFloat width = [secondImg sizeOfNSStringWithFont:secondBtn.titleLabel.font].width;
    secondBtn.frame = CGRectMake(0, 0, width/3, 44);
//    secondBtn.backgroundColor = [UIColor redColor];
//    [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -width / 2 - 10, 0, 0)];
     [secondBtn addTarget:self action:@selector(secondCloseImgEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加在导航栏左侧
    UIBarButtonItem *firstItem =[[UIBarButtonItem alloc]initWithCustomView:firstBtn];
    UIBarButtonItem *secondItem =[[UIBarButtonItem alloc]initWithCustomView:secondBtn];
    self.navigationItem.leftBarButtonItems  = @[firstItem,secondItem];
    
    
}
-(void)firstCloseImgEvent:(UIButton *)btn{
    
}
-(void)secondCloseImgEvent:(UIButton *)btn{
    
}

@end
