//
//  JTHomeHeaderView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol homeDelegate <NSObject>
-(void)leftBarButtonItemEvent;
-(void)rightBarButtonItemEvent;
@end
@interface JTHomeHeaderView : UIView
@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic,  strong)UILabel *nameLable;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, strong)UIImageView *pointImg;
@property (nonatomic,  strong)UILabel *priceLable;
@property (nonatomic,  strong)UILabel *alreadyPriceLable;
@property (nonatomic,  strong)UILabel *remainingPriceLable;
@property (nonatomic,  strong)UILabel *tipsLable;
@property (nonatomic, weak)id<homeDelegate>delegate;
-(void)getLineofCredit:(JTLoanModel *)creditModel;
@end

NS_ASSUME_NONNULL_END
