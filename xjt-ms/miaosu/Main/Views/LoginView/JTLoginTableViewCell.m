//
//  JTLoginTableViewCell.m
//  xiaojintiao
//
//  Created by Daisy  on 2019/2/15.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTLoginTableViewCell.h"

@implementation JTLoginTableViewCell

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
    self.teleImg  =[UIImageView new];
    self.line   =[UILabel new];
    self.teleTextFiled  =[UITextField new];
    self.codeBtn  =[UIButton new];
    
    [self.contentView addSubview:self.teleTextFiled];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.teleImg];
    //
    self.line.backgroundColor   =[UIColor colorWithHexString:@"#EEEEEE"];
    //
    self.teleTextFiled.clearButtonMode   = UITextFieldViewModeWhileEditing;
    CGFloat  codeFont;
    if (JT_IS_iPhone5) {
        codeFont  = 13;
        self.teleTextFiled.font = kFontSystem(15);
    }else{
        codeFont = 15;
        self.teleTextFiled.font = kFontSystem(17);
    }
  
     [ self.teleTextFiled setValue:[UIColor colorWithHexString:@"#CCCCCC"] forKeyPath:@"_placeholderLabel.textColor"];
    self.codeBtn =[self.contentView buttonCreateGradientWithCornerRadius:3 btnWidth:100*JT_ADAOTER_WIDTH btnHeight:40*JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"01D3C7"];
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font  = kFontSystem(codeFont);
    [self.contentView addSubview:self.codeBtn];
    
    [self makeConstraints];
    [self.codeBtn addTarget:self action:@selector(codeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)makeConstraints{
    [self.teleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22*JT_ADAOTER_WIDTH, 22*JT_ADAOTER_WIDTH));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(30 * JT_ADAOTER_WIDTH);
    }];
    [self.teleTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.teleImg.mas_right).offset(10);
        make.width.mas_equalTo(250 * JT_ADAOTER_WIDTH);
        make.height.equalTo(self.contentView);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.teleImg.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-30 * JT_ADAOTER_WIDTH);
        make.bottom.equalTo(self.contentView);
    }];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90*JT_ADAOTER_WIDTH, 32*JT_ADAOTER_WIDTH));
        make.right.equalTo(self.line.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10 *JT_ADAOTER_WIDTH);
    }];
    self.codeBtn.hidden  = YES;
}
-(void)getLogiImg:(NSString *)img placeHolderText:(NSString *)str typeView:(NSString *)type{
    self.teleImg.image  =[UIImage imageNamed:img];
   
    self.teleTextFiled.placeholder  = str;
    if ([type isEqualToString:@"code"]) {
        [self.teleTextFiled mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(160 * JT_ADAOTER_WIDTH);
        }];
        self.teleTextFiled.keyboardType  = UIKeyboardTypeNumberPad;
    }
}
-(void)codeBtnClick:(UIButton *)btn{
    if ([self.codeDelegate respondsToSelector:@selector(getCodeEvent:)]) {
        [self.codeDelegate getCodeEvent:btn];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
