//
//  JTOperationSucessTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/20.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTOperationSucessTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *nameLable;
@property(nonatomic, strong)UILabel *otherNameLable;
@property(nonatomic, strong)UIImageView *logoImg;
-(void)getLtftNameStr:(NSString *)nameStr rightNameStr:(JTCertificationModel *)rightModel showTypeIdx:(NSInteger)idx  type:(NSInteger)typeID ;
@end

NS_ASSUME_NONNULL_END
