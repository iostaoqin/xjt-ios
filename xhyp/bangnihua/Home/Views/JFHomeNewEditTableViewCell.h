//
//  JFHomeNewEditTableViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFHomeNewEditTableViewCell : UITableViewCell
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *hotImg;
@property (nonatomic, strong)UIImageView *logoImg;
@property (nonatomic, strong)UIImageView *priceImg;//钱
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *applyLable;
@property (nonatomic, strong)UILabel *priceAccountLable;
@property (nonatomic, strong)UILabel *rateLable;
@property (nonatomic, strong)UILabel *referenceRateLable;
@property (nonatomic, strong)UILabel *priceNameLable;
@property (nonatomic, strong)UIButton *applyBtn;
@property (nonatomic, strong)UILabel *lineLable;
@property (nonatomic, strong)UILabel *applyNameLable;
@property (nonatomic, strong)UIView *showView;
-(void)getGiveData:(JFGiveModel *)giveModel;
@end

NS_ASSUME_NONNULL_END
