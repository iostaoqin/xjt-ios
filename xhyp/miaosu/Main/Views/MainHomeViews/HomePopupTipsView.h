//
//  HomePopupTipsView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol closePopupDelegate <NSObject>
-(void)closePopupEvent;
@end
@interface HomePopupTipsView : UIView
@property (nonatomic, strong)UIButton *closeImg;
@property (nonatomic, strong)UIImageView *popupBgImg;
@property (nonatomic, strong)UILabel *contenLable;
@property (nonatomic, weak)id<closePopupDelegate>popupDelegate;
@end

NS_ASSUME_NONNULL_END
