//
//  JFNewHomeEditCycleView.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/8.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFNewHomeEditCycleView : UIView
@property (nonatomic,strong)SDCycleScrollView *homeCycle;
-(void)getCycleData:(NSMutableArray *)cycleArr;
@end

NS_ASSUME_NONNULL_END
