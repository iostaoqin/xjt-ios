//
//  JTBankSucessView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBankSucessView.h"

@implementation JTBankSucessView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self innitView];
    }
    return self;
}
-(void)innitView{
    self.timeLable  =  [UILabel new];
    self.bankLogoImg  =  [UIImageView new];
    self.bankNameLable  =  [UILabel new];
    self.bankNumberNameLable  =  [UILabel new];
    [self addSubview:self.bankNumberNameLable];
    [self addSubview:self.bankLogoImg];
    [self addSubview:self.bankNameLable];
    [self addSubview:self.timeLable];
    
    if (JT_IS_iPhone5) {
        self.timeLable.font  = kFontSystem(10);
        self.bankNameLable.font  = kFontSystem(16);
        self.bankNumberNameLable.font  = kFontSystem(18);
    }else{
        self.timeLable.font  = kFontSystem(12);
        self.bankNameLable.font  = kFontSystem(18);
        self.bankNumberNameLable.font  = kFontSystem(20);
    }
    
    self.timeLable.textColor  =[UIColor colorWithHexString:@"#FEFEFE"];
    self.bankLogoImg.backgroundColor =[UIColor whiteColor];
    self.bankLogoImg.layer.cornerRadius=  35/2  *JT_ADAOTER_WIDTH;
    self.bankLogoImg.layer.borderWidth = 1;
    self.bankLogoImg.layer.borderColor= [UIColor clearColor].CGColor;
    self.bankLogoImg.layer.masksToBounds= YES;
    
    self.bankNameLable.textColor  =[UIColor colorWithHexString:@"#FEFEFE"];
    //
   
    self.bankNumberNameLable.textColor =[UIColor colorWithHexString:@"#FEFEFE"];
    [self.bankLogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35 *JT_ADAOTER_WIDTH, 35 *JT_ADAOTER_WIDTH));
        make.left.equalTo(self.mas_left).offset(20 *JT_ADAOTER_WIDTH);
        make.top.equalTo(self.mas_top).offset(20 *JT_ADAOTER_WIDTH);
    }];
    [self.bankNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankLogoImg);
        make.left.equalTo(self.bankLogoImg.mas_right).offset(10 *JT_ADAOTER_WIDTH);
    }];
    [self.bankNumberNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankLogoImg);
          make.top.equalTo(self.bankLogoImg.mas_bottom).offset(20 *JT_ADAOTER_WIDTH);
    }];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10*JT_ADAOTER_WIDTH);
        make.left.equalTo(self.bankLogoImg);
    }];
}
-(void)getBankModle:(JTCertificationModel *)bankModel{
     self.backgroundColor = [UIColor colorWithHexString:bankModel.bankColor];
     self.bankNameLable.text  = bankModel.bankName;
    [self.bankLogoImg sd_setImageWithURL:[NSURL URLWithString:bankModel.bankLogo] placeholderImage:nil];
    self.timeLable.text =[NSString stringWithFormat:@"%@ 添加",bankModel.creationDate];
    self.bankNumberNameLable.text =[JFHSUtilsTool groupedString:bankModel.cardNo];
}

@end
