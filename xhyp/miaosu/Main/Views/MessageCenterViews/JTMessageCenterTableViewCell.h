//
//  JTMessageCenterTableViewCell.h
//  miaosu
//
//  Created by Daisy  on 2019/2/18.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTMessageCenterTableViewCell : UITableViewCell
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView  *messageLogoImg;
@property (nonatomic, strong)UILabel  *tipsNameLable;
@property (nonatomic, strong)UILabel  *timeLable;
@property (nonatomic, strong)UILabel  *firstLineLable;
@property (nonatomic, strong)UILabel  *detailNameLable;
@property (nonatomic, strong)UILabel  *secondLineLable;
@property (nonatomic, strong)UIButton  *continuBtn;
-(void)getMessagedata:(JTMessageModel *)messageModel;
@end

NS_ASSUME_NONNULL_END
