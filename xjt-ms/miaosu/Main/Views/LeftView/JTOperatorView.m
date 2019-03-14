//
//  JTOperatorView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTOperatorView.h"

@implementation JTOperatorView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initOperationView];
    }
    return self;
}
-(void)initOperationView{
    CGFloat font;
    if (JT_IS_iPhone5) {
        font = 16;
    }else{
        font = 18;
    }
    self.leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.nameLable = [UILabel new];
    self.operationImg = [UIImageView new];
    //
    [self addSubview:self.operationImg];
    [self addSubview:self.leftBtn];
    [self addSubview:self.nameLable];
    
    [self.leftBtn setImage:[UIImage imageNamed:@"Path"] forState:UIControlStateNormal];
    
    //运营商认证
    [self addSubview:self.nameLable];
    self.nameLable.text= @"运营商认证";
    self.nameLable.textColor= [UIColor whiteColor];
    self.nameLable.font =  kFontSystem(font);
    [self.leftBtn addTarget:self action:@selector(comeBackEvent) forControlEvents:UIControlEventTouchUpInside];
    //
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(JT_STATUS_BAR_HEIGHT + 10 *JT_ADAOTER_WIDTH);
        make.size.mas_equalTo(CGSizeMake(22*JT_ADAOTER_WIDTH, 22 *JT_ADAOTER_WIDTH));
        make.left.equalTo(self.mas_left).offset(15*JT_ADAOTER_WIDTH);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.leftBtn);
    }];
    [self.operationImg mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(60*JT_ADAOTER_WIDTH, 60 *JT_ADAOTER_WIDTH));
        make.bottom.equalTo(self.mas_bottom).offset(-20 *JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self);
    }];
}
-(void)getOperationLogoImg:(NSString *)img{
    self.operationImg.image = [UIImage imageNamed:img];
}
-(void)comeBackEvent{
    
    if ([self.delegate respondsToSelector:@selector(OperatorViewleftBarButtonItemEvent)]) {
        [self.delegate OperatorViewleftBarButtonItemEvent];
    }
}
@end
