//
//  JFSHLogEditTool.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/10.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum
{
    LogShowType_Home = 1,
    LogShowType_Card,
    LogShowType_BigApplySuccess,
}LogShowType;
@interface JFSHLogEditTool : NSObject
+(instancetype)requestLogMsg;
/**
 *cookieId     商家id or creditCard id
 *eventActionId  区域 id areaID
 *firstValue    pos 从下标1开始
 *secondValue     在列表中位置 从1开始
 *tagName      区域名字
 *type        //上传日志的界面
*/
+(void)logRequestCookId:(NSString *)cookieId   eventTagName:(NSString *)tagName eventAction:(NSString *)eventActionId firstEventValue:(NSString *)firstValue secondEventValue:(NSString *)secondValue showType:(LogShowType )logType;
@end

NS_ASSUME_NONNULL_END
