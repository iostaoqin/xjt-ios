//
//  JTProblemTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTProblemTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *nameLable;
@property(nonatomic, strong)UILabel *nameDetailLable;
@property(nonatomic, strong)UILabel *otherNameLable;
@property(nonatomic, strong)UILabel *otherDetailNameLable;
@property (nonatomic, strong)UILabel *lineLable;
-(void)getLeftProblemTitle:(NSString *)nameStr leftNameColor:(NSString *)colorStr;
@end

NS_ASSUME_NONNULL_END
