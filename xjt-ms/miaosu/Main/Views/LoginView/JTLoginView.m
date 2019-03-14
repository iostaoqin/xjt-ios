//
//  JTLoginView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTLoginView.h"

@implementation JTLoginView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =[super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.lineLable= [UILabel new];
    self.registedBtn= [UIButton new];
    self.forgotBtn= [UIButton new];
    [self addSubview:self.forgotBtn];
    [self addSubview:self.registedBtn];
    [self addSubview:self.lineLable];
    
    [self.registedBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.registedBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.forgotBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgotBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    if (JT_IS_iPhone5) {
        self.registedBtn.titleLabel.font = kFontSystem(14);
         self.forgotBtn.titleLabel.font = kFontSystem(14);
    }else{
        self.registedBtn.titleLabel.font = kFontSystem(16);
         self.forgotBtn.titleLabel.font = kFontSystem(16);
    }
    self.lineLable.backgroundColor =[UIColor colorWithHexString:@"#666666"];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
        make.center.equalTo(self);
    }];
    [self.registedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineLable.mas_left).offset(-40);
        make.centerY.equalTo(self.lineLable);
    }];
    [self.forgotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineLable.mas_right).offset(40);
        make.centerY.equalTo(self.lineLable);
    }];
    [self.registedBtn addTarget:self action:@selector(registedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.forgotBtn addTarget:self action:@selector(forgotBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)registedBtnClick{
    if ([self.delegate respondsToSelector:@selector(registedClick)]) {
        [self.delegate registedClick];
    }
}
-(void)forgotBtnClick{
    if ([self.delegate respondsToSelector:@selector(forgotPasswordClick)]) {
        [self.delegate forgotPasswordClick];
    }
}
@end
