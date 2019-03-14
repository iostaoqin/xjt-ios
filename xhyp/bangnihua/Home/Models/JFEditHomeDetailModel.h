//
//  JFEditHomeDetailModel.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/2.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFBaseClassModelEdit.h"
#import "JFEditHomeSmallModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JFEditHomeDetailModel : JFBaseClassModelEdit
@property (nonatomic, strong)NSString *fieldId;
@property (nonatomic, strong)NSString *fieldName;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *area;
@property (nonatomic, strong)NSString *displyIndex;
@property (nonatomic, assign)BOOL required;
@property (nonatomic, strong)NSArray *largeLoanFieldValues;
@property (nonatomic, strong)NSString *fieldValue;
@property (nonatomic, strong)NSString *displayIndex;
@end

//@interface JFEditHomeDetailModelNew : JFBaseClassModelEdit
//@property (nonatomic, copy)NSString * fieldValue;
//@property (nonatomic, copy)NSString * desc;
//@end

NS_ASSUME_NONNULL_END
