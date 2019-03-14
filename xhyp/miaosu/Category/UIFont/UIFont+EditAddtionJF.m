//
//  UIFont+EditAddtionJF.m
//  helpSpend
//
//  Created by Daisy  on 2018/12/20.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "UIFont+EditAddtionJF.h"
CGFloat kScale = 1;

BOOL isSystemFont = YES;
@implementation UIFont (Addtion)
+ (UIFont *)kMyFontTitleSize:(CGFloat)size {
    if (isSystemFont) {
        return [UIFont boldSystemFontOfSize:size*kScale];
    }
    
    return [UIFont fontWithName:@"HiraginoSansGB-W6" size:size*kScale];
}

+ (UIFont *)kMyFontCNSize:(CGFloat)size {
    if (isSystemFont) {
        return [UIFont systemFontOfSize:size*kScale];
    }
    
    return [UIFont fontWithName:@"HiraginoSansGB-W3" size:size*kScale];
}

+ (UIFont *)kMyFontENSize:(CGFloat)size {
    if (isSystemFont) {
        return [UIFont systemFontOfSize:size*kScale];
    }
    
    return [UIFont fontWithName:@"HelveticaNeue" size:size*kScale];
}

+ (UIFont *)kMyFontENLightSize:(CGFloat)size {
    if (isSystemFont) {
        return [UIFont systemFontOfSize:size*kScale];
    }
    
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size*kScale];
}

+ (UIFont *)kMyFontSystemSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size*kScale];
}

+ (CGFloat)kSize:(CGFloat)size {
    return size*kScale;
}


+ (CGSize)kCGSize:(CGSize)size {
    return CGSizeMake(ceilf(size.width*kScale), ceilf(size.height*kScale));
}
@end
