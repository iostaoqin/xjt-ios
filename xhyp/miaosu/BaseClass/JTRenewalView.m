//
//  JTRenewalView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTRenewalView.h"

@implementation JTRenewalView
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"codesuccessfulNotice" object:nil];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self innitView];
    }
    return self;
}
-(void)innitView{
    
    self.firstView =[UIView new];
    self.firstNameLable = [UILabel new];
    self.firstLeftNameLable = [UILabel new];
    self.secondLeftNameLable = [UILabel new];
    self.firstRightNameLable = [UILabel new];
    self.secondRightNameLable = [UILabel new];
    self.firstLineLable = [UILabel new];
    self.firstSureBtn  =[UIButton new];
    self.bottomLineLable  =[UILabel new];
    self.leftCancelBtn  =[UIButton new];
    
    [self addSubview:self.firstView];
    [self.firstView addSubview:self.firstNameLable];
    [self.firstView addSubview:self.firstLeftNameLable];
    [self.firstView addSubview:self.secondLeftNameLable];
    [self.firstView addSubview:self.firstRightNameLable];
    [self.firstView addSubview:self.secondRightNameLable];
    [self.firstView addSubview:self.firstLineLable];
    [self.firstView addSubview:self.firstSureBtn];
    [self.firstView addSubview:self.bottomLineLable];
    [self.firstView addSubview:self.leftCancelBtn];
    
    self.secondView =[UIView new];
    self.secondNameLable  =[UILabel new];
    self.secondCodeTextFied  =[UITextField new];
    
    self.secondSureBtn  =[UIButton new];
    self.secondLineLable  =[UILabel new];
    self.leftSCancelBtn  =[UIButton new];
    self.bottomSLineLable  =[UILabel new];
    [self addSubview:self.secondView];
    
    [self.secondView addSubview:self.secondNameLable];
    [self.secondView addSubview:self.secondCodeTextFied];
    [self.secondView addSubview:self.secondSureBtn];
    [self.secondView addSubview:self.secondLineLable];
    [self.secondView addSubview:self.leftSCancelBtn];
    [self.secondView addSubview:self.bottomSLineLable];
    
    self.firstView.backgroundColor  =[UIColor whiteColor];
    self.secondView.backgroundColor =[UIColor whiteColor];
    self.firstView.layer.cornerRadius = 5;
    self.firstView.layer.borderWidth = 0;
    self.firstView.layer.masksToBounds = YES;
    
    self.secondView.layer.cornerRadius = 5;
    self.secondView.layer.borderWidth = 0;
    self.secondView.layer.masksToBounds = YES;
    CGFloat  codeFont;
    if (JT_IS_iPhone5) {
        self.firstNameLable.font  = kFontSystem(14);
        self.firstLeftNameLable.font  = kFontSystem(12);
        self.secondLeftNameLable.font  = kFontSystem(12);
        self.firstRightNameLable.font  = kFontSystem(12);
        self.secondRightNameLable.font  = kFontSystem(12);
        self.firstSureBtn.titleLabel.font  = kFontSystem(14);
        self.leftCancelBtn.titleLabel.font  = kFontSystem(14);
        self.secondNameLable.font  = kFontSystem(12);
        codeFont  = 14;
        self.secondSureBtn.titleLabel.font  = kFontSystem(14);
        self.leftSCancelBtn.titleLabel.font  = kFontSystem(14);
    }else{
        self.firstNameLable.font  = kFontSystem(16);
        self.firstLeftNameLable.font  = kFontSystem(14);
        self.secondLeftNameLable.font  = kFontSystem(14);
        self.firstRightNameLable.font  = kFontSystem(14);
        self.secondRightNameLable.font  = kFontSystem(14);
        self.firstSureBtn.titleLabel.font  = kFontSystem(16);
        self.leftCancelBtn.titleLabel.font  = kFontSystem(16);
        self.secondNameLable.font  = kFontSystem(14);
        codeFont  = 16;
        self.secondSureBtn.titleLabel.font  = kFontSystem(16);
        self.leftSCancelBtn.titleLabel.font  = kFontSystem(16);
    }
    //第一个弹框的内容
    self.firstNameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    
    
    [self.firstSureBtn setTitleColor:[UIColor colorWithHexString:@"#62A7E9"] forState:UIControlStateNormal];
    [self.leftCancelBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [self.leftCancelBtn setTitle:@"稍后" forState:UIControlStateNormal];
    self.firstLeftNameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    self.secondLeftNameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    self.secondRightNameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    self.firstRightNameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    self.firstLineLable.backgroundColor =[UIColor colorWithHexString:@"#D9D9D9"];
    self.bottomLineLable.backgroundColor =[UIColor colorWithHexString:@"#D9D9D9"];
    //
   

    //取手机号后4位
    self.secondNameLable.textColor = [UIColor colorWithHexString:@"#333333"];
    
    self.secondCodeTextFied.layer.borderColor= [UIColor colorWithHexString:@"#D9D9D9"].CGColor;
    self.secondCodeTextFied.layer.borderWidth=  1;
    self.secondCodeTextFied.layer.cornerRadius  = 2;
    self.secondCodeTextFied.layer.masksToBounds = YES;
    self.secondLineLable.backgroundColor =[UIColor colorWithHexString:@"#D9D9D9"];
    self.secondCodeBtn =[self buttonCreateGradientWithCornerRadius:3 btnWidth:90*JT_ADAOTER_WIDTH btnHeight:24*JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"01D3C7"];
    [self.secondCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.secondCodeBtn.titleLabel.font  = kFontSystem(codeFont);
    [self.secondView addSubview:self.secondCodeBtn];
    [self.secondSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.leftSCancelBtn setTitle:@"稍后" forState:UIControlStateNormal];
    [self.secondSureBtn setTitleColor:[UIColor colorWithHexString:@"#62A7E9"] forState:UIControlStateNormal];
       [self.leftSCancelBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.bottomSLineLable.backgroundColor =[UIColor colorWithHexString:@"#D9D9D9"];
    [self makeConstraints];
    
    self.secondView.hidden = YES;
}
-(void)makeConstraints{
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
        make.center.equalTo(self);
        make.height.mas_equalTo(180 * JT_ADAOTER_WIDTH);
        make.width.mas_equalTo(250 *JT_ADAOTER_WIDTH);
    }];
    
    [self.firstNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstView.mas_top).offset(12  *JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self.firstView);
    }];
    
    [self.firstLeftNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstNameLable.mas_bottom).offset(16*JT_ADAOTER_WIDTH);
        make.left.equalTo(self.firstView.mas_left).offset(24 *JT_ADAOTER_WIDTH);
    }];
    
    [self.secondLeftNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstLeftNameLable);
        make.top.equalTo(self.firstLeftNameLable.mas_bottom).offset(16 *JT_ADAOTER_WIDTH);
    }];
    [self.firstLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.secondLeftNameLable.mas_bottom).offset(24 *JT_ADAOTER_WIDTH);
    }];
    [self.firstRightNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.firstView.mas_right).offset(-16 *JT_ADAOTER_WIDTH);
        make.top.equalTo(self.firstLeftNameLable);
    }];
    [self.secondRightNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.firstRightNameLable.mas_right);
        make.top.equalTo(self.secondLeftNameLable);
    }];
    [self.bottomLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.equalTo(self.firstLineLable.mas_bottom);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
    [self.firstSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomLineLable.mas_right);
        make.top.equalTo(self.firstLineLable.mas_bottom);
        make.right.equalTo(self.firstView.mas_right);
        make.height.mas_equalTo(58*JT_ADAOTER_WIDTH);
    }];
    [self.leftCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomLineLable.mas_left);
        make.left.equalTo(self.firstView.mas_left);
        make.top.height.equalTo(self.firstSureBtn);
        
    }];
    
    
    
    
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
        make.center.equalTo(self);
        make.height.mas_equalTo(180 * JT_ADAOTER_WIDTH);
         make.width.mas_equalTo(300 *JT_ADAOTER_WIDTH);
    }];
    
    [self.secondNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondView.mas_top).offset(36  *JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self.secondView);
    }];
    [self.secondCodeTextFied mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(155*JT_ADAOTER_WIDTH, 25*JT_ADAOTER_WIDTH));
        make.left.equalTo(self.secondNameLable);
        make.top.equalTo(self.secondNameLable.mas_bottom).offset(18);
    }];
    [self.secondLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.secondCodeTextFied.mas_bottom).offset(28 *JT_ADAOTER_WIDTH);
    }];
    [self.secondCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90*JT_ADAOTER_WIDTH, 24*JT_ADAOTER_WIDTH));
        make.top.equalTo(self.secondCodeTextFied);
        make.left.equalTo(self.secondCodeTextFied.mas_right).offset(5);
    }];
    [self.bottomSLineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.equalTo(self.secondLineLable.mas_bottom);
        make.bottom.equalTo(self.secondView);
        make.centerX.equalTo(self.secondView);

    }];
    
    
    [self.secondSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomSLineLable.mas_right);
        make.top.equalTo(self.secondLineLable.mas_bottom);
        make.right.equalTo(self.secondView.mas_right);
        make.height.mas_equalTo(58*JT_ADAOTER_WIDTH);
    }];
    [self.leftSCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomSLineLable.mas_left);
        make.left.equalTo(self.secondView.mas_left);
        make.top.height.equalTo(self.secondSureBtn);

    }];
    //点击事件
    //确认续期或者还款
    [self.firstSureBtn addTarget:self action:@selector(firstSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //稍后
    [self.leftCancelBtn addTarget:self action:@selector(leftCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.secondSureBtn addTarget:self action:@selector(secondSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.leftSCancelBtn addTarget:self action:@selector(leftSCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.secondCodeBtn addTarget:self action:@selector(secondCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(codenotice) name:@"codesuccessfulNotice" object:nil];
}
-(void)codenotice{
    if (self.countdownTimer) {
        dispatch_source_cancel(self.countdownTimer);
//        dispatch_cancel(self.countdownTimer);
    }
    __block int timeout = 10; //（秒）倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.countdownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.countdownTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.countdownTimer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(self.countdownTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置 特别注明：UI的改变一定要在主线程中进行
                if (self.secondCodeBtn!=nil) {
                    [self.secondCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    self.secondCodeBtn.userInteractionEnabled = YES;
                }
            });
        }else{
            
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.secondCodeBtn !=nil) {
                    [self.secondCodeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                    self.secondCodeBtn.userInteractionEnabled = NO;
                }
            });
            timeout--;
            
        }
    });
    dispatch_resume(self.countdownTimer);
    
}
#pragma mark  - 关闭弹窗 事件
-(void)firstSureBtnClick{
    if ([self.delegate respondsToSelector:@selector(fistBtnEventClick:)]) {
        [self.delegate fistBtnEventClick:self.secondCodeBtn];
    }
    
}
-(void)leftCancelBtnClick{
    if ([self.delegate respondsToSelector:@selector(cancelBtnEventClick)]) {
        [self.delegate cancelBtnEventClick];
    }
    
}
-(void)secondSureBtnClick{
    if ([self.delegate respondsToSelector:@selector(secondBtnEventClick:)]) {
        [self.delegate secondBtnEventClick:self.secondCodeTextFied.text];
    }
}
-(void)leftSCancelBtnClick{
    if ([self.delegate respondsToSelector:@selector(cancelCodeSecondBtnEventClick)]) {
        [self.delegate cancelCodeSecondBtnEventClick];
    }
}

