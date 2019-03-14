//
//  JFHeaderNewCollectionViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFHeaderNewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UIView *bgView;
-(void)getHeaderImg:(NSString *)headerImg nameStr:(NSString *)name;
-(void)getSecondData:(JFEditHomemodel *)secondModel;
@end

NS_ASSUME_NONNULL_END
