//
//  JTSliderView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTSliderView : UIView
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, weak) UIImageView *bubbleImage;
@property (nonatomic, weak) UIImageView *arrowImage;
@property (nonatomic, weak) UILabel *scoreLabel;
@property (nonatomic, weak) UILabel *levelLable;
@property (nonatomic, weak) UIView *trackView;
@property (nonatomic, weak) UIImageView *thumb;
@property (nonatomic, assign)NSInteger maxValue;//最大
@property (nonatomic, assign)NSInteger minValue;//最小
@property (nonatomic, assign) NSInteger scoreValue;
@property (nonatomic, assign) BOOL clickSlider;
@end

NS_ASSUME_NONNULL_END
