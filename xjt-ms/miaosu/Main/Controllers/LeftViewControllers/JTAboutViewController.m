//
//  JTAboutViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTAboutViewController.h"

@interface JTAboutViewController ()
@property (nonatomic, strong) UIImageView *codeImg;
@end
@implementation JTAboutViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)leftBarButtonItemEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"关于我们";
    self.view.backgroundColor =  [UIColor colorWithHexString:@"#F5F5F5"];
    [self aboutUI];
}
-(void)aboutUI{
    
    //二维码
    _codeImg = [UIImageView new];
    [self.view addSubview:_codeImg];
    _codeImg.image = [UIImage imageNamed:@"loginLogo"];
    [_codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75*JT_ADAOTER_WIDTH, 75*JT_ADAOTER_WIDTH));
        make.top.equalTo(self.view.mas_top).offset(132*JT_ADAOTER_WIDTH);
        make.centerX.equalTo(self.view);
    }];
    UILabel *otherNameLable =[UILabel new];
    [self.view addSubview:otherNameLable];
    
    UILabel *nameLable =[UILabel new];
    [self.view addSubview:nameLable];
    
    
    [otherNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeImg.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
        make.centerX.equalTo(self.view);
    }];
    if (JT_IS_iPhone5) {
      
        otherNameLable.font = kFontSystem(16);
         nameLable.font = kFontSystem(16);
    }else{
       
        otherNameLable.font = kFontSystem(18);
        nameLable.font = kFontSystem(18);
    }
    otherNameLable.text  = @"小金条: V1.00";
    otherNameLable.textColor  =[UIColor colorWithHexString:@"#333333"];
    nameLable.text  = @"用户协议";
    nameLable.textColor  =[UIColor colorWithHexString:@"#62A7E9"];
    UITapGestureRecognizer  *nameTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameTapClick)];
    [nameLable addGestureRecognizer:nameTap];
    nameLable.userInteractionEnabled = YES;
}
#pragma mark -  用户协议
-(void)nameTapClick{
    JTWebViewController *web =[[JTWebViewController alloc]init];
    web.hidesBottomBarWhenPushed = YES;
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    web.url  =appDelegate.messageArr[1];
  
    [self.navigationController pushViewController:web animated:YES];
}
-(void)imglongTapClick:(UILongPressGestureRecognizer *)gesture

{
    //长按的时候 判断用户是否授权相册
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }else{
        if(gesture.state==UIGestureRecognizerStateBegan){
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
            UIImageView*img = (UIImageView*)[gesture view];
            _codeImg= img;
            UIImageWriteToSavedPhotosAlbum(_codeImg.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }
    }

   
}
-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    if (!error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"保存成功"];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        });
    }
}
@end
