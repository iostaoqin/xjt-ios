//
//  JFMainHeaderNewCollectionViewCell.h
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFMainHeaderNewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *headerImg;
@property (nonatomic, strong)UILabel *nameLable;
-(void)getHeaderImg:(NSString *)headerImg nameStr:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
