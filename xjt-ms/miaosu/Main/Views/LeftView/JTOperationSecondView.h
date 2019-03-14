//
//  JTOperationSecondView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol againSubmitDelegate <NSObject>
-(void)againSubmitEvent;
@end
@interface JTOperationSecondView : UIView
@property (nonatomic,  strong)UILabel *nameLable;
@property (nonatomic,  strong)UIImageView *pointImg;
@property (nonatomic,  strong)UILabel *firstNameLable;
@property (nonatomic,  strong)UILabel *secondNameLable;
@property (nonatomic,  strong)UILabel *thirdNameLable;
@property (nonatomic,  strong)UIButton *againSubmitBtn;
@property (nonatomic, weak)id<againSubmitDelegate>delegate;
-(void)gettTiltNameStr:(NSString *)title detailStrArr:(NSArray *)detailStr showType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
