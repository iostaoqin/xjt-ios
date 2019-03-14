//
//  JFMainHeaderNewCollectionViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFMainHeaderNewCollectionViewCell.h"

@implementation JFMainHeaderNewCollectionViewCell
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
    self.nameLable.textColor  = [UIColor colorWithHexString:@"666666"];
    if (JT_IS_iPhone5 || JT_IS_iPhone4) {
        
        self.nameLable.font  = kFontSystem(12);
    }else{
       self.nameLable.font  = kFontSystem(14);
    }
    
    self.nameLable.textAlignment  = NSTextAlignmentCenter;
 
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60 * JT_ADAOTER_WIDTH, 60 * JT_ADAOTER_WIDTH));
        make.top.equalTo(self.contentView.mas_top).offset(14* JT_ADAOTER_WIDTH);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.headerImg.mas_bottom).offset(5);
    }];
    
}
-(void)getHeaderImg:(NSString *)headerImg nameStr:(NSString *)name{
    self.headerImg.image  = [UIImage imageNamed:headerImg];
    self.nameLable.text    = name;
}
@end
