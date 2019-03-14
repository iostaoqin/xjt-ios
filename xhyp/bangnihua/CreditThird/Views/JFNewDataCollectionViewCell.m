//
//  JFNewDataCollectionViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFNewDataCollectionViewCell.h"

@implementation JFNewDataCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
//    self.layer.borderColor=[UIColor redColor].CGColor;
//    self.layer.borderWidth=0.5;
    self.nameImg = [UIImageView new];
    self.nameLable = [UILabel new];
    self.detailLable = [UILabel new];
    
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.nameImg];
    [self.contentView addSubview:self.detailLable];
    
//    self.nameLable.textColor = [UIColor colorWithHexString:@"999999"];
    self.nameLable.textColor=[UIColor blackColor];
    self.nameLable.font  = kFontSystem(16);
    self.detailLable.font  = kFontSystem(12);
    
    [self makeConstraints];
   
    
    
    
    
}
-(void)makeConstraints{
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.top.equalTo(self.contentView.mas_top).offset(23);
    }];
    [self.detailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_left);
        make.top.equalTo(self.nameLable.mas_bottom).offset(10);
    }];
    [self.nameImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85 * JT_ADAOTER_WIDTH, 85 * JT_ADAOTER_WIDTH));
        make.right.equalTo(self.contentView.mas_right).offset(-6);
        make.centerY.equalTo(self.contentView);
    }];
}
-(void)getCardModelData:(JFThirdNewModel *)carModel{
    self.nameLable.text = carModel.name;
    [self.nameImg sd_setImageWithURL:[NSURL URLWithString:carModel.iconUrl] placeholderImage:nil];
    self.detailLable.textColor =[UIColor colorWithHexString:carModel.descColor];
    self.detailLable.text  = carModel.desc;;
}
@end
