//
//  UILabel+Additions.h
//  miaosu
//
//  Created by Daisy  on 2019/3/7.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Additions)
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
@end

NS_ASSUME_NONNULL_END
