//
//  JFEditHomeSmallModel.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/2.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFBaseClassModelEdit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFEditHomeSmallModel : JFBaseClassModelEdit
@property (nonatomic, strong)NSString *logo;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *orgName;
@property (nonatomic, strong)NSString *qualified;
@property (nonatomic, strong)NSString *orgId;//组织id
@property (nonatomic, assign)BOOL isDelete;
@property (nonatomic, assign)BOOL option;//用于标志是否选中
@end

NS_ASSUME_NONNULL_END
