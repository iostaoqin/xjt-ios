//
//  JFBaseClassModelEdit.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/2.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFBaseClassModelEdit.h"

@implementation JFBaseClassModelEdit
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"new"]) {
        self.imgIdStr = [NSString stringWithFormat:@"%@", value];
    }
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"imgIdStr":@"new"};
}
@end
