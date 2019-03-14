//
//  JFCardNewEditTableViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFCardNewEditTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UITextField *nameTextFiled;
@property (nonatomic, strong)UILabel *lineLable;
-(void)getNameText:(NSString *)name detailTextStr:(NSString *)textStr placeTitle:(NSString *)placeStr;
-(void)getNameModel:(JFEditHomeDetailModel *)nameModel detailTextStr:(NSString *)textStr;
@end

NS_ASSUME_NONNULL_END
