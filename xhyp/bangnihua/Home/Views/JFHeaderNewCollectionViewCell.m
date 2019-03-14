//
//  JFHeaderNewCollectionViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFHeaderNewCollectionViewCell.h"

@implementation JFHeaderNewCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    
    self.bgView = [UIView new];
    [self.contentView addSubview:self.bgView];
    self.bgView.backgroundColor  =[UIColor whiteColor];
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.shadowColor =[UIColor colorWithHexString:@"cccccc"].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(1, 2);
    self.bgView.layer.shadowOpacity = 0.8f;
    self.bgView.layer.shadowRadius = 5.0f;
    self.headerImg  = [UIImageView new];
    self.nameLable  =[UILabel new];
    
    [self.bgView addSubview:self.headerImg];
    [self.bgView addSubview:self.nameLable];
    //
    self.nameLable.textColor  = [UIColor colorWithHexString:@"333333"];
    if (JT_IS_iPhone5 || JT_IS_iPhone4) {
        
        self.nameLable.font  = kFontSystem(12);
    }else{
       self.nameLable.font  = kFontSystem(14);
    }
    
    self.nameLable.textAlignment  = NSTextAlignmentCenter;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(40 * JT_ADAOTER_WIDTH, 40 * JT_ADAOTER_WIDTH));
        make.top.equalTo(self.bgView.mas_top).offset(5);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.bgView);
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
    if (JT_IS_iPhone5 || JT_IS_iPhone4) {
        
        self.nameLable.font  = kFontSystem(11);
    }else{
         self.nameLable.font  = kFontSystem(13);
    }
    
    //
    self.nameLable.text  = secondModel.tagName;
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:secondModel.logoUrl] placeholderImage:nil];
    
}
-(void)getHeaderImg:(NSString *)headerImg nameStr:(NSString *)name{
    self.headerImg.image  = [UIImage imageNamed:headerImg];
    self.nameLable.text    = name;
}
@end
