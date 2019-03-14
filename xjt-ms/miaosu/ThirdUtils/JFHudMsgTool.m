//
//  JFHudMsgTool.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/2.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFHudMsgTool.h"

@implementation JFHudMsgTool
+(instancetype)shareHusMsg{
    static JFHudMsgTool *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JFHudMsgTool alloc]init];
    });
    return _sharedClient;
}
-(void)msgHud:(MBProgressHUDMode)mode msgStr:(NSString *)msg{

    _hud_msg = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    _hud_msg.mode = mode;
    _hud_msg.label.text = msg;
    _hud_msg.label.font = [UIFont systemFontOfSize:14];
    _hud_msg.contentColor = [UIColor whiteColor];
    [_hud_msg.label setNumberOfLines:0];
    _hud_msg.bezelView.backgroundColor = [UIColor blackColor];
    _hud_msg.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud_msg.animationType = MBProgressHUDAnimationFade;
}
-(void)hiddenHud:(MBProgressHUDMode)mode{
    _hud_msg.removeFromSuperViewOnHide = YES;
    if (mode == MBProgressHUDModeText) {
        
        [_hud_msg hideAnimated:YES afterDelay:1.0f];
    }else{
        [_hud_msg hideAnimated:YES afterDelay:0.2f];
    }
}
@end
