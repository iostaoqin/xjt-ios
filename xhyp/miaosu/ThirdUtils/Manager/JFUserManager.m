//
//  JFUserManager.m
//  petassistant
//
//  Created by Daisy  on 2018/10/10.
//  Copyright © 2018年 com.wp. All rights reserved.
//

#import "JFUserManager.h"
#import "JFLocationHelperFile.h"
#define JFUserManagerFilePath @"JFUserManagerFilePath"

@interface JFUserManager ()
@property (nonatomic, copy) NSString *filePath;//文件路径
@end



@implementation JFUserManager
+(instancetype)shareManager{
    static JFUserManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[JFLocationHelperFile getAppDocumentPath] stringByAppendingPathComponent:JFUserManagerFilePath];
        instance = [[JFUserManager alloc]initWithPath:filePath];
    });
    return instance;
}
- (instancetype)initWithPath:(NSString *)filePath {
    if (self = [super init]) {
        _filePath = filePath;
        [self readData];
    }
    return self;
}

- (void)setCurrentUserInfo:(JFUserInfoTool *)currentUserInfo {
    _currentUserInfo = currentUserInfo;
    [self saveData];
}

//解档
- (void)readData {
    NSString *filePath = [self filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        _currentUserInfo = [object isKindOfClass:[JFUserInfoTool class]] ? object : nil;
    }
}

//归档
- (void)saveData {
    NSData *data = [NSData data];
    if (_currentUserInfo) {
        data = [NSKeyedArchiver archivedDataWithRootObject:_currentUserInfo];
    }
    [data writeToFile:[self filePath] atomically:YES];
}

@end
