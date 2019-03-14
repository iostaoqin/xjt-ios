//
//  JTLoginView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTLoginLeftView.h"

@implementation JTLoginLeftView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.leftBGView =[UIView new];
    [self addSubview:self.leftBGView];
    self.leftBGView.frame   = CGRectMake(0, 0, 310*JT_ADAOTER_WIDTH, 235*JT_ADAOTER_WIDTH);
    //添加背景图片
    UIImage *image = [UIImage imageNamed:@"leftBG"];
    self.leftBGView.layer.contents = (id) image.CGImage;
//
    self.portraintImg  = [UIImageView new];
    [self.leftBGView addSubview:self.portraintImg];
   
    self.portraintImg.image =[UIImage imageNamed:@"defaultPortraint"];
    self.portraintImg.layer.cornerRadius = 40*JT_ADAOTER_WIDTH;
    self.portraintImg.layer.borderWidth = 1;
    self.portraintImg.layer.borderColor= [UIColor clearColor].CGColor;
    self.portraintImg.layer.masksToBounds  = YES;
    //
    self.loginView  =[UIImageView new];
    [self.leftBGView addSubview:self.loginView];
    
    self.teleLable  =[UILabel new];
    [self.loginView addSubview:self.teleLable];
    
    self.nameLable  =[UILabel new];
    [self.loginView addSubview:self.nameLable];
    self.nameImg  =[UIImageView new];
    [self.loginView addSubview:self.nameImg];
    
    CGFloat font;
    if (JT_IS_iPhone5) {
        font   = 12;
        self.teleLable.font  = kFontSystem(10);
    }else{
        font =  14;
         self.teleLable.font  = kFontSystem(12);
    }
    self.nameLable.font = kFontSystem(font);
    self.nameLable.textColor =[UIColor colorWithHexString:@"#666666"];
    //
    self.teleLable.textColor=  [UIColor colorWithHexString:@"#666666"];
    self.nameImg.image =[UIImage imageNamed:@"loginArrow"];
    [self.portraintImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80*JT_ADAOTER_WIDTH, 80*JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self.leftBGView);
        make.top.equalTo(self.leftBGView.mas_top).offset(JT_NAV);
    }];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraintImg.mas_bottom);
        make.left.right.bottom.equalTo(self.leftBGView);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginView.mas_top).offset(12 *JT_ADAOTER_WIDTH);
       make.centerX.equalTo(self.loginView);
    }];
    [self.teleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom).offset(5);
        make.centerX.equalTo(self.loginView);
    }];
    [self.nameImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6*JT_ADAOTER_WIDTH, 10*JT_ADAOTER_WIDTH));
        make.centerY.equalTo(self.nameLable);
        make.left.equalTo(self.nameLable.mas_right).offset(5);
    }];
    //添加手势
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getstureImg)];
    [self.portraintImg addGestureRecognizer:gesture];
    self.portraintImg.userInteractionEnabled  = YES;
    //去登陆
    UITapGestureRecognizer *loginGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getstureLogin)];
    [self.loginView addGestureRecognizer:loginGesture];
    self.loginView.userInteractionEnabled  = YES;
    
    JFUserInfoTool *userInfo =[JFUserManager shareManager].currentUserInfo;
    if ([JFHSUtilsTool isBlankString:userInfo.keyStr]) {
        self.nameLable.text  = @"去登陆";
        self.nameImg.hidden  = NO;
    }else{
       
       
        if ([JFHSUtilsTool isBlankString:userInfo.userNameStr]) {
            self.nameLable.text  =[[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"];
            self.nameImg.hidden  = YES;
        }else{
            self.nameImg.hidden  = YES;
             self.teleLable.text  = [[NSUserDefaults standardUserDefaults]valueForKey:@"teleValue"];
            self.nameLable.text  = userInfo.userNameStr;
            
        }
    
    }
}
-(void)getstureImg{
    if ([self.portraintImgDelegate respondsToSelector:@selector(portraintImgClick)]) {
        [self.portraintImgDelegate portraintImgClick];
    }
}
-(void)getstureLogin{
    if ([self.portraintImgDelegate respondsToSelector:@selector(gotoLoginClick)]) {
        [self.portraintImgDelegate gotoLoginClick];
    }
}
@end
