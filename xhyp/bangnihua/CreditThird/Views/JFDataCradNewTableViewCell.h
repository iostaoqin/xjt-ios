//
//  JFDataCradNewTableViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol selecedCardDelegate <NSObject>
-(void)leftEventClickIdx:(NSInteger)index;
-(void)rightEventClickIdx:(NSInteger)index;
@end
@interface JFDataCradNewTableViewCell : UITableViewCell<SDCycleScrollViewDelegate>
@property  (nonatomic, strong)UIButton *leftRawBtn;
@property  (nonatomic, strong)UIButton *rightRawBtn;
@property (nonatomic, assign)NSInteger seltectedIdx;
@property  (nonatomic, strong)SDCycleScrollView *sdcycleView;
@property (nonatomic,  weak)id<selecedCardDelegate>cardDelegate;
-(void)getCycleImd:(NSMutableArray *)imgArr;
@property (nonatomic, strong)NSMutableArray *temArr;//用于接收图片 数组
@end

NS_ASSUME_NONNULL_END
