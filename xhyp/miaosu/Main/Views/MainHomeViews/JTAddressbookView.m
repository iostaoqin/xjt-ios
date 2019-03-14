//
//  JTAddressbookView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTAddressbookView.h"

@implementation JTAddressbookView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self innitView];
    }
    return self;
}
-(void)innitView{
    self.nameLable = [UILabel new];
    self.closeImg = [UIButton new];
    self.detailNameLable = [UILabel new];
    self.lineLable = [UILabel new];
    self.addressbookBtn = [UIButton new];
    //
    [self addSubview:self.addressbookBtn];
    [self addSubview:self.lineLable];
    [self addSubview:self.detailNameLable];
    [self addSubview:self.nameLable];
    [self addSubview:self.closeImg];
    self.nameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    self.nameLable.text  = @"通讯录上传";
    [self.closeImg setImage:[UIImage imageNamed:@"closeAddress"] forState:UIControlStateNormal];
    self.detailNameLable.text  = @"运营商认证需要先上传您的通讯录，仅用于查询个人征信，我们承诺保护用户隐私。";
    self.detailNameLable.textColor = [UIColor colorWithHexString:@"#999999"];
    self.detailNameLable.numberOfLines= 0;
    self.lineLable.backgroundColor =[UIColor colorWithHexString:@"#D9D9D9"];
    //
    [self.addressbookBtn setTitle:@"上传通讯录" forState:UIControlStateNormal];
    [self.addressbookBtn setTitleColor:[UIColor colorWithHexString:@"#62A7E9"] forState:UIControlStateNormal];
    if (JT_IS_iPhone5) {
        self.nameLable.font  = kFontSystem(14);
        self.detailNameLable.font  = kFontSystem(12);
        self.addressbookBtn.titleLabel.font  = kFontSystem(14);
    }else{
        self.nameLable.font  = kFontSystem(16);
        self.detailNameLable.font  = kFontSystem(14);
        self.addressbookBtn.titleLabel.font  = kFontSystem(16);
    }
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(16  *JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self);
    }];
    [self.closeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20*JT_ADAOTER_WIDTH, 20*JT_ADAOTER_WIDTH));
        make.top.equalTo(self.mas_top).offset(6*JT_ADAOTER_WIDTH);
        make.right.equalTo(self.mas_right).offset(-6*JT_ADAOTER_WIDTH);
    }];
    [self.detailNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.nameLable.mas_bottom).offset(20 *JT_ADAOTER_WIDTH);
        make.left.equalTo(self.mas_left).offset(20 *JT_ADAOTER_WIDTH);
        make.right.equalTo(self.mas_right).offset(-20 *JT_ADAOTER_WIDTH);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.detailNameLable.mas_bottom).offset(18 *JT_ADAOTER_WIDTH);
    }];
    [self.addressbookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-12 *JT_ADAOTER_WIDTH);
    }];
    [self.addressbookBtn addTarget:self action:@selector(addressbookBtnClick) forControlEvents:UIControlEventTouchUpInside];
     [self.closeImg addTarget:self action:@selector(closeImgBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addressbookBtnClick{
    if ([self.delegate respondsToSelector:@selector(submitAddressbook)]) {
        [self.delegate submitAddressbook];
    }
}
-(void)closeImgBtnClick{
    if ([self.delegate respondsToSelector:@selector(closeAddressBookEvent)]) {
        [self.delegate closeAddressBookEvent];
    }
}
@end
