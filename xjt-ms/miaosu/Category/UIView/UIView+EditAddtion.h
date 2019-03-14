//
//  UIView+EditAddtion.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Addtion)
-(void)setGradientBackgroundColor:(NSString *)firstColor secondColor:(NSString *)secondColor;
//快速创建button
- (UIButton *)buttonCreateWithNorStr:(NSString *)btnStr nomalBgColor:(NSString *)colorStr textFont:(CGFloat)font cornerRadius:(CGFloat)radius;
//快速创建button 背景颜色渐变
- (UIButton *)buttonCreateGradientWithCornerRadius:(CGFloat)radius btnWidth:(CGFloat)width btnHeight:(CGFloat)height startLocationColor:(NSString *)startColor endLocationColor:(NSString *)endColor;
@end

NS_ASSUME_NONNULL_END
