//
//  JFLocationHelperFile.m
//  petassistant
//
//  Created by Daisy  on 2018/10/10.
//  Copyright © 2018年 com.wp. All rights reserved.
//

#import "JFLocationHelperFile.h"

@implementation JFLocationHelperFile
+ (NSString *)getAppDocumentPath {
    static NSString *appDocumentPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        appDocumentPath = paths[0];
        if (![[NSFileManager defaultManager] fileExistsAtPath:appDocumentPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:appDocumentPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    });
    return appDocumentPath;
}
@end
