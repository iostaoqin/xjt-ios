//
//  JFDataFooterView.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/15.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFDataFooterView.h"

@implementation JFDataFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self  = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.backgroundColor  = [UIColor clearColor];
    self.nameLable  = [UILabel new];
    [self addSubview:self.nameLable];
    self.nameLable.text = load_text_tips;
    self.nameLable.textColor = [UIColor colorWithHexString:@"#999999"];
    self.nameLable.font = kFontSystem(14);
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
}
@end
