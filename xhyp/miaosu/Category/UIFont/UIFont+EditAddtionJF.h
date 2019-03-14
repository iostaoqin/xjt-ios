//
//  UIFont+EditAddtionJF.h
//  helpSpend
//
//  Created by Daisy  on 2018/12/20.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Addtion)
+ (UIFont *)kMyFontTitleSize:(CGFloat)size;
+ (UIFont *)kMyFontCNSize:(CGFloat)size;
+ (UIFont *)kMyFontENSize:(CGFloat)size;
+ (UIFont *)kMyFontENLightSize:(CGFloat)size;
+ (UIFont *)kMyFontSystemSize:(CGFloat)size;

+ (CGFloat)kSize:(CGFloat)size;
+ (CGSize)kCGSize:(CGSize)size;
@end
