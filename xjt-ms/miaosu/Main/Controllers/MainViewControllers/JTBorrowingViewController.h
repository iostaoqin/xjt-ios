//
//  JTBorrowingViewController.h
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTBorrowingViewController : JTBaseViewController
@property (nonatomic, strong)NSString *maxValue;
@property (nonatomic, strong)NSString *minValue;
@property (nonatomic, strong)NSMutableArray *feedarr;
@end

NS_ASSUME_NONNULL_END
