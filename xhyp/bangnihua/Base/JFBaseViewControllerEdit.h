//
//  JFBaseViewControllerEdit.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/24.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "ViewController.h"
@interface JFBaseViewControllerEdit : UIViewController
/**
 * 修改电池栏z颜色
 */
-(void)changeBatteryColor:(NSString *)colorStr;
/**
 * !左侧导航栏   左边是 图片右侧是文字
 */

-(void)addLeftFirstBtn:(NSString *)firstLeftBtnStr secondBtn:(NSString *)secondLeftBtnStr;
-(void)firstleftEvent;
-(void)secondleftEvent;

/**
 *  左边导航栏
 *
 *  @param name         正常状态下图片名
 *  @param nameSelected 选择状态下图片名
 */
- (void)addLeftButtonItemWithImage:(NSString *)name slected:(NSString *)nameSelected;
- (void)leftBarButtonItemEvent:(id)sender;


/**
 *  左边导航栏
 *
 *  @param nameImg         左边图片名
 *  @param secondImg 右边图片名
 */
- (void)addLeftButtonItemWithImage:(NSString *)nameImg secondImg:(NSString *)secondImg;
- (void)firstCloseImgEvent:(id)sender;
- (void)secondCloseImgEvent:(id)sender;


@end


