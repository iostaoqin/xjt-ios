//
//  JFDetailUsersMineTableViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/29.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFDetailUsersMineTableViewCell.h"

@implementation JFDetailUsersMineTableViewCell

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
    [self.contentView addSubview:self.nameTextLable];
    [self.contentView addSubview:self.lineLable];
    [self.contentView addSubview:self.nameLable];
    [self.contentView  addSubview:self.nameImg];
    self.lineLable.backgroundColor=[UIColor colorWithHexString:@"f5f5f5"];
    self.nameLable.font  =  kFontSystem(16);
    self.nameLable.textColor =[UIColor colorWithHexString:@"#333333"];
    
    self.nameTextLable.textColor  =[UIColor colorWithHexString:@"#FF4D4F"];
    self.nameTextLable.font  =  kFontSystem(16);
    self.nameTextLable.hidden  = YES;
    
    [self.nameImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self.contentView.mas_left).offset(16);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameImg.mas_right).offset(13);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.nameImg.mas_left);
    }];
    [self.nameTextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
}
-(void)getImgStrArr:(NSArray *)imgStrArr{
    self.nameImg.image = [UIImage imageNamed:imgStrArr[0]];
    self.nameLable.text  =  imgStrArr[1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
