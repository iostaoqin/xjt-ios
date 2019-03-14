//
//  JFInformationTableViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFInformationTableViewCell : UITableViewCell
@property (nonatomic,  strong)UIButton *selectedBtn;
@property (nonatomic,  strong)UIImageView *institutionsImg;
@property (nonatomic,  strong)UILabel *institutionsNameLable;
@property (nonatomic,  strong)UILabel *institutionsDetailLable;
-(void)getboundsData:(JFEditHomeSmallModel *)model;
@end

NS_ASSUME_NONNULL_END
