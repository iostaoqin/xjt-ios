//
//  JTBrowingTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTSliderView.h"
#import "JTSlider.h"
NS_ASSUME_NONNULL_BEGIN

@interface JTBrowingTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *priceNameLable;
@property (nonatomic, strong)UILabel *tipsLable;
@property (nonatomic, strong)JTSliderView  *sliderView;
@property (nonatomic, strong)JTSlider  *slider;
@property (nonatomic, strong)NSString *maxValue;
@property (nonatomic, strong)NSString *minValue;
-(void)getSlideModel:(JTLoanModel *)modelSlider;

@end

NS_ASSUME_NONNULL_END
