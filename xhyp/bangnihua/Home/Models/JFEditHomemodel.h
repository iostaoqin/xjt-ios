//
//  JFEditHomemodel.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/4.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFBaseClassModelEdit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFEditHomemodel : JFBaseClassModelEdit
@property  (nonatomic, strong)NSString *tagName;//名称
@property  (nonatomic, strong)NSString *logoUrl;//名称对应的名称
@property  (nonatomic, strong)NSString *areaId;//id
@property  (nonatomic, strong)NSString *areaTagId;//id
@property (nonatomic, strong)NSString *pos;
/*倒计时 */
@property  (nonatomic, strong)NSString *num;//id
@property  (nonatomic, strong)NSString *timeStr;//id
/*轮播图*/
@property  (nonatomic, strong)NSString *adImgUrl;//轮播图图片
@property  (nonatomic, strong)NSString *url;//weburl
@property  (nonatomic, strong)NSString *platformId;//platformId
@property  (nonatomic, strong)NSString *name;//weburl
@property  (nonatomic, strong)NSString *value;//weburl
@end

NS_ASSUME_NONNULL_END
