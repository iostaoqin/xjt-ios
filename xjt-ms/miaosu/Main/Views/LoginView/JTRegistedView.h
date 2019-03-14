//
//  JTRegistedView.h
//  xiaojintiao
//
//  Created by Daisy  on 2019/2/15.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol registDelegate <NSObject>
-(void)registedAgreenment;
-(void)registBtnClick;
-(void)alreadyAccountClick;
@end
@interface JTRegistedView : UIView
@property (nonatomic, strong)UIImageView *registImg;
@property (nonatomic, strong)UILabel *registNameLable;
@property (nonatomic, strong)UIButton *registBtn;
@property (nonatomic, strong)UIButton *registAlreadyBtn;
@property (nonatomic, weak)id<registDelegate>registDelegate;
@end

NS_ASSUME_NONNULL_END
