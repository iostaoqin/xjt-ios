//
//  JTMessageModel.h
//  miaosu
//
//  Created by Daisy  on 2019/3/6.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTMessageModel : JTBaseModel
@property (nonatomic,  strong)NSString  *subject;
@property (nonatomic,  strong)NSString  *messageId;
@property (nonatomic,  strong)NSString  *messageType;
@property (nonatomic,  strong)NSString  *read;
@property (nonatomic,  strong)NSString  *messageText;
@property (nonatomic,  strong)NSString  *sendDate;
@property (nonatomic,  strong)NSString  *toUserId;
@property (nonatomic,  strong)NSString  *creationDate;
@property (nonatomic,  strong)NSString  *sms;
@property (nonatomic, assign)CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
