//
//  JFNewHeaderEditView.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFNewHeaderEditView : UIView
@property  (nonatomic,  strong)UIImageView *actionBGImg;
@property (nonatomic, strong)UIImageView *hotImg;
@property (nonatomic, strong)UILabel *latestLable;
@property (nonatomic, strong)UILabel *countHotLable;
@property (nonatomic, strong)UILabel *hoursLable;//时
@property (nonatomic,  strong)UILabel *minitLable;//分
@property (nonatomic, strong)UILabel *secondsLable;//秒
@property (nonatomic, strong)NSMutableArray *latestArray;
@property (nonatomic, strong)NSTimer *countTimer;//倒计时
@property (nonatomic, strong)UIImageView *actionImg;
-(void)getLatestData:(NSMutableArray *)latestArray;
-(void)actionImgEvent;
@end

NS_ASSUME_NONNULL_END
