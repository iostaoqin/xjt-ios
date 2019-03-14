//
//  JTHomeThirdView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTHomeThirdView.h"

@implementation JTHomeThirdView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self innitView];
    }
    return self;
}
-(void)innitView{
    self.nameLable = [UILabel new];
    self.arrowImg = [UIImageView new];
    self.priceLable = [UILabel new];
    
    self.leftNameLable = [UILabel new];
    self.remainingNameLable = [UILabel new];
    self.detailNameLable = [UILabel new];
    self.leftBtn = [UIButton new];
    self.continuBtn = [UIButton new];
    //


    [self addSubview:self.remainingNameLable];
    [self addSubview:self.leftNameLable];
    [self addSubview:self.arrowImg];
    [self addSubview:self.nameLable];
    [self addSubview:self.priceLable];
    [self addSubview:self.detailNameLable];
    [self addSubview:self.leftBtn];
    [self addSubview:self.continuBtn];
    
    self.nameLable.text  = @"近日待还";
    self.arrowImg.image= [UIImage imageNamed:@"homeArrow"];
    self.nameLable.textColor  = [UIColor colorWithHexString:@"#333333"];
    
    self.priceLable.textColor  =[UIColor colorWithHexString:@"#62A7E9"];
    
    
    self.leftNameLable.textColor  =[UIColor colorWithHexString:@"#999999"];
   
    self.remainingNameLable.textColor  =[UIColor colorWithHexString:@"#999999"];
    self.detailNameLable.textColor =[UIColor colorWithHexString:@"#333333"];
 
     CGFloat firstFont;
    if (JT_IS_iPhone5) {
        self.nameLable.font=  kFontSystem(16);
        self.priceLable.font=  kFontSystem(34);
        self.leftNameLable.font=  kFontSystem(10);
        self.remainingNameLable.font=  kFontSystem(10);
        self.detailNameLable.font=  kFontSystem(12);
          firstFont = 12;
    }else{
        self.nameLable.font=  kFontSystem(18);
         self.priceLable.font=  kFontSystem(36);
        self.leftNameLable.font=  kFontSystem(12);
         self.remainingNameLable.font=  kFontSystem(12);
         self.detailNameLable.font=  kFontSystem(14);
          firstFont = 14;
    }
    self.leftBtn  = [self buttonCreateWithNorStr:[JFHSUtilsTool decodeFromPercentEscapeString:constrepayment_text] nomalBgColor:@"#62A7E9" textFont:firstFont cornerRadius:3];
    [self addSubview:self.leftBtn];
    //
    self.continuBtn  = [self buttonCreateWithNorStr:[JFHSUtilsTool decodeFromPercentEscapeString:renewed_text] nomalBgColor:@"#62A7E9" textFont:firstFont cornerRadius:3];
    [self addSubview:self.continuBtn];
    [self makeConstraints];
    self.detailNameLable.hidden =  YES;
    self.leftBtn.hidden =  YES;
    self.continuBtn.hidden =  YES;
}
-(void)makeConstraints{
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(18*JT_ADAOTER_WIDTH);
        make.left.equalTo(self.mas_left).offset(153 * JT_ADAOTER_WIDTH);
    }];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_right);
        make.centerY.equalTo(self.nameLable);
        make.size.mas_equalTo(CGSizeMake(20*JT_ADAOTER_WIDTH, 20 *JT_ADAOTER_WIDTH));
    }];
    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.nameLable.mas_bottom).offset(20 *JT_ADAOTER_WIDTH);
    }];
    
    [self.detailNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.priceLable.mas_bottom).offset(20 *JT_ADAOTER_WIDTH);
    }];
    [self.leftNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.bottom.equalTo(self.mas_bottom).offset(-10 *JT_ADAOTER_WIDTH);
    }];
    [self.remainingNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16 *JT_ADAOTER_WIDTH);
        make.top.equalTo(self.leftNameLable.mas_top);
    }];
//    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//          make.size.mas_equalTo(CGSizeMake(80*JT_ADAOTER_WIDTH, 30  *JT_ADAOTER_WIDTH));
//         make.top.equalTo(self.detailNameLable.mas_bottom).offset(14  * JT_ADAOTER_WIDTH);
//         make.left.equalTo(self.mas_left).offset((JT_ScreenW  -200*JT_ADAOTER_WIDTH)/2);
//    }];
//    [self.continuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//          make.size.mas_equalTo(CGSizeMake(80*JT_ADAOTER_WIDTH, 30  *JT_ADAOTER_WIDTH));
//        make.top.equalTo(self.leftBtn.mas_top);
//        make.left.equalTo(self.leftBtn.mas_right).offset(30 *JT_ADAOTER_WIDTH);
//    }];
    self.priceLable.text  = @"0.00";
    self.remainingNameLable.text  = @"待还笔数:0笔";
    self.leftNameLable.text  = @"还款日期:暂无还款";
}
-(void)getRefresh:(NSString *)showType{

}
-(void)getLoanModel:(JTLoanModel *)model{
    
    if ([JFHSUtilsTool isBlankString:model.repaymentNeedDate]) {
       self.leftNameLable.text  = @"还款日期:暂无还款";
    }else{
        self.leftNameLable.text  =[NSString stringWithFormat:@"还款日期:%@",model.repaymentNeedDate];
    }
    if ([JFHSUtilsTool isBlankString:model.repaymentNeedAmount]) {
        self.priceLable.text  = @"0.00";
         self.remainingNameLable.text  = @"待还笔数:0笔";
    }else{
        
        NSString *str =  [NSString stringWithFormat:@"%.2f",[JFHSUtilsTool roundFloat:[model.repaymentNeedAmount floatValue]/100]];
       
        self.priceLable.text   = str;
         self.remainingNameLable.text  = @"待还笔数:1笔";
    }  
}
@end