#pragma mark - 获取验证码
-(void)secondCodeBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(codeEvent:)]) {
        [self.delegate codeEvent:btn];
    }
}
-(void)getFirstContent:(NSArray *)nameArr showType:(NSString  *)type televalue:(NSString *)valexteleNumberStr{
    //1还款  2其他(获取验证码)  3 续期
    
    if ([type isEqualToString:@"1"] ||[type isEqualToString:@"3"] ) {
        self.secondView.hidden  = YES;
        self.firstView.hidden = NO;
    }else{
        self.secondView.hidden  = NO;
        self.firstView.hidden = YES;
    }
    if (nameArr.count) {
        self.firstNameLable.text  = nameArr[0];
        self.firstLeftNameLable.text  = nameArr[1];
        self.secondLeftNameLable.text  = nameArr[2];
        self.firstRightNameLable.text  = nameArr[3];
        self.secondRightNameLable.text  = nameArr[4];
        [self.firstSureBtn setTitle:nameArr[5] forState:UIControlStateNormal];
       
    }
     self.secondNameLable.text = [NSString stringWithFormat:@"验证码已发送到尾号为%@的手机号！",[valexteleNumberStr substringFromIndex:valexteleNumberStr.length -4]];
    if ([type isEqualToString:@"1"]) {
        self.secondCodeBtn.tag  = 1000;
    }else if ([type isEqualToString:@"3"]){
       self.secondCodeBtn.tag  = 1003;
    }
    
}

@end
