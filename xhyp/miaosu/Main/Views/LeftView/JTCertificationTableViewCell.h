//
//  JTCertificationTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/19.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTCertificationTableViewCell : UITableViewCell
@property (nonatomic,  strong)UILabel *nameLable;
@property (nonatomic,  strong)UIImageView *nameImg;
@property (nonatomic, strong)UILabel *lineLable;
@property (nonatomic,  strong)UILabel  *nameTextLable;
@property (nonatomic,  strong)UIImageView *arrowImg;
@property (nonatomic, strong)UILabel *rightNameLable;
-(void)getLeftImg:(NSString *)imgStr leftNameStr:(NSString *)nameStr certicationModel:(JTCertificationModel *)model idx:(NSInteger )idx;
@end

NS_ASSUME_NONNULL_END
