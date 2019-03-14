//
//  JFNewCardEditView.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFNewCardEditView.h"

@implementation JFNewCardEditView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
//    self.backgroundColor =[UIColor yellowColor];
    self.nameLable =[UILabel new];
    self.detailLable =[UILabel new];
    self.rightImg =  [UIImageView new];
    self.addressLable =[UILabel new];
//    self.locationImg =[UIImageView new];
//    self.changeCityBtn =[UIButton new];
    self.lineLable =[UILabel new];
  
    
    [self addSubview:self.nameLable];
     [self addSubview:self.detailLable];
     [self addSubview:self.rightImg];
    [self addSubview:self.addressLable];
//    [self addSubview:self.locationImg];
    [self addSubview:self.lineLable];
//     [self addSubview:self.changeCityBtn];
    NSString *bigLoan  = @"%E5%A4%A7%E9%A2%9D%E8%B4%B7%E6%AC%BE%E7%94%B3%E8%AF%B7";
    NSString  *tipsStr = @"%E9%80%92%E4%BA%A4%E5%A4%A7%E9%A2%9D%E8%B4%B7%E6%AC%BE%E7%94%B3%E8%AF%B7";
  
    self.nameLable.textColor =[UIColor colorWithHexString:@"333333"];
    self.nameLable.attributedText  = [JFHSUtilsTool attributedString:[JFHSUtilsTool decodeFromPercentEscapeString:tipsStr] selectedStr:[JFHSUtilsTool decodeFromPercentEscapeString:bigLoan] selctedColor:@"#FF4D4F"haspreStr:@"递交"];
    self.nameLable.font  = kFontSystem(16);
    
    self.detailLable.textColor = [UIColor colorWithHexString:@"666666"];
    self.detailLable.font = kFontSystem(14);
    self.detailLable.text  = @"预约专属机构服务";
    
    self.locationImg.image = [UIImage imageNamed:@"addressNewlocation"];
    
    self.rightImg.image  =[UIImage imageNamed:@"newbg_empty"];
    self.addressLable.textColor  = [UIColor colorWithHexString:@"#999999"];
  
    self.addressLable.font  = kFontSystem(12);
    self.lineLable.backgroundColor =[UIColor colorWithHexString:@"#EEEEEE"];
    
    [self.changeCityBtn setTitle:@"更换城市" forState:UIControlStateNormal];
    [self.changeCityBtn setTitleColor:[UIColor colorWithHexString:@"#47A3FF"] forState:UIControlStateNormal];
    self.changeCityBtn.titleLabel.font  = kFontSystem(12);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"更换城市"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_changeCityBtn setAttributedTitle:str forState:UIControlStateNormal];
    [_changeCityBtn addTarget:self action:@selector(changeAddressEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self makeConstraints];
}
-(void)makeConstraints{
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(26* JT_ADAOTER_WIDTH);
        make.top.equalTo(self.mas_top).offset(21* JT_ADAOTER_WIDTH);
    }];
    [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_left);
        make.top.equalTo(self.nameLable.mas_bottom).offset(12* JT_ADAOTER_WIDTH);
    }];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(170 * JT_ADAOTER_WIDTH, 80* JT_ADAOTER_WIDTH));
        make.top.equalTo(self.mas_top).offset(15);
    }];
//    [self.locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.left.equalTo(self.nameLable.mas_left);
//          make.size.mas_equalTo(CGSizeMake(12, 12));
//        make.top.equalTo(self.detailLable.mas_bottom).offset(16* JT_ADAOTER_WIDTH);
//    }];
//    [self.addressLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.locationImg.mas_right).offset(5);
//        make.top.equalTo(self.locationImg.mas_top);
//    }];
//    [self.changeCityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.locationImg.mas_top);
//        make.left.equalTo(self.addressLable.mas_right).offset(10);
//        make.centerY.equalTo(self.addressLable);
//    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.bottom.equalTo(self);
    }];
}
-(void)changeAddressEvent{
    if ([self.addressDelegate respondsToSelector:@selector(changeAddress)]) {
        [self.addressDelegate changeAddress];
    }
}
@end
