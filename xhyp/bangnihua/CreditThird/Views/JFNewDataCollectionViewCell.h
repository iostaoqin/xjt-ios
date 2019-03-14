//
//  JFNewDataCollectionViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/26.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFNewDataCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *detailLable;
@property (nonatomic, strong)UIImageView *nameImg;
-(void)getCardModelData:(JFThirdNewModel *)carMode;
@end

NS_ASSUME_NONNULL_END
