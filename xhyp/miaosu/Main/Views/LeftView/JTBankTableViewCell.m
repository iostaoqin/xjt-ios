//
//  JTBankTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBankTableViewCell.h"

@implementation JTBankTableViewCell

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
    CGFloat  codeFont;
    CGFloat supportFont;
    if (JT_IS_iPhone5) {
        codeFont  = 14;
        self.nameLable.font = kFontSystem(14);
        supportFont = 10;
        self.rightNameTextFiled.font  = kFontSystem(14);
    }else{
        codeFont = 16;
        supportFont  = 12;
        self.nameLable.font = kFontSystem(16);
        self.rightNameTextFiled.font  = kFontSystem(16);
    }
    //发送验证码
    self.codeBtn =[self.contentView buttonCreateGradientWithCornerRadius:3 btnWidth:90*JT_ADAOTER_WIDTH btnHeight:24*JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"01D3C7"];
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font  = kFontSystem(codeFont);
    [self.contentView addSubview:self.codeBtn];
    
    //
    self.nameLable= [UILabel new];
    [self.contentView addSubview:self.nameLable];
    self.nameLable.textColor  =[UIColor colorWithHexString:@"#333333"];
    //支持银行卡
//    self.supportBtn =[self.contentView buttonCreateGradientWithCornerRadius:3 btnWidth:60*JT_ADAOTER_WIDTH btnHeight:20*JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"01D3C7"];
//    [self.supportBtn setTitle:@"支持银行" forState:UIControlStateNormal];
//    self.supportBtn.titleLabel.font  = kFontSystem(supportFont);
//    [self.contentView addSubview:self.supportBtn];
    //textfiled
    self.rightNameTextFiled = [UITextField new];
    [self.contentView addSubview:self.rightNameTextFiled];
    self.rightNameTextFiled.textAlignment  = NSTextAlignmentRight;
    self.rightNameTextFiled.keyboardType  = UIKeyboardTypeNumberPad;
     [self.rightNameTextFiled setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    //
    self.lineLable =[UILabel new];
    [self.contentView addSubview:self.lineLable];
    self.lineLable.backgroundColor  =[UIColor colorWithHexString:@"#EEEEEE"];
    [self makeConstraints];
    self.codeBtn.hidden  = YES;
    self.supportBtn.hidden  = YES;
}
-(void)makeConstraints{
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90*JT_ADAOTER_WIDTH, 24*JT_ADAOTER_WIDTH));
        make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.contentView);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
         make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
    }];
//    [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(60*JT_ADAOTER_WIDTH, 20*JT_ADAOTER_WIDTH));
//        make.left.equalTo(self.nameLable.mas_right).offset(10 *JT_ADAOTER_WIDTH);
//        make.centerY.equalTo(self.contentView);
//    }];
    [self.rightNameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.equalTo(self.contentView.mas_right).offset(-16 *JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.contentView.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
        make.right.equalTo(self.contentView.mas_right);
    }];
}
-(void)getLeftName:(NSString *)nameStr  placeHolderStr:(NSString *)holderStr showIndex:(NSInteger)indx{
    if (indx == 3) {
        self.codeBtn.hidden = NO;
        self.nameLable.hidden = YES;
        self.lineLable.hidden = YES;
    }
    if (indx  ==0) {
        JFUserInfoTool *userInfo  =[JFUserManager shareManager].currentUserInfo;
        self.rightNameTextFiled.text =userInfo.userNameStr;
        self.rightNameTextFiled.enabled = NO;
    }
  
    self.nameLable.text = nameStr;
    self.rightNameTextFiled.placeholder  = holderStr;
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
