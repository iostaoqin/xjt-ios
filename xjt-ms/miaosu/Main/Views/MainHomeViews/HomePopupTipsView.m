//
//  HomePopupTipsView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "HomePopupTipsView.h"

@implementation HomePopupTipsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.popupBgImg  =[UIImageView new];
    self.closeImg  =[UIButton new];
    self.contenLable  =[UILabel new];
    [self.popupBgImg addSubview:self.contenLable];
    [self addSubview:self.closeImg];
    [self addSubview:self.popupBgImg];
    self.popupBgImg.image  = [UIImage imageNamed:@"popupBG"];
    [self.closeImg setImage:[UIImage imageNamed:@"popupClose"] forState:UIControlStateNormal];
    self.contenLable.textColor =[UIColor colorWithHexString:@"#333333"];
    self.contenLable.numberOfLines  = 0;
    self.contenLable.text = @"【注意】请认准APP中的官方客服，其他方式（百度，微信公众号）搜索到的客服都是骗子\n申请即授权【小金条】管理您的贷后信息包括但不限于：\n1.将逾期7天信息上传至征信平台。\n2.通知紧急联系人，告知本人还款事宜。";
    if (JT_IS_iPhone5) {
        self.contenLable.font = kFontSystem(14);
    }else{
         self.contenLable.font = kFontSystem(16);
    }
    [self.popupBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(295 *JT_ADAOTER_WIDTH, 300 *JT_ADAOTER_WIDTH));
        make.top.equalTo(self);
         make.centerX.equalTo(self);
    }];
    [self.contenLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.popupBgImg.mas_top).offset(121  *JT_ADAOTER_WIDTH);
        make.left.equalTo(self.popupBgImg.mas_left).offset(20 *JT_ADAOTER_WIDTH);
         make.right.equalTo(self.popupBgImg.mas_right).offset(-20 *JT_ADAOTER_WIDTH);
    }];
    [self.closeImg mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(CGSizeMake(24 *JT_ADAOTER_WIDTH, 24 *JT_ADAOTER_WIDTH));
        make.top.equalTo(self.popupBgImg.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
    [self.closeImg addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)closeBtnClick{
    if ([self.popupDelegate respondsToSelector:@selector(closePopupEvent)]) {
        [self.popupDelegate closePopupEvent];
    }
}
@end
