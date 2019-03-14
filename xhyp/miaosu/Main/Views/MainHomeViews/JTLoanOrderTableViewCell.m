//
//  JTLoanOrderTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTLoanOrderTableViewCell.h"

@implementation JTLoanOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
    
}
-(void)initView{
    self.bgView = [UIView new];
    [self.contentView addSubview:self.bgView];
    
    self.bgView.backgroundColor  =[UIColor whiteColor];
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.shadowColor =[UIColor colorWithHexString:@"cccccc"].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(2, 5); self.bgView.layer.shadowOpacity = 0.5f;
    self.bgView.layer.shadowRadius = 5.0f;
    
    self.priceLable  =[UILabel new];
    self.typeLable  =[UILabel new];
    self.firstLineLable  =[UILabel new];
    self.secondLineLable  =[UILabel new];
    self.applyTimeLable  =[UILabel new];
    self.detailApplyTimeLable  =[UILabel new];
    self.detailApplyTimeLable  =[UILabel new];
    [self.bgView addSubview:self.detailApplyTimeLable];
    self.reimbursementLable  =[UILabel new];
    self.reimbursementTimeLable  =[UILabel new];
    
    
    [self.bgView addSubview:self.reimbursementTimeLable];
    [self.bgView addSubview:self.reimbursementLable];
    [self.bgView addSubview:self.detailApplyTimeLable];
    [self.bgView addSubview:self.applyTimeLable];
    [self.bgView addSubview:self.secondLineLable];
    [self.bgView addSubview:self.firstLineLable];
    [self.bgView addSubview:self.typeLable];
    [self.bgView addSubview:self.priceLable];
    self.priceLable.text  = @"借款金额:  1600元";
    self.typeLable.text = @"已逾期";
    self.priceLable.textColor  =[UIColor colorWithHexString:@"#333333"];
     self.typeLable.textColor  =[UIColor colorWithHexString:@"#FF4D4F"];
    self.firstLineLable.backgroundColor  =[UIColor colorWithHexString:@"#EEEEEE"];
     self.secondLineLable.backgroundColor  =[UIColor colorWithHexString:@"#EEEEEE"];
    self.applyTimeLable.text  = @"申请日期";
    self.detailApplyTimeLable.text  = @"2019-04-23  12:33:11";
    self.reimbursementLable.text  = @"还款日期";
    self.reimbursementTimeLable.text  = @"2019-04-23  12:33:11";
    
    self.applyTimeLable.textColor  =[UIColor colorWithHexString:@"#999999"];
    self.detailApplyTimeLable.textColor  =[UIColor colorWithHexString:@"#999999"];
    self.reimbursementTimeLable.textColor  =[UIColor colorWithHexString:@"#999999"];
    self.reimbursementLable.textColor  =[UIColor colorWithHexString:@"#999999"];
    if (JT_IS_iPhone5) {
        self.priceLable.font = kFontSystem(12);
        self.typeLable.font = kFontSystem(10);
        self.applyTimeLable.font = kFontSystem(1);
        self.detailApplyTimeLable.font = kFontSystem(10);
        self.reimbursementTimeLable.font = kFontSystem(10);
        self.reimbursementLable.font = kFontSystem(10);
    }else{
        self.priceLable.font = kFontSystem(14);
        self.typeLable.font = kFontSystem(12);
        self.applyTimeLable.font = kFontSystem(12);
        self.detailApplyTimeLable.font = kFontSystem(12);
        self.reimbursementTimeLable.font = kFontSystem(12);
        self.reimbursementLable.font = kFontSystem(12);
    }
    
     [self makeConstraints];
}
-(void)makeConstraints{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.right.equalTo(self.contentView.mas_right).offset(-16 *JT_ADAOTER_WIDTH);
        make.height.equalTo(self.contentView);
    }];
    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(12*JT_ADAOTER_WIDTH);
        make.left.equalTo(self.bgView.mas_left).offset(7*JT_ADAOTER_WIDTH);
    }];
    [self.typeLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.bgView.mas_right).offset(-20*JT_ADAOTER_WIDTH);
        make.top.equalTo(self.priceLable);
    }];
    [self.firstLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.priceLable.mas_bottom).offset(12 *JT_ADAOTER_WIDTH);
    }];
    [self.secondLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1*JT_ADAOTER_WIDTH, 40*JT_ADAOTER_WIDTH));
        make.top.equalTo(self.firstLineLable.mas_bottom).offset(10*JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self.bgView);
    }];
    [self.applyTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLineLable.mas_bottom).offset(12 *JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self.bgView).offset(-(JT_ScreenW-33*JT_ADAOTER_WIDTH)/4);
    }];
    [self.detailApplyTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applyTimeLable.mas_bottom).offset(5 *JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self.applyTimeLable);
    }];
    [self.reimbursementLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.applyTimeLable.mas_top);
        make.centerX.equalTo(self.bgView).offset((JT_ScreenW-33*JT_ADAOTER_WIDTH)/4);
    }];
    [self.reimbursementTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailApplyTimeLable.mas_top);
        make.centerX.equalTo(self.reimbursementLable);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
