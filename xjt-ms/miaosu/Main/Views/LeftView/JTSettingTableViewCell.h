//
//  JTSettingTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTSettingTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic,strong)UILabel *rightNameLable;
-(void)getLeftNameStr:(NSString *)nameStr rightNameStr:(NSString *)rightStr;
@end

NS_ASSUME_NONNULL_END
