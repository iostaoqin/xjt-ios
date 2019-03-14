//
//  JTDetailOrderTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTDetailOrderTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *detailNameLable;
@property (nonatomic, strong)UILabel *lineLable;
@property (nonatomic, strong)UIButton *loanImg;
-(void)getNameLeftStr:(NSString *)str rightDetailStr:(NSString *)rightStr;
-(void)getPayLeftData:(NSArray *)leftStr payModel:(JTLoanModel *)loanModel index:(NSInteger)idx;
@end

NS_ASSUME_NONNULL_END
