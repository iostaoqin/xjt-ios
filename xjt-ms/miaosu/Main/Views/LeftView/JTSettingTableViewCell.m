//
//  JTSettingTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTSettingTableViewCell.h"

@implementation JTSettingTableViewCell

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
    self.nameLable  = [UILabel new];
    self.rightNameLable  =[UILabel new];
    
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.rightNameLable];
    //
    self.nameLable.textColor =[UIColor colorWithHexString:@"#333333"];
    self.rightNameLable.textColor =[UIColor colorWithHexString:@"#999999"];
    if (JT_IS_iPhone5) {
        self.nameLable.font  = kFontSystem(14);
        self.rightNameLable.font  = kFontSystem(14);
    }else{
        self.nameLable.font  = kFontSystem(16);
        self.rightNameLable.font  = kFontSystem(16);
    }
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    [self.rightNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
         make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
}
-(void)getLeftNameStr:(NSString *)nameStr rightNameStr:(NSString *)rightStr{
    self.nameLable.text  = nameStr;
    //如果 是0.00B 0.00
    self.rightNameLable.text  = rightStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
