//
//  JTLoginView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol registedUserDelegate <NSObject>
-(void)registedClick;
-(void)forgotPasswordClick;
@end
@interface JTLoginView : UIView
@property (nonatomic, strong)UIButton *registedBtn;
@property (nonatomic, strong)UILabel *lineLable;
@property (nonatomic, strong)UIButton *forgotBtn;
@property (nonatomic, weak)id<registedUserDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
