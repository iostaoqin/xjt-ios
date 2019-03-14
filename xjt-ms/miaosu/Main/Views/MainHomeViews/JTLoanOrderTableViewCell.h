//
//  JTLoanOrderTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTLoanOrderTableViewCell : UITableViewCell
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UILabel *priceLable;
@property (nonatomic, strong)UILabel *typeLable;
@property (nonatomic, strong)UILabel *firstLineLable;
@property (nonatomic, strong)UILabel *applyTimeLable;
@property (nonatomic, strong)UILabel *detailApplyTimeLable;
@property (nonatomic, strong)UILabel *secondLineLable;
@property (nonatomic, strong)UILabel *reimbursementLable;
@property (nonatomic, strong)UILabel *reimbursementTimeLable;
@end

NS_ASSUME_NONNULL_END
