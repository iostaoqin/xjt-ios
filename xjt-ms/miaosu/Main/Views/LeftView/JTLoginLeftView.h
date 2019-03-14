//
//  JTLoginLeftView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/16.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol submitPortraintDelegate <NSObject>
-(void)portraintImgClick;
-(void)gotoLoginClick;
@end
@interface JTLoginLeftView : UIView
@property (nonatomic, strong)UIImageView *portraintImg;
@property (nonatomic, strong)UILabel *nameLable;
@property  (nonatomic, strong)UIView *loginView;
@property (nonatomic, strong)UIImageView *nameImg;
@property (nonatomic, strong)UIView *leftBGView;
@property (nonatomic, strong)UILabel *teleLable;
@property (nonatomic,weak)id<submitPortraintDelegate>portraintImgDelegate;
@end

NS_ASSUME_NONNULL_END
