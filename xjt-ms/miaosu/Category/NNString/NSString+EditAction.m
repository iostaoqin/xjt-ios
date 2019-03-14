//
//  NSString+EditAction.m
//  helpSpend
//
//  Created by Daisy  on 2018/12/20.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "NSString+EditAction.h"

@implementation NSString (Addtion)
/**
 *  UILable + NSString calculation size with font
 */
- (CGSize)sizeOfNSStringWithFont:(UIFont *)font{
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    return adjustedSize;
}
- (NSInteger)subStringFromString:(NSString *)str {
    return ABS([[NSNumber numberWithLongLong:[self longLongValue]] integerValue] -
               [[NSNumber numberWithLongLong:[str longLongValue]] integerValue]);
}
@end
