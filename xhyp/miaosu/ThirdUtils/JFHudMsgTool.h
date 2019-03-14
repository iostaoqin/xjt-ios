//
//  JFHudMsgTool.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/2.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFHudMsgTool : NSObject
+(instancetype)shareHusMsg;
/***
 ! 提示框
 */
@property (nonatomic, strong)MBProgressHUD *hud_msg;
-(void)msgHud:(MBProgressHUDMode )mode msgStr:(NSString  *)msg;
-(void)hiddenHud:(MBProgressHUDMode)mode;
@end

NS_ASSUME_NONNULL_END
