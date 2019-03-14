//
//  JTRenewalView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol renewalViewDelegate <NSObject>
-(void)codeEvent:(UIButton *)codebtn;//获取验证码
-(void)fistBtnEventClick:(UIButton *)codebtn;//确认续期或者还款
-(void)cancelBtnEventClick;//取消弹框
-(void)secondBtnEventClick:(NSString *)codeStr;
-(void)cancelCodeSecondBtnEventClick;//取消弹框
@end
@interface JTRenewalView : UIView
//第一个弹框 的布局 
@property (nonatomic, strong)UIView *firstView;
@property (nonatomic, strong)UILabel *firstNameLable;
@property (nonatomic, strong)UILabel *firstLineLable;
@property (nonatomic, strong)UIButton *firstSureBtn;
@property (nonatomic, strong)UILabel *firstLeftNameLable;
@property (nonatomic, strong)UILabel *secondLeftNameLable;
@property (nonatomic, strong)UILabel *firstRightNameLable;
@property (nonatomic, strong)UILabel *secondRightNameLable;
@property (nonatomic, strong)UILabel *bottomLineLable;
@property (nonatomic, strong)UIButton *leftCancelBtn;

@property (nonatomic, strong)UIView *secondView;
@property (nonatomic, strong)UIButton *secondCloseBtn;
@property (nonatomic, strong)UILabel *secondNameLable;
@property (nonatomic, strong)UILabel *secondLineLable;
@property (nonatomic, strong)UIButton *secondSureBtn;
@property (nonatomic, strong)UIButton *secondCodeBtn;
@property (nonatomic, strong)UITextField *secondCodeTextFied;
@property (nonatomic, strong)UILabel *bottomSLineLable;
@property (nonatomic, strong)UIButton *leftSCancelBtn;
@property (nonatomic, strong)dispatch_source_t countdownTimer;
@property (nonatomic, weak)id<renewalViewDelegate>delegate;
-(void)getFirstContent:(NSArray *)nameArr showType:(NSString  *)type televalue:(NSString *)valexteleNumberStr;
@end

NS_ASSUME_NONNULL_END
