//
//  JTSecondInformationTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTSecondInformationTableViewCell.h"

@implementation JTSecondInformationTableViewCell

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
    self.verticalImg  =[UILabel new];
    self.nameLable  =[UILabel new];
    self.lineLable  = [UILabel new];
    self.addressTextField  = [UITextField new];
    self.selectedBtn =[UIButton new];
    
    self.teleLable =[UILabel new];
    //
    [self.contentView addSubview:self.teleLable];
    
    [self.contentView addSubview:self.addressTextField];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.verticalImg];
    [self.contentView addSubview:self.lineLable];
    [self.contentView addSubview:self.selectedBtn];
    self.verticalImg.backgroundColor  =[UIColor colorWithHexString:@"#62A7E9"];
    if (JT_IS_iPhone5) {
        self.nameLable.font  = kFontSystem(14);
        self.addressTextField.font  = kFontSystem(14);
        self.selectedBtn.titleLabel.font  = kFontSystem(12);
        self.teleLable.font  = kFontSystem(12);
        
    }else{
        self.nameLable.font  = kFontSystem(16);
        self.addressTextField.font  = kFontSystem(16);
        self.selectedBtn.titleLabel.font  = kFontSystem(14);
        self.teleLable.font  = kFontSystem(14);
        
    }
    self.lineLable.backgroundColor  =[UIColor colorWithHexString:@"#EEEEEE"];
    self.verticalImg.hidden =  YES;
    self.addressTextField.placeholder  = @"请选择与你的关系";
    self.addressTextField.enabled  = NO;
    self.addressTextField.textAlignment = NSTextAlignmentRight;
    self.addressTextField.textColor =[UIColor colorWithHexString:@"#999999"];
    [self.addressTextField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    self.addressTextField.hidden  = YES;
    //btn
    [self.selectedBtn setTitle:@"选择联系人" forState:UIControlStateNormal];
    self.selectedBtn.layer.cornerRadius = 15;
    self.selectedBtn.layer.borderColor = [UIColor colorWithHexString:@"#62A7E9"].CGColor;
    self.selectedBtn.layer.borderWidth= 1;
    self.selectedBtn.layer.masksToBounds  = YES;
    self.selectedBtn.backgroundColor   =[UIColor whiteColor];
    [self.selectedBtn setTitleColor:[UIColor colorWithHexString:@"#62A7E9"] forState:UIControlStateNormal];
    self.selectedBtn.hidden  = YES;
    //
    self.teleLable.textColor =[UIColor colorWithHexString:@"#999999"];
    self.teleLable.hidden  = YES;
    
    [self makeConstraintsUI];
    [self.selectedBtn addTarget:self action:@selector(selectedBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)makeConstraintsUI{
    [self.verticalImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15*JT_ADAOTER_WIDTH);
        make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalImg.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.bottom.right.equalTo(self.contentView);
    }];
    [self.addressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-16 *JT_ADAOTER_WIDTH);
    }];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-16 *JT_ADAOTER_WIDTH);
    }];
    [self.teleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameLable.mas_right).offset(10*JT_ADAOTER_WIDTH);
    }];
}
-(void)getLeftNameStr:(NSString *)nameStr nameIdx:(NSInteger)idx{
    if (idx   ==0) {
        self.verticalImg.hidden   = NO;
        self.nameLable.textColor  =[UIColor colorWithHexString:@"#FF4D4F"];
    }else{
      
//        [self.nameLable mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
//        }];
    }
    if (idx ==1) {
        self.addressTextField.hidden  =  NO;
    }
    if (idx == 2) {
        self.selectedBtn.hidden  =  NO;
    }
    if (idx  ==2 ||idx ==3) {
        self.teleLable.hidden = NO;
    }
    self.nameLable.text  = nameStr;
}
#pragma mark - 选择联系人
-(void)selectedBtnEvent:(UIButton *)btn{
    if ([self.informationDelegate respondsToSelector:@selector(selectedConnectEventClick:)]) {
        [self.informationDelegate selectedConnectEventClick:btn];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
