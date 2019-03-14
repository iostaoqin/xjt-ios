//
//  JFEditHomeSecondNewCollectionViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/10.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFEditHomeSecondNewCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UILabel *nameLable;
-(void)getSecondData:(JFEditHomemodel *)secondModel;
@end

NS_ASSUME_NONNULL_END
