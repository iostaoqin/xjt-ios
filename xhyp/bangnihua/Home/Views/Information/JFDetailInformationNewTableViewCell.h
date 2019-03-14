//
//  JFDetailInformationNewTableViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/27.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFDetailInformationNewTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UITextField *nameTextFiled;
@property (nonatomic, strong)UIImageView *focusImg;
@property (nonatomic, strong)UILabel *lineLable;
-(void)getNameData:(JFEditHomeDetailModel *)nameModel userInfoArr:(NSMutableArray *)arr;
@end

NS_ASSUME_NONNULL_END
