//
//  JTHomeHeaderView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTHomeHeaderView.h"

@implementation JTHomeHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self innitView];
    }
    return self;
}
-(void)innitView{
    //添加背景图片
    UIImage *image = [UIImage imageNamed:@"headerHome"];
    self.layer.contents = (id) image.CGImage;
    self.leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.nameLable = [UILabel new];
    self.rightBtn =[UIButton  buttonWithType:UIButtonTypeCustom];
    self.priceLable = [UILabel new];
    self.alreadyPriceLable = [UILabel new];
    self.tipsLable = [UILabel new];
    self.remainingPriceLable = [UILabel new];
    self.pointImg =[UIImageView new];
    
    [self addSubview:self.leftBtn];
    [self addSubview:self.nameLable];
    [self addSubview:self.rightBtn];
     [self addSubview:self.priceLable];
    [self addSubview:self.alreadyPriceLable];
    [self addSubview:self.tipsLable];
    [self addSubview:self.remainingPriceLable];
    [self addSubview:self.pointImg];
    
    
    [self.leftBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
      [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30*JT_ADAOTER_WIDTH)];
    [self.rightBtn setImage:[UIImage imageNamed:@"news"] forState:UIControlStateNormal];
    [self.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30 *JT_ADAOTER_WIDTH, 0, 0)];
    self.nameLable.textColor  =[UIColor colorWithHexString:@"#FFFFFF"];
    self.priceLable.textColor  =[UIColor colorWithHexString:@"#FFFFFF"];
    //
    self.alreadyPriceLable.textColor  =[UIColor colorWithHexString:@"#FFFFFF"];
    self.remainingPriceLable.textColor  =[UIColor colorWithHexString:@"#FFFFFF"];
    self.tipsLable.textColor  =[UIColor colorWithHexString:@"#FFFFFF"];
    //
    self.pointImg.image =[UIImage imageNamed:@"point"];
    [self makeConstraints];
  
    [self.leftBtn addTarget:self action:@selector(leftBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
       [self.rightBtn addTarget:self action:@selector(rightBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    if (JT_IS_iPhone5) {
        self.nameLable.font  = kFontSystem(14);
        self.priceLable.font =  kFontSystem(14);
        self.alreadyPriceLable.font  = kFontSystem(10);
        self.remainingPriceLable.font =  kFontSystem(10);
          self.tipsLable.font =  kFontSystem(8);
    }else{
        self.nameLable.font  = kFontSystem(16);
        self.priceLable.font =  kFontSystem(16);
        self.alreadyPriceLable.font  = kFontSystem(12);
        self.remainingPriceLable.font =  kFontSystem(12);
         self.tipsLable.font =  kFontSystem(10);
    }
    self.nameLable.text = [JFHSUtilsTool decodeFromPercentEscapeString:credit_text];
    NSString *priceStr = @"300.00元";
    NSString *str = @"300.00";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36.0] range:NSMakeRange(0 , str.length)];
    self.priceLable.attributedText = att;
    self.tipsLable.text  = @"（温馨提示：积累良好信用，有利于提高额度）";
    self.alreadyPriceLable.text  = @"已用额度：0.00元";
    self.remainingPriceLable.text = @"剩余可用额度：5000元";
      self.pointImg.hidden  = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(messagesNotificationevent:) name:@"messagesNotification" object:nil];
}
#pragma mark -  小红点的显示状态
-(void)messagesNotificationevent:(NSNotification *)notice{
    NSString *noticevalue  = notice.object;
    if ([noticevalue isEqualToString:@"0"]) {
        //隐藏
        self.pointImg.hidden  = YES;
    }else{
         self.pointImg.hidden  = NO;
    }
}
-(void)makeConstraints{
    //左侧图标
//    self.leftBtn.backgroundColor =[UIColor  yellowColor];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(JT_STATUS_BAR_HEIGHT + 14 *JT_ADAOTER_WIDTH);
        make.size.mas_equalTo(CGSizeMake(60*JT_ADAOTER_WIDTH, 22 *JT_ADAOTER_WIDTH));
        make.left.equalTo(self.mas_left).offset(15*JT_ADAOTER_WIDTH);
    }];
    //右侧图标
//
//    self.rightBtn.backgroundColor  =[UIColor redColor];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(JT_STATUS_BAR_HEIGHT + 14 *JT_ADAOTER_WIDTH);
        make.size.mas_equalTo(CGSizeMake(60*JT_ADAOTER_WIDTH, 22 *JT_ADAOTER_WIDTH));
        make.right.equalTo(self.mas_right).offset(-15*JT_ADAOTER_WIDTH);
    }];
    //
    [self.pointImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.left.equalTo(self.rightBtn.mas_right).offset(-5*JT_ADAOTER_WIDTH);
        make.top.equalTo(self.rightBtn.mas_top).offset(-5 *JT_ADAOTER_WIDTH);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(JT_NAV );
    }];
    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self);
        make.top.equalTo(self.nameLable.mas_bottom).offset( 10 *JT_ADAOTER_WIDTH);
    }];
//    [self.alreadyPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(16  * JT_ADAOTER_WIDTH);
//        make.top.equalTo(self.priceLable.mas_bottom).offset( 30 *JT_ADAOTER_WIDTH);
//    }];
//    [self.remainingPriceLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-16  * JT_ADAOTER_WIDTH);
//        make.top.equalTo(self.alreadyPriceLable);
//    }];
    [self.tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-25*JT_ADAOTER_WIDTH);
    }];
}
-(void)leftBtnClickEvent{
    if ([self.delegate respondsToSelector:@selector(leftBarButtonItemEvent)]) {
        [self.delegate leftBarButtonItemEvent];
    }
}
-(void)rightBtnClickEvent{
    if ([self.delegate respondsToSelector:@selector(rightBarButtonItemEvent)]) {
        [self.delegate rightBarButtonItemEvent];
    }
}
-(void)getLineofCredit:(JTLoanModel *)creditModel{
    //分转成元并保留两位小数
     NSString *str =  [NSString stringWithFormat:@"%.2f",[JFHSUtilsTool roundFloat:[creditModel.maxAmount floatValue]/100]];
    NSString *priceStr = [NSString stringWithFormat:@"%@元",str];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36.0] range:NSMakeRange(0 , str.length)];
    self.priceLable.attributedText = att;
}

@end
