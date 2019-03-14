//
//  JTCertificationTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTCertificationTableViewCell.h"

@implementation JTCertificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.nameImg = [UIImageView new];
    self.nameLable=  [UILabel new];
    self.lineLable=  [UILabel new];
    self.nameTextLable=  [UILabel new];
    self.arrowImg=  [UIImageView new];
    self.rightNameLable=  [UILabel new];
    [self.contentView addSubview:self.rightNameLable];
    [self.contentView addSubview:self.arrowImg];
    [self.contentView addSubview:self.nameTextLable];
    [self.contentView addSubview:self.lineLable];
    [self.contentView addSubview:self.nameLable];
    [self.contentView  addSubview:self.nameImg];
    self.lineLable.backgroundColor=[UIColor colorWithHexString:@"f5f5f5"];
    
    self.nameLable.textColor =[UIColor colorWithHexString:@"#999999"];
    
    self.nameTextLable.textColor  =[UIColor colorWithHexString:@"#FF4D4F"];
    
    self.nameTextLable.hidden  = YES;
    if (JT_IS_iPhone5) {
        self.nameLable.font  =  kFontSystem(14);
        self.nameTextLable.font  =  kFontSystem(14);
        self.rightNameLable.font  =  kFontSystem(12);
    }else{
        self.nameLable.font  =  kFontSystem(16);
        self.nameTextLable.font  =  kFontSystem(16);
        self.rightNameLable.font  =  kFontSystem(14);
    }
    //
    self.arrowImg.image =[UIImage imageNamed:@"certification_arrow"];
    //
    
    
    [self.nameImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(24 *JT_ADAOTER_WIDTH, 24 *JT_ADAOTER_WIDTH));
        make.left.equalTo(self.contentView.mas_left).offset(16*JT_ADAOTER_WIDTH);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameImg.mas_right).offset(10*JT_ADAOTER_WIDTH);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.nameImg.mas_left);
    }];
    [self.nameTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20*JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.contentView);
    }];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12 *JT_ADAOTER_WIDTH, 12 *JT_ADAOTER_WIDTH));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-14  *JT_ADAOTER_WIDTH);
    }];
    [self.rightNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImg.mas_left).offset(-20*JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.contentView);
    }];
}
-(void)getLeftImg:(NSString *)imgStr leftNameStr:(NSString *)nameStr certicationModel:(JTCertificationModel *)model idx:(NSInteger )idx{
    self.nameImg.image  = [UIImage imageNamed:imgStr];
    self.nameLable.text = nameStr;
    //3 过期  4 认证中
    NSString *realNameStr = [model.realnameVerified isEqualToString:@"1"]?@"已认证":[model.realnameVerified isEqualToString:@"0"]?@"未认证":[model.realnameVerified isEqualToString:@"2"]?@"认证失败":[model.realnameVerified isEqualToString:@"3"]?@"已过期":@"认证中";
    NSString *realNameColor   =[model.realnameVerified isEqualToString:@"1"]?@"#62A7E9":[model.realnameVerified isEqualToString:@"0"]?@"#999999":[model.realnameVerified isEqualToString:@"2"]?@"#FF4D4F":[model.realnameVerified isEqualToString:@"3"]?@"#FF4D4F":@"#333333";
    //运营商认证
    NSString *mobileStr = [model.mobileVerified isEqualToString:@"1"]?@"已认证":[model.mobileVerified isEqualToString:@"0"]?@"未认证":[model.mobileVerified isEqualToString:@"2"]?@"认证失败":[model.mobileVerified isEqualToString:@"3"]?@"已过期":@"认证中";
    NSString *mobileColor   =[model.mobileVerified isEqualToString:@"1"]?@"#62A7E9":[model.mobileVerified isEqualToString:@"0"]?@"#999999":[model.mobileVerified isEqualToString:@"2"]?@"#FF4D4F":[model.realnameVerified isEqualToString:@"3"]?@"#FF4D4F":@"#333333";
    //基本信息
    NSString *basicInfoStr = [model.basicInfoVerified isEqualToString:@"1"]?@"已认证":[model.basicInfoVerified isEqualToString:@"0"]?@"未认证":[model.basicInfoVerified isEqualToString:@"2"]?@"认证失败":@"已过期";
    NSString *basicInfoColor   =[model.basicInfoVerified isEqualToString:@"1"]?@"#62A7E9":[model.basicInfoVerified isEqualToString:@"0"]?@"#999999":[model.basicInfoVerified isEqualToString:@"2"]?@"#FF4D4F":@"#FF4D4F";
    //银行卡认证
    NSString *bankStr = [model.bankCardVerified isEqualToString:@"1"]?@"已认证":[model.bankCardVerified isEqualToString:@"0"]?@"未认证":[model.bankCardVerified isEqualToString:@"2"]?@"认证失败":@"已过期";
    NSString *bankColor   =[model.bankCardVerified isEqualToString:@"1"]?@"#62A7E9":[model.bankCardVerified isEqualToString:@"0"]?@"#999999":[model.bankCardVerified isEqualToString:@"2"]?@"#FF4D4F":@"#FF4D4F";
    NSArray *nameArr =@[realNameStr,mobileStr,basicInfoStr,bankStr];
    NSArray *colorArr =@[realNameColor,mobileColor,basicInfoColor,bankColor];
    self.rightNameLable.text  =nameArr[idx];
    self.rightNameLable.textColor=  [UIColor colorWithHexString:colorArr[idx]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
