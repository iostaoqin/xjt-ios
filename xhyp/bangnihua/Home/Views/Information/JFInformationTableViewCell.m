//
//  JFInformationTableViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFInformationTableViewCell.h"

@implementation JFInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectedBtn.userInteractionEnabled =  YES;
    self.institutionsImg = [UIImageView new];
    self.institutionsNameLable = [UILabel new];
     self.institutionsDetailLable = [UILabel new];
    
    [self.contentView addSubview:self.selectedBtn];
    [self.contentView addSubview:self.institutionsImg];
    [self.contentView addSubview:self.institutionsNameLable];
    [self.contentView addSubview:self.institutionsDetailLable];
    
    
    [self.selectedBtn setImage:[UIImage imageNamed:@"img_new_nomal"] forState:UIControlStateNormal];
    [self.selectedBtn setImage:[UIImage imageNamed:@"img_new_selected"] forState:UIControlStateSelected];
    [self.selectedBtn setImage:[UIImage imageNamed:@"img_new_selected"] forState:UIControlStateHighlighted];
//    self.institutionsImg.backgroundColor  = [UIColor redColor];
    self.institutionsImg.layer.cornerRadius  = 4;
    self.institutionsImg.layer.masksToBounds = YES;
    //
    self.institutionsNameLable.font   = kFontSystem(14);
    self.institutionsNameLable.textColor =[UIColor  colorWithHexString:@"#333333"];

    //
    self.institutionsDetailLable.textColor  = [UIColor colorWithHexString:@"#999999"];
    self.institutionsDetailLable.font   = kFontSystem(12);

    
    [self makeConstraints];
    
    
}
-(void)makeConstraints{
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(20, 20));
         make.left.equalTo(self.contentView.mas_left).offset(59 * JT_ADAOTER_WIDTH);
        make.centerY.equalTo(self.contentView);
    }];
    [self.institutionsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.selectedBtn.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.institutionsNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.institutionsImg.mas_right).offset(12 * JT_ADAOTER_WIDTH);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.top.equalTo(self.institutionsImg.mas_top).offset(2);
    }];
    [self.institutionsDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.institutionsNameLable.mas_left);
         make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.top.equalTo(self.institutionsNameLable.mas_bottom).offset(7);
    }];
}
-(void)getboundsData:(JFEditHomeSmallModel *)model{
    
    [self.institutionsImg sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:nil];
        self.institutionsNameLable.text = model.orgName;
        self.institutionsDetailLable.text = model.desc;
    if (model.option) {
        self.selectedBtn.selected = YES;
    }else{
        self.selectedBtn.selected = NO;
    }
   
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
