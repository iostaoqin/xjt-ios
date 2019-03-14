//
//  JTRegistedView.m
//  xiaojintiao
//
//  Created by Daisy  on 2019/2/15.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTRegistedView.h"

@implementation JTRegistedView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.registImg =[UIImageView new];
    self.registNameLable =[UILabel new];
    //    self.registAlreadyBtn =[UIButton new];
    [self addSubview:self.registImg];
    [self addSubview:self.registNameLable];
    //    [self addSubview:self.registAlreadyBtn];
    
    
    self.registImg.image=[UIImage imageNamed:@"agree"];
    //
    self.registNameLable.textColor  = [UIColor colorWithHexString:@"#333333"];
    NSString *areenStr =@"已阅读并同意用户注册协议";
    self.registNameLable.attributedText  =[JFHSUtilsTool attributedString:areenStr selectedStr:@"用户注册协议" selctedColor:@"#10ADDB"haspreStr:@"已阅读并同意"];
    
    [self.registAlreadyBtn setTitle:@"已有账号,立即登录" forState:UIControlStateNormal];
    [self.registAlreadyBtn setTitleColor:[UIColor colorWithHexString:@"#FF8B00"] forState:UIControlStateNormal];
    
    CGFloat registFont;
    
    
    if (JT_IS_iPhone5) {
        registFont  = 16;
        self.registNameLable.font = kFontSystem(12);
        self.registAlreadyBtn.titleLabel.font = kFontSystem(12);
    }else{
        registFont  = 18;
        self.registNameLable.font = kFontSystem(14);
        self.registAlreadyBtn.titleLabel.font = kFontSystem(14);
    }
    self.registBtn =[self buttonCreateGradientWithCornerRadius:6 btnWidth:315*JT_ADAOTER_WIDTH btnHeight:46*JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
    [self addSubview:self.registBtn];
    [self.registBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.registBtn.titleLabel.font = kFontSystem(registFont);

    [self.registImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30 *JT_ADAOTER_WIDTH);
        make.size.mas_equalTo(CGSizeMake(21 *JT_ADAOTER_WIDTH, 20 *JT_ADAOTER_WIDTH));
        make.top.equalTo(self.mas_top).offset(26 *JT_ADAOTER_WIDTH);
    }];
    [self.registNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registImg.mas_right).offset(5);
//        make.top.equalTo(self.registImg.mas_top);
        make.centerY.equalTo(self.registImg);
    }];
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(315 *JT_ADAOTER_WIDTH, 46 *JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self);
        make.top.equalTo(self.registNameLable.mas_bottom).offset(60 *JT_ADAOTER_WIDTH);
    }];
    [self.registAlreadyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.registBtn.mas_bottom).offset(30 *JT_ADAOTER_WIDTH);
    }];
    //用户协议-->添加手势
    UITapGestureRecognizer *regist  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureEventClick)];
    [self.registNameLable addGestureRecognizer:regist];
    self.registNameLable.userInteractionEnabled  = YES;
    //注册
    [self.registBtn addTarget:self action:@selector(registEventClick) forControlEvents:UIControlEventTouchUpInside];
    //已有账号立即登录
    //    [self.registAlreadyBtn addTarget:self action:@selector(registAlreadyBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)tapgestureEventClick{
    if ([self.registDelegate respondsToSelector:@selector(registedAgreenment)]) {
        [self.registDelegate registedAgreenment];
    }
}
-(void)registEventClick{
    if ([self.registDelegate respondsToSelector:@selector(registBtnClick)]) {
        [self.registDelegate registBtnClick];
    }
}
-(void)registAlreadyBtnClick{
    if ([self.registDelegate respondsToSelector:@selector(alreadyAccountClick)]) {
        [self.registDelegate alreadyAccountClick];
    }
}
@end
