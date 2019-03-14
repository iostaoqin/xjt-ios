//
//  UIView+EditAddtion.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "UIView+EditAddtion.h"

@implementation UIView (Addtion)
-(void)setGradientBackgroundColor:(NSString *)firstColor secondColor:(NSString *)secondColor{
    //创建一个渐变图层
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];;
    gradientLayer.colors  = @[(__bridge id)[UIColor colorWithHexString:firstColor].CGColor,(__bridge id)[UIColor colorWithHexString:secondColor].CGColor];
    //    gradientLayer.locations =  @[@0,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint=  CGPointMake(1.0, 0.0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    gradientLayer.frame  = self.bounds;
    gradientLayer.name = @"gradientLayer";
    //生成一个imge
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //设置背景颜色
    self.backgroundColor = [UIColor colorWithPatternImage:img];
}
- (UIButton *)buttonCreateWithNorStr:(NSString *)btnStr nomalBgColor:(NSString *)colorStr  textFont:(CGFloat)font cornerRadius:(CGFloat)radius{
    UIButton  *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn  setTitle:btnStr forState:UIControlStateNormal];
    btn.backgroundColor =[UIColor colorWithHexString:colorStr];
    btn.titleLabel.font = kFontSystem(font);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = radius * JT_ADAOTER_WIDTH;
    btn.layer.masksToBounds =  YES;
    return btn;
}
- (UIButton *)buttonCreateGradientWithCornerRadius:(CGFloat)radius btnWidth:(CGFloat)width btnHeight:(CGFloat)height startLocationColor:(NSString *)startColor endLocationColor:(NSString *)endColor{
    UIButton *btn  =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius  = radius;
    btn.layer.masksToBounds  = YES;
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, width, height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:startColor] CGColor],(id)[UIColor colorWithHexString:endColor].CGColor]];//渐变数组
    [btn.layer addSublayer:gradientLayer];
    return btn;
}
@end
