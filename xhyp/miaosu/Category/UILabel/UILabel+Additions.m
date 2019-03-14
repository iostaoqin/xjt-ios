//
//  UILabel+Additions.m
//  miaosu
//
//  Created by Daisy  on 2019/3/7.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing{
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
    
}
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    [label setText:text lineSpacing:lineSpacing];
    [label sizeToFit];
    return label.frame.size.height;
}
@end
