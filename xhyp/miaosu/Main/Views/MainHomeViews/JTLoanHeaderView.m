//
//  JTLoanHeaderView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/28.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTLoanHeaderView.h"

@implementation JTLoanHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self innitView];
    }
    return self;
}
-(void)innitView{
    self.nameImg =[UIImageView new];
    self.nameLable =[UILabel new];
    self.detailTipsLable =[UILabel new];
    [self addSubview:self.detailTipsLable];
    [self addSubview:self.nameLable];
    [self addSubview:self.nameImg];
//
    [self.nameImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18 *JT_ADAOTER_WIDTH, 18*JT_ADAOTER_WIDTH));
        make.left.equalTo(self.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.top.equalTo(self.mas_top).offset(20 *JT_ADAOTER_WIDTH);
    }];

    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameImg.mas_right).offset(10);
        make.centerY.equalTo(self.nameImg);
    }];
    [self.detailTipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16 *JT_ADAOTER_WIDTH);
        make.top.equalTo(self.nameLable.mas_bottom).offset(10 *JT_ADAOTER_WIDTH);
//        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-16 *JT_ADAOTER_WIDTH);

    }];
    self.nameLable.textColor  =[UIColor colorWithHexString:@"#333333"];
    self.detailTipsLable.textColor  =[UIColor colorWithHexString:@"#666666"];
    self.detailTipsLable.numberOfLines  = 0;
    
    if (JT_IS_iPhone5) {
        self.nameLable.font  =kFontSystem(14);
        self.detailTipsLable.font  =kFontSystem(11);
    }else{
        self.nameLable.font  = kFontSystem(16);
        self.detailTipsLable.font  =kFontSystem(13);
    }
    
}
-(void)getHeaderImg:(NSString *)logoImg  headerName:(NSString *)name detailStr:(NSString *)detail showType:(NSString *)type{
    if ([type isEqualToString:@"1"]) {
        //已还款
//        [self.nameImg mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset((JT_ScreenW - 9 *JT_ADAOTER_WIDTH)/2.5);
//        }];
    }
    self.nameImg.image= [UIImage imageNamed:logoImg];
    self.nameLable.text  = name;
    if (![JFHSUtilsTool isBlankString:detail]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; // 行间距设置为30
        paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
        [paragraphStyle setLineSpacing:6];
        NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:detail];
        [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detail length])];
        
        self.detailTipsLable.attributedText  =setString;
    }
    
    
}
@end
