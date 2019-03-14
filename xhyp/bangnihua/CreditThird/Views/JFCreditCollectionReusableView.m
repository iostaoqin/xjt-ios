//
//  JFCreditCollectionReusableView.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/14.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFCreditCollectionReusableView.h"

@implementation JFCreditCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.nameLable =[UILabel new];
    [self addSubview:self.nameLable];
    self.nameLable.text  =[JFHSUtilsTool decodeFromPercentEscapeString:all_card_text];
    self.nameLable.textColor =[UIColor colorWithHexString:@"#333333"];
    self.nameLable.font   = kFontSystem(14);
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(17);
    }];
   
    
    
}
@end
