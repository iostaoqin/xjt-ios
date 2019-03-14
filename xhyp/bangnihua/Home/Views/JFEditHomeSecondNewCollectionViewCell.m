//
//  JFEditHomeSecondNewCollectionViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/10.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFEditHomeSecondNewCollectionViewCell.h"

@implementation JFEditHomeSecondNewCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    
  
    self.headerImg  = [UIImageView new];
    self.nameLable  =[UILabel new];
    
    [self.contentView addSubview:self.headerImg];
    [self.contentView addSubview:self.nameLable];
    //
    self.nameLable.textColor  = [UIColor colorWithHexString:@"333333"];
    self.nameLable.font  = kFontSystem(14);
    self.nameLable.textAlignment  = NSTextAlignmentCenter;
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40 * JT_ADAOTER_WIDTH, 40 * JT_ADAOTER_WIDTH));
        make.top.equalTo(self.contentView.mas_top).offset(5);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.headerImg.mas_bottom).offset(5);
    }];
    
}
-(void)getSecondData:(JFEditHomemodel *)secondModel{
    [self.headerImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50 * JT_ADAOTER_WIDTH, 50 * JT_ADAOTER_WIDTH));
        make.top.equalTo(self.contentView.mas_top).offset(18 * JT_ADAOTER_WIDTH);
        
    }];
    [self.nameLable  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImg.mas_bottom).offset(13 * JT_ADAOTER_WIDTH);
    }];
    self.nameLable.font  = kFontSystem(13);
    
    //
    self.nameLable.text  = secondModel.tagName;
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:secondModel.logoUrl] placeholderImage:nil];
    
}
-(void)getHeaderImg:(NSString *)headerImg nameStr:(NSString *)name{
    self.headerImg.image  = [UIImage imageNamed:headerImg];
    self.nameLable.text    = name;
}
@end
