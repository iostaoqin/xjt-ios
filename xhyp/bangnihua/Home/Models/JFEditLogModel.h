//
//  JFEditLogModel.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/10.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFBaseClassModelEdit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFEditLogModel : JFBaseClassModelEdit
/*用于提交日志*/
@property  (nonatomic, strong)NSString *tagName;//名称
@property  (nonatomic, strong)NSString *logoUrl;//名称对应的名称
@property  (nonatomic, strong)NSString *areaId;//id
@property  (nonatomic, strong)NSString *areaTagId;//id
@property (nonatomic, strong)NSString *pos;
@property (nonatomic, strong)NSMutableArray *platforms;
@end

NS_ASSUME_NONNULL_END
