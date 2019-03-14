//
//  JFEditSucessViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/27.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFEditSucessViewController.h"

@interface JFEditSucessViewController ()

@end

@implementation JFEditSucessViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButtonItemWithImage:@"mine_comeBack_img" slected:@"mine_comeBack_img"];
    self.title= @"提交成功";
    [self setEmptyUI];
}
-(void)setEmptyUI{
    UIImageView *emptyImg=  [UIImageView new];
    [self.view addSubview:emptyImg];
    emptyImg.image =[UIImage imageNamed:@"ApplicationSuccessTipsImg"];
    [emptyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150 * JT_ADAOTER_WIDTH, 150 * JT_ADAOTER_WIDTH));
        make.top.equalTo(self.view.mas_top).offset(40 * JT_ADAOTER_WIDTH + JT_NAV);
        make.centerX.equalTo(self.view);
    }];
    UILabel *sucessLable = [UILabel new];
    [self.view addSubview:sucessLable];
    sucessLable.text = [JFHSUtilsTool decodeFromPercentEscapeString:congratulations_tips_text];;
    sucessLable.font = kFontSystem(18);
    sucessLable.textColor = [UIColor colorWithHexString:@"333333"];
    [sucessLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.view);
        make.top.equalTo(emptyImg.mas_bottom).offset(20 * JT_ADAOTER_WIDTH);
    }];
//    UILabel *sucessTipsLable = [UILabel new];
//    [self.view addSubview:sucessTipsLable];
//    sucessTipsLable.text = @"请12天之后再来申请";
//    sucessTipsLable.font = kFontSystem(14);
//    sucessTipsLable.textColor = [UIColor colorWithHexString:@"999999"];
//    [sucessTipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(sucessLable.mas_bottom).offset(20 * JT_ADAOTER_WIDTH);
//    }];
    UIView *lableView  = [UIView new];
    [self.view addSubview:lableView];
    lableView.layer.borderWidth  =1;
    lableView.layer.borderColor  = [UIColor colorWithHexString:@"#EEEEEE"].CGColor;
    [lableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16 * JT_ADAOTER_WIDTH);
        make.right.equalTo(self.view.mas_right).offset(-16* JT_ADAOTER_WIDTH);
        make.top.equalTo(sucessLable.mas_bottom).offset(80* JT_ADAOTER_WIDTH);
        make.height.mas_equalTo(50 * JT_ADAOTER_WIDTH);
    }];
    UILabel *borrowLable = [UILabel new];
    [lableView addSubview:borrowLable];
    borrowLable.textColor = [UIColor colorWithHexString:@"#333333"];
    borrowLable.font   = kFontSystem(16);
    NSString  *str   =  [NSString stringWithFormat:@"借款金额: %@元",self.dataArr[0]];
    borrowLable.attributedText  =[JFHSUtilsTool attributedString:str selectedStr:[NSString stringWithFormat:@"%@元",self.dataArr[0]] selctedColor:@"#FF4D4F"haspreStr:@"借款金额: "];
    [borrowLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lableView);
        make.left.equalTo(lableView.mas_left).offset(12 * JT_ADAOTER_WIDTH);
    }];
    UILabel *linLable   = [UILabel new];
    linLable.backgroundColor =[UIColor colorWithHexString:@"#EEEEEE"];
    [lableView addSubview:linLable];
    [linLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.center.equalTo(lableView);
        make.height.equalTo(lableView);
    }];
    UILabel *giveLimitLable  = [UILabel new];
    [lableView addSubview:giveLimitLable];
    giveLimitLable.textColor = [UIColor colorWithHexString:@"#333333"];
    giveLimitLable.font   = kFontSystem(16);
    NSString  *loanTime = [JFHSUtilsTool decodeFromPercentEscapeString:@" %E8%B4%B7%E6%AC%BE%E6%9C%9F%E9%99%90"];
    NSString *limitStr  =   [NSString stringWithFormat:@"%@: %@个月",loanTime,self.dataArr[1]];
    giveLimitLable.attributedText  = [JFHSUtilsTool attributedString:limitStr selectedStr:[NSString stringWithFormat:@"%@个月",self.dataArr[1]] selctedColor:@"#FF4D4F" haspreStr:[NSString stringWithFormat:@"%@: ",loanTime]];
    [giveLimitLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lableView);
        make.right.equalTo(lableView.mas_right).offset(-12 * JT_ADAOTER_WIDTH);
    }];
}
-(void)leftBarButtonItemEvent:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
