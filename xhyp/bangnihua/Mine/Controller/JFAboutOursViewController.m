//
//  JFAboutOursViewController.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFAboutOursViewController.h"
#import "JFNewAboutMeModel.h"
@interface JFAboutOursViewController ()
@property (nonatomic, strong)NSMutableArray *aboutArr;

@end
@implementation JFAboutOursViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addLeftButtonItemWithImage:@"mine_comeBack_img" slected:@"mine_comeBack_img"];
    self.aboutArr = [NSMutableArray array];
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [self getAboutData];
}
-(void)getAboutData{
    NSString *aboutUrl= [NSString stringWithFormat:@"%@/manager/mgt/app/about",HS_USER_URL];
    NSDictionary *dic = @{@"appName":app_name_type,@"os":@"ios"};
    //拼接
   NSString *url= [JFHSUtilsTool conectUrl:[dic  mutableCopy] url:aboutUrl];
    [PPNetworkHelper GET:url parameters:nil success:^(id responseObject) {
        JTLog(@"%@",responseObject);
        if ([[NSString stringWithFormat:@"%@",responseObject[@"resultCode"]]isEqualToString:@"0"]) {
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            JFNewAboutMeModel *aboutModel  =[JFNewAboutMeModel mj_objectWithKeyValues:responseObject[@"appInfoVo"]];
            [self.aboutArr addObject:aboutModel];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self creatUI];
            });
        }
    } failure:^(NSError *error) {
        //请求超时
        if (error.code ==-1001) {
            //请求 超时
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"请求超时"];
                [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
            });
        }
    }];
    
}

-(void)leftBarButtonItemEvent:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatUI{
    UILabel *textLable = [UILabel new];
    [self.view addSubview:textLable];
    textLable.font = kFontSystem(14);
    [textLable setNumberOfLines:0];
    textLable.textColor  = [UIColor colorWithHexString:@"#666666"];
    
    [textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30* JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(60 * JT_ADAOTER_WIDTH  + JT_NAV);
    }];
    UILabel *wxLable =  [UILabel new];
    [self.view addSubview:wxLable];
    wxLable.font  = kFontSystem(16);
    wxLable.textColor = [UIColor colorWithHexString:@"#333333"];
   
    [wxLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLable.mas_bottom).offset(72 * JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self.view);
    }];
    UIImageView *img =  [UIImageView new];
    [self.view addSubview:img];
    img.image= [UIImage imageNamed:@"mine_new_about_img"];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(280 *JT_ADAOTER_WIDTH, 200*JT_ADAOTER_WIDTH));
        make.top.equalTo(wxLable.mas_bottom).offset(60 * JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self.view);
    }];
    if (self.aboutArr.count) {
        JFNewAboutMeModel *aboutModel  =self.aboutArr[0];
    //赋值
  
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:aboutModel.appDesc];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10.0; // 设置行间距
    paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    textLable.attributedText = attributedStr;
        
    NSString *wxStr = [NSString stringWithFormat:@"商务合作: %@",aboutModel.wechat];
    wxLable.attributedText = [JFHSUtilsTool attributedString:wxStr selectedStr:aboutModel.wechat selctedColor:@"#FF4D4F"haspreStr:@"商务合作: "];
    }
    //长按(点击)复制微信号
    UITapGestureRecognizer * longPressGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    wxLable.userInteractionEnabled = YES;
    [wxLable addGestureRecognizer:longPressGr];
    
}
-(void)handleTap:(UITapGestureRecognizer  *)longRecognizer{
     JFNewAboutMeModel *aboutModel  =self.aboutArr[0];
    //把获取到的字符串放置到剪贴板上
    [UIPasteboard generalPasteboard].string = aboutModel.wechat;
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"复制成功"];
    [[JFHudMsgTool  shareHusMsg]hiddenHud:MBProgressHUDModeText];
}
- (BOOL)checkTelNumber:(NSString *) telNumber{
    NSString *pattern = @"^1+\\d{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}
@end
