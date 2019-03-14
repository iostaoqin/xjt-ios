//
//  JtDetailUsersMineTableViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/29.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JtDetailUsersMineTableViewCell : UITableViewCell
@property (nonatomic,  strong)UILabel *nameLable;
@property (nonatomic,  strong)UIImageView *nameImg;
@property (nonatomic, strong)UILabel *lineLable;
@property (nonatomic,  strong)UILabel  *nameTextLable;
@property (nonatomic,  strong)UIImageView *arrowImg;
@property (nonatomic, strong)UILabel *rightNameLable;
-(void)getLeftImgStrArr:(NSArray *)imgStrArr showType:(NSInteger)idx ;
@end

NS_ASSUME_NONNULL_END
