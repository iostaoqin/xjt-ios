//
//  JFNewLaunchingViewController.h
//  miaosu
//
//  Created by Daisy  on 2019/3/4.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^LaunchFinishBlock)(void);
@interface JFNewLaunchingViewController : JTBaseViewController
@property(nonatomic, copy)LaunchFinishBlock finishBlock;
@end

NS_ASSUME_NONNULL_END
