//
//  JTCertificationView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTCertificationView.h"

@implementation JTCertificationView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self innitView];
    }
    return self;
}
-(void)innitView{
    //添加背景图片
    UIImage *image = [UIImage imageNamed:@"headerHome"];
    self.layer.contents = (id) image.CGImage;
    
    self.leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.titleLable  = [UILabel new];
    self.firstNameLable  = [UILabel new];
    self.secondNameLable  = [UILabel new];
    self.numberLable  = [UILabel new];
     self.detailNameLable  = [UILabel new];
    self.middleImg  = [UIImageView new];
    
    [self addSubview:self.middleImg];
    [self.middleImg addSubview:self.numberLable];
    [self addSubview:self.secondNameLable];
    [self addSubview:self.firstNameLable];
    [self addSubview:self.detailNameLable];
    [self addSubview:self.leftBtn];
    [self addSubview:self.titleLable];
    
    [self.leftBtn setImage:[UIImage imageNamed:@"Path"] forState:UIControlStateNormal];
    //
    self.titleLable.text  = @"认证中心";
    self.titleLable.textColor  =[UIColor whiteColor];
     self.detailNameLable.textColor  =[UIColor whiteColor];
     self.firstNameLable.textColor  =[UIColor whiteColor];
     self.secondNameLable.textColor  =[UIColor whiteColor];
     self.numberLable.textColor  =[UIColor colorWithHexString:@"#4A90E2"];
    //
    self.firstNameLable.text  = @"已完成";
    self.secondNameLable.text  = @"项认证";
    self.detailNameLable.text  = @"实名认证通过后才能继续其他认证";
    self.middleImg.image  =[UIImage imageNamed:@"certificationBG"];
    
    //
    if (JT_IS_iPhone5) {
     self.titleLable.font =  kFontSystem(16);
        self.firstNameLable.font  = kFontSystem(16);
         self.secondNameLable.font  = kFontSystem(16);
         self.detailNameLable.font  = kFontSystem(12);
        self.numberLable.font  = kFontSystem(22);
    }else{
        self.titleLable.font =  kFontSystem(18);
         self.firstNameLable.font  = kFontSystem(18);
         self.secondNameLable.font  = kFontSystem(18);
         self.detailNameLable.font  = kFontSystem(14);
        self.numberLable.font  = kFontSystem(24);
    }
      [self makeConstraints];
     [self.leftBtn addTarget:self action:@selector(leftBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
   [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -kMySize(self.leftBtn.imageView.image.size.width)-20 *JT_ADAOTER_WIDTH, 0, 0)];
    
}
-(void)makeConstraints{
    //左侧图标
   
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(JT_STATUS_BAR_HEIGHT + 14 *JT_ADAOTER_WIDTH);
        make.size.mas_equalTo(CGSizeMake(60*JT_ADAOTER_WIDTH, 22 *JT_ADAOTER_WIDTH));
        make.left.equalTo(self.mas_left).offset(15*JT_ADAOTER_WIDTH);
    }];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftBtn);
        make.centerX.equalTo(self);
    }];
    [self.middleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60*JT_ADAOTER_WIDTH, 60 *JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLable.mas_bottom).offset(35 * JT_ADAOTER_WIDTH);
    }];
    [self.firstNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleImg);
        make.right.equalTo(self.middleImg.mas_left).offset(-3);
    }];
    [self.secondNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleImg);
        make.left.equalTo(self.middleImg.mas_right).offset(3);
    }];
    [self.numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.middleImg);
    }];
    [self.detailNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-10*JT_ADAOTER_WIDTH);
    }];
     self.numberLable.text = @"0";
}
-(void)leftBtnClickEvent{
    if ([self.certificationDelegate respondsToSelector:@selector(certificationleftBarButtonItemEvent)]) {
        [self.certificationDelegate certificationleftBarButtonItemEvent];
    }
}
-(void)getAreadyCeitication:(NSString *)numberStr{
    if ([JFHSUtilsTool isBlankString:numberStr]) {
        self.numberLable.text = @"0";
    }else{
        
        self.numberLable.text = numberStr;
    }
}
@end
