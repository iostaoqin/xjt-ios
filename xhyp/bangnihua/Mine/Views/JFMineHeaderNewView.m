//
//  JFMineHeaderNewView.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFMineHeaderNewView.h"

@implementation JFMineHeaderNewView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    [self  setGradientBackgroundColor:@"#FF4D4F" secondColor:@"#FF5050"];
    self.titleLable  = [UILabel new];
    self.settingBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.titleLable];
    [self addSubview:self.settingBtn];
    self.titleLable.text = @"我的";
    self.titleLable.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.titleLable.font  = kFontSystem(18);
    [self.settingBtn setImage:[UIImage imageNamed:@"img_setting"] forState:UIControlStateNormal];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(JT_STATUS_BAR_HEIGHT + 17 );
    }];
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.right.equalTo(self.mas_right).offset(-17);
        make.top.equalTo(self.titleLable.mas_top);
    }];
}

@end
