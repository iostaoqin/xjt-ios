//
//  JTEmptyView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTEmptyView.h"

@implementation JTEmptyView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self innitView];
    }
    return self;
}
-(void)innitView{
    
    _emptyImg =[UIImageView new];
    [self addSubview:_emptyImg];
   
    [_emptyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90*JT_ADAOTER_WIDTH, 90*JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    _emptyLable = [UILabel new];
    [self addSubview:_emptyLable];
    
    _emptyLable.textColor =[UIColor colorWithHexString:@"#999999"];
    if (JT_IS_iPhone5) {
        _emptyLable.font  = kFontSystem(14);
    }else{
        _emptyLable.font  = kFontSystem(16);
    }
    [_emptyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.emptyImg.mas_bottom).offset(10);
    }];
    
}
-(void)getEmptyImg:(NSString *)img emptyTitle:(NSString *)title{
    _emptyImg.image  = [UIImage imageNamed:img];
    _emptyLable.text = title;
}
@end
