//
//  JFCardTableViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFCardTableViewCell : UITableViewCell
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *cardImg;
@property (nonatomic, strong)UILabel *cardNameLable;
@property (nonatomic, strong)UILabel *cardTypeLable;
@property (nonatomic, strong)UILabel *applyCardLable;
@property (nonatomic, strong)UILabel *lineLable;
@property (nonatomic, strong)UIImageView *typeImg;
@property (nonatomic, strong)UILabel *typeNameLable;
@property (nonatomic, strong)UIImageView *rightTypeImg;
@property (nonatomic, strong)UILabel *rightNameLable;
-(void)getCradModelData:(JFThirdNewModel *)model;
@end

NS_ASSUME_NONNULL_END
