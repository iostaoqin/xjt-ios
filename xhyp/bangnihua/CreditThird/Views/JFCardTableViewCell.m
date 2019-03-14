//
//  JFCardTableViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFCardTableViewCell.h"

@implementation JFCardTableViewCell

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
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.shadowColor =[UIColor colorWithHexString:@"cccccc"].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(2, 5); self.bgView.layer.shadowOpacity = 0.5f; self.bgView.layer.shadowRadius = 5.0f;
    
    self.cardImg        =[UIImageView new];
    self.cardNameLable  =[UILabel new];
    self.rightTypeImg        =[UIImageView new];
    self.typeNameLable  =[UILabel new];
    self.applyCardLable =[UILabel new];
    self.lineLable      =[UILabel new];
    self.typeImg        =[UIImageView new];
    self.cardTypeLable  =[UILabel new];
     self.rightNameLable  =[UILabel new];
    [self.bgView addSubview:self.typeNameLable];
    [self.bgView addSubview:self.cardTypeLable];
    [self.bgView addSubview:self.cardImg];
    [self.bgView addSubview:self.cardNameLable];
    [self.bgView addSubview:self.lineLable];
    [self.bgView addSubview:self.typeImg];
    [self.bgView addSubview:self.applyCardLable];
    [self.bgView addSubview:self.rightTypeImg];
    [self.rightTypeImg addSubview:self.rightNameLable];
    //
   
    self.cardNameLable.font  = kFontSystem(16);
    self.cardNameLable.textColor  = [UIColor colorWithHexString:@"333333"];
    //
//    self.rightTypeImg.image =[UIImage imageNamed:@"New_circle"];
    self.rightTypeImg.transform = CGAffineTransformMakeRotation(-M_PI/180);
    self.cardTypeLable.textColor = [UIColor colorWithHexString:@"#999999"];
    self.cardTypeLable.font  = kFontSystem(14);
   
    
    //
    self.applyCardLable.font  = kFontSystem(14);
     self.applyCardLable.textColor = [UIColor colorWithHexString:@"#999999"];
    self.lineLable.backgroundColor =[UIColor colorWithHexString:@"#eeeeee"];
    
    //
    self.typeImg.image  =  [UIImage imageNamed:@"NewGifts_present"];
    
    self.typeNameLable.font  = kFontSystem(12);
    
    self.typeNameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    
   
    self.rightNameLable.font  = kFontSystem(10);
    self.rightNameLable.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.rightNameLable.textAlignment = NSTextAlignmentCenter;
    
    [self makeConstraints];
   
    
}
-(void)makeConstraints{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(8 *JT_ADAOTER_WIDTH);
        make.right.equalTo(self.contentView.mas_right).offset(-8 *JT_ADAOTER_WIDTH);
        make.height.equalTo(self.contentView);
    }];
    
    [self.cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(115 * JT_ADAOTER_WIDTH, 72 *JT_ADAOTER_WIDTH));
        make.left.equalTo(self.bgView.mas_left).offset(10 *JT_ADAOTER_WIDTH);
        make.top.equalTo(self.bgView.mas_top).offset(14* JT_ADAOTER_WIDTH);
    }];
    [self.cardNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardImg.mas_top);
        make.width.mas_equalTo(160 *JT_ADAOTER_WIDTH);
        make.left.equalTo(self.cardImg.mas_right).offset(13 *JT_ADAOTER_WIDTH);
    }];
    [self.rightTypeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36 * JT_ADAOTER_WIDTH, 16 *JT_ADAOTER_WIDTH));
        make.top.equalTo(self.cardImg.mas_top);
        make.right.equalTo(self.bgView.mas_right).offset(-10 *JT_ADAOTER_WIDTH);
    }];
    [self.cardTypeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardNameLable.mas_left);
        make.top.equalTo(self.cardNameLable.mas_bottom).offset(12* JT_ADAOTER_WIDTH);
        make.right.equalTo(self.rightTypeImg.mas_right);
    }];
    [self.applyCardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardNameLable.mas_left);
        make.top.equalTo(self.cardTypeLable.mas_bottom).offset(12* JT_ADAOTER_WIDTH);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.bgView.mas_left).offset(10 *JT_ADAOTER_WIDTH);
         make.right.equalTo(self.bgView.mas_right).offset(-10 *JT_ADAOTER_WIDTH);
        make.top.equalTo(self.cardImg.mas_bottom).offset(14 *JT_ADAOTER_WIDTH);
    }];
    [self.typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(12 *JT_ADAOTER_WIDTH , 12 *JT_ADAOTER_WIDTH));
        make.top.equalTo(self.lineLable.mas_bottom).offset(9 *JT_ADAOTER_WIDTH);
        make.left.equalTo(self.cardImg.mas_left);
    }];
    [self.typeNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.lineLable.mas_bottom).offset(8 *JT_ADAOTER_WIDTH);
        make.left.equalTo(self.typeImg.mas_right).offset(5 *JT_ADAOTER_WIDTH);
    }];
    [self.rightNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rightTypeImg);
    }];
}
-(void)getCradModelData:(JFThirdNewModel *)model{
    self.rightTypeImg.backgroundColor =[UIColor colorWithHexString:model.tagColor];
    self.cardNameLable.text = model.creditName;
     self.rightNameLable.text = model.tagName;
    self.cardTypeLable.text  = model.creditDesc;
    self.typeNameLable.text  = model.giftDesc;
      NSString *imgUrl = [model.cardImgUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//图片url里有文字
    [self.cardImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    NSString *str = [NSString stringWithFormat:@"%@人已成功申请",model.applyCnt];
    self.applyCardLable.attributedText =[JFHSUtilsTool attributedString:str selectedStr:model.applyCnt  selctedColor:@"#FF4D4F"haspreStr:@""];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
