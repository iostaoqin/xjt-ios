//
//  JTContactViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/2/27.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTContactViewController.h"
@interface JTContactViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIImageView *codeImg;
@end

@implementation JTContactViewController
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
    // Do any additional setup after loading the view.
    self.title  = @"联系我们";
    self.view.backgroundColor =  [UIColor colorWithHexString:@"#F5F5F5"];
    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
    [self aboutUI];
}
-(void)aboutUI{
    UILabel *nameLable  =[UILabel new];
    [self.view addSubview:nameLable];
    nameLable.textColor  = [UIColor colorWithHexString:@"#333333"];
    nameLable.text = @"小金条客服二维码";
    UILabel *otherNameLable  =[UILabel new];
    [self.view addSubview:otherNameLable];
    otherNameLable.textColor  = [UIColor colorWithHexString:@"#333333"];
    otherNameLable.text = @"长按保存图片";
    
    
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(70 * JT_ADAOTER_WIDTH);
    }];
    //二维码
    _codeImg = [UIImageView new];
    [self.view addSubview:_codeImg];
    AppDelegate * appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [_codeImg sd_setImageWithURL:[NSURL URLWithString:appDelegate.messageArr[2]] placeholderImage:nil];
    [_codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150*JT_ADAOTER_WIDTH, 150*JT_ADAOTER_WIDTH));
        make.top.equalTo(nameLable.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
    }];
    [otherNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeImg.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
    }];
    if (JT_IS_iPhone5) {
        nameLable.font = kFontSystem(12);
        otherNameLable.font = kFontSystem(16);
    }else{
        nameLable.font = kFontSystem(14);
        otherNameLable.font = kFontSystem(18);
    }
    UILongPressGestureRecognizer  *longTap =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
    [_codeImg addGestureRecognizer:longTap];
    _codeImg.userInteractionEnabled = YES;
    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
}
-(void)imglongTapClick:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state==UIGestureRecognizerStateBegan){
        //    //长按的时候 判断用户是否授权相册
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeIndeterminate msgStr:@""];
                    UIImageView*img = (UIImageView*)[gesture view];
                    self.codeImg= img;
                    UIImageWriteToSavedPhotosAlbum(self.codeImg.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
                });
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                    [alert show];
                });
            }
        }];
    }
}
-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeIndeterminate];
    if (!error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[JFHudMsgTool shareHusMsg]msgHud:MBProgressHUDModeText msgStr:@"保存成功，请在本地相册查看"];
            [[JFHudMsgTool shareHusMsg]hiddenHud:MBProgressHUDModeText];
        });
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


@end
