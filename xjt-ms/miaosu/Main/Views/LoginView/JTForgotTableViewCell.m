//
//  JTForgotTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTForgotTableViewCell.h"

@implementation JTForgotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.nameLable  =[UILabel new];
    self.line   =[UILabel new];
    self.teleTextFiled  =[UITextField new];
    self.codeBtn  =[UIButton new];
    
    [self.contentView addSubview:self.teleTextFiled];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.nameLable];
    //
    self.line.backgroundColor   =[UIColor colorWithHexString:@"#EEEEEE"];
    //
    self.teleTextFiled.clearButtonMode   = UITextFieldViewModeWhileEditing;
    [self.teleTextFiled setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    CGFloat  codeFont;
    if (JT_IS_iPhone5) {
        codeFont  = 13;
        self.teleTextFiled.font = kFontSystem(14);
        self.nameLable.font  = kFontSystem(14);
    }else{
        codeFont = 15;
        self.teleTextFiled.font = kFontSystem(16);
        self.nameLable.font  = kFontSystem(16);
    }
    self.nameLable.textColor  =[UIColor colorWithHexString:@"#333333"];
    self.codeBtn =[self.contentView buttonCreateGradientWithCornerRadius:6 btnWidth:100*JT_ADAOTER_WIDTH btnHeight:40*JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"01D3C7"];
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font  = kFontSystem(codeFont);
    [self.contentView addSubview:self.codeBtn];
    
    [self makeConstraints];
    [self.codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)makeConstraints{
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(30 * JT_ADAOTER_WIDTH);
        make.width.mas_equalTo(80* JT_ADAOTER_WIDTH);
    }];
    [self.teleTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_right).offset(10);
        make.width.mas_equalTo(250 * JT_ADAOTER_WIDTH);
        make.height.equalTo(self.contentView);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.nameLable.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView);
    }];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100*JT_ADAOTER_WIDTH, 40*JT_ADAOTER_WIDTH));
        make.right.equalTo(self.contentView.mas_right).offset(-16  *JT_ADAOTER_WIDTH);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10 *JT_ADAOTER_WIDTH);
    }];
    self.codeBtn.hidden  = YES;
}
-(void)getForgotNameStr:(NSString *)str placeHolderText:(NSString *)placeHolderStr typeView:(NSString *)type indexStr:(NSInteger)idx{
    self.nameLable.text  =str; 
     self.teleTextFiled.placeholder  = placeHolderStr;
    if ([type isEqualToString:@"code"]) {
        [self.teleTextFiled mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(160 * JT_ADAOTER_WIDTH);
        }];
        self.teleTextFiled.keyboardType  = UIKeyboardTypeNumberPad;
    }
}
-(void)codeBtnClick:(UIButton *)btn{
    if ([self.forgotCodeDelegate respondsToSelector:@selector(getCodeEvent:)]) {
        [self.forgotCodeDelegate getCodeEvent:btn];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
