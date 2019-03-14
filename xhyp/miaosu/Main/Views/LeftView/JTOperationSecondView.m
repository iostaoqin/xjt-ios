//
//  JTOperationSecondView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTOperationSecondView.h"

@implementation JTOperationSecondView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initOperationView];
    }
    return self;
}
-(void)initOperationView{
    self.nameLable =[UILabel new];
    self.pointImg =[UIImageView new];
    self.firstNameLable =[UILabel new];
    self.secondNameLable =[UILabel new];
    self.thirdNameLable =[UILabel new];
    self.againSubmitBtn =[UIButton new];
    
    [self addSubview:self.againSubmitBtn];
    [self addSubview:self.secondNameLable];
    [self addSubview:self.thirdNameLable];
    [self addSubview:self.firstNameLable];
    [self addSubview:self.pointImg];
    [self addSubview:self.nameLable];
    //;
    self.nameLable.textColor   = [UIColor colorWithHexString:@"#333333"];
    self.pointImg.image  =[UIImage imageNamed:@"point"];
    self.firstNameLable.textColor   = [UIColor colorWithHexString:@"#666666"];
     self.secondNameLable.textColor   = [UIColor colorWithHexString:@"#333333"];
    self.thirdNameLable.textColor   = [UIColor colorWithHexString:@"#999999"];
    //btn
    [self.againSubmitBtn setTitle:@"重新提交审核" forState:UIControlStateNormal];
    [self.againSubmitBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    self.againSubmitBtn.layer.cornerRadius = 3;
    self.againSubmitBtn.layer.borderWidth = 1;
    self.againSubmitBtn.layer.borderColor  =[UIColor colorWithHexString:@"#D9D9D9"].CGColor;
    self.againSubmitBtn.layer.masksToBounds= YES;
    
    if (JT_IS_iPhone5) {
        self.nameLable.font  = kFontSystem(14);
        self.firstNameLable.font  = kFontSystem(12);
        self.secondNameLable.font  = kFontSystem(12);
        self.thirdNameLable.font  = kFontSystem(10);
        self.againSubmitBtn.titleLabel.font = kFontSystem(14);
    }else{
    self.nameLable.font  = kFontSystem(16);
        self.firstNameLable.font  = kFontSystem(14);
        self.secondNameLable.font  = kFontSystem(14);
        self.thirdNameLable.font  = kFontSystem(12);
        self.againSubmitBtn.titleLabel.font = kFontSystem(16);
    }
    self.againSubmitBtn.hidden  = YES;
    [self makeConstraints];
    
    
}
-(void)makeConstraints{
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(18);
    }];
    [self.pointImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.left.equalTo(self.mas_left).offset(20 *JT_ADAOTER_WIDTH);
        make.top.equalTo(self.nameLable.mas_bottom).offset(36 *JT_ADAOTER_WIDTH);
    }];
    [self.firstNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointImg);
        make.left.equalTo(self.pointImg.mas_right).offset(10);
    }];
    [self.secondNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstNameLable);
        make.top.equalTo(self.firstNameLable.mas_bottom).offset(12);
    }];
    [self.thirdNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstNameLable);
        make.top.equalTo(self.secondNameLable.mas_bottom).offset(12);
    }];
    [self.againSubmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(140 *JT_ADAOTER_WIDTH, 36*JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-12*JT_ADAOTER_WIDTH);
    }];
    [self.againSubmitBtn addTarget:self action:@selector(againSubmitBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)gettTiltNameStr:(NSString *)title detailStrArr:(NSArray *)detailStr showType:(NSInteger)type{
    if (type  == 2) {
        //失败
        self.againSubmitBtn.hidden  = NO;
    }
    self.nameLable.text  = title;
    self.firstNameLable.text  = detailStr[0];
    self.secondNameLable.text  = detailStr[1];
    self.thirdNameLable.text  = detailStr[2];
}
-(void)againSubmitBtnClick{
    if ([self.delegate respondsToSelector:@selector(againSubmitEvent)]) {
        [self.delegate againSubmitEvent];
    }
}
@end
